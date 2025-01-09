with import <nixpkgs> { };

let
  # unstablePkgs = import <unstable> {};
  # Import the unstable channel with allowUnfree configuration
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = {
      allowUnfree = true;
    };
  };
  cuda = unstable.cudaPackages.cudatoolkit;
in
mkShell {
  buildInputs = with pkgs; [
    openssl.dev
    glib
    atk
    cairo
    libsoup_3
    pango
    gdk-pixbuf
    pkg-config
    gtk3
    webkitgtk_4_1
    xdotool

    # cuda # this is unstable.cudatoolkit
    cudaPackages.cudatoolkit # using stable instead so we can use same versio of libcuda from nvidia drivers

    nodejs_22

    rustup
    pkg-config
    alsa-lib
    udev
    vulkan-loader
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXi
    libxkbcommon

    koboldcpp

    android-studio
    openjdk
    android-tools
  ];

  shellHook = ''
    # Env Variables require for rust/tauri/dioxus to build
    export PKG_CONFIG_PATH="${openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
    export PKG_CONFIG_PATH="${libsoup}/lib/pkgconfig:$PKG_CONFIG_PATH";

    # Huggingface new home directory
    export HF_HOME=$HOME/Sd/HuggingFace;
    export HUGGINGFACE_HUB_CACHE=$HOME/Sd/HuggingFace/cache;
    export HUGGINGFACE_HUB_CACHE=$HOME/Sd/HuggingFace/cache;
    export TRANSFORMERS_CACHE=$HOME/Sd/HuggingFace/cache;
    export HF_DATASETS_CACHE=$HOME/Sd/HuggingFace/cache;


    # Require for candle to use --features=cuda
    # cuda comes with cudatoolkit but libcuda comes with nvidia drivers
    # that's why system installed drivers libcuda must match cudatoolkit version
    export CUDA_ROOT="${cuda}";
    export CUDA_LIB_DIR="${cuda}/lib";  # Updated path
    export PATH="$CUDA_ROOT/bin:$PATH"; # this seems to be done automatically when installing the cudatoolkit
    export LD_LIBRARY_PATH="$CUDA_LIB_DIR:$LD_LIBRARY_PATH";
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH";

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [ alsa-lib udev vulkan-loader libxkbcommon]}"


    export ANDROID_HOME="/home/dev/Android/Sdk";
    export NDK_HOME="/home/dev/Android/Sdk/ndk-bundle";
    # export JAVA_HOME=${pkgs.openjdk.home};
    # export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools";

  '';
}

