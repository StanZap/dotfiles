with import <nixpkgs> { };

let
  # unstablePkgs = import <unstable> {};
  # Import the unstable channel with allowUnfree configuration
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz") {
    config = {
      allowUnfree = true;
    };
  };
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
  ];

  shellHook = ''
    # Env Variables require for rust/tauri/dioxus to build
    export PKG_CONFIG_PATH="${openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
    export PKG_CONFIG_PATH="${libsoup}/lib/pkgconfig:$PKG_CONFIG_PATH";

    # Huggingface new home directory
    # export HF_HOME=$HOME/Doc/hf_home;

    # Require for candle to use --features=cuda
    # cuda comes with cudatoolkit but libcuda comes with nvidia drivers 
    # that's why system installed drivers libcuda must match cudatoolkit version
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH";
  '';
}

