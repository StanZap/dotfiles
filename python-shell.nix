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
    
    # cuda # this is unstable.cudatoolkit
    # cudaPackages.cudatoolkit # using stable instead so we can use same versio of libcuda from nvidia drivers

    # nodejs_22
    gcc-unwrapped
    python311Packages.python
    python311Packages.pip
    cudaPackages.cudatoolkit
  ];

  shellHook = ''
    export CUDA_ROOT="${cudaPackages.cudatoolkit}";
    export CUDA_LIB_DIR="${cudaPackages.cudatoolkit}/lib";  # Updated path
    export PATH="$CUDA_ROOT/bin:$PATH"; # this seems to be done automatically when installing the cudatoolkit

    export LD_LIBRARY_PATH="$CUDA_LIB_DIR:$LD_LIBRARY_PATH";
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH";
    export LD_LIBRARY_PATH=${gcc-unwrapped.lib}/lib:$LD_LIBRARY_PATH

    source ./venv/bin/activate;
  '';
}

