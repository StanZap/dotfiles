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
  buildInputs = [
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
  ];

  shellHook = ''
    # Env Variables require for rust/tauri/dioxus to build
    export PKG_CONFIG_PATH="${openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
    export PKG_CONFIG_PATH="${libsoup}/lib/pkgconfig:$PKG_CONFIG_PATH";

    # Huggingface new home directory
    export HF_HOME=$HOME/Doc/hf_home;

    # Require for candle to use --features=cuda
    # cuda comes with cudatoolkit but libcuda comes with nvidia drivers 
    # that's why system installed drivers libcuda must match cudatoolkit version
    export CUDA_ROOT="${cuda}";
    export CUDA_LIB_DIR="${cuda}/lib";  # Updated path
    export PATH="$CUDA_ROOT/bin:$PATH"; # this seems to be done automatically when installing the cudatoolkit
    export LD_LIBRARY_PATH="$CUDA_LIB_DIR:$LD_LIBRARY_PATH";
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH";
  '';
}

