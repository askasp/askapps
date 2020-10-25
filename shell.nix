with import <nixpkgs> {};
let
  my-python-packages = python-packages: with python-packages; [
    pip
    setuptools
  ];

  python-with-my-packages = pkgs.python3.withPackages my-python-packages;

  # define packages to install with special handling for OSX
  basePackages = [
    gnumake
    gcc
    readline
    openssl
    zlib
    libxml2
    curl
    libiconv
    elixir_1_10
    glibcLocales
    nodejs-12_x
    yarn
    postgresql
    inotify-tools
    python-with-my-packages
  ];

  inputs = if pkgs.system == "x86_64-darwin" then
    basePackages ++ [ pkgs.darwin.apple_sdk.frameworks.CoreServices ]
  else
    basePackages;

  # define shell startup command
  hooks = ''
    export PS1='\n\[\033[1;32m\][nix-shell:\w]($(git rev-parse --abbrev-ref HEAD))\$\[\033[0m\] '
    # this allows python to work locally
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.7/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
    # this allows mix to work on the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export PATH=$PATH:$(pwd)/_build/pip_packages/bin:/home/ask/opt/
    
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';

in pkgs.stdenv.mkDerivation {
  name = "elixir-19-shell";
  buildInputs = inputs;
  shellHook = hooks;
}
