let
  klab = import ./deps/klab/shell.nix;
  pkgs = klab.pkgs;

  dappSrc = builtins.fetchGit rec {
    name = "dapptools-${rev}";
    url = https://github.com/dapphub/dapptools;
    # provides solc 0.5.16
    rev = "96c4bfd228cf6e116c2d93f3e89d795bcd8b5511";
    ref = "master";
  };
  dapptools = import dappSrc {};

in
  pkgs.mkShell {
    name = "k-uniswap";
    buildInputs = klab.buildInputs ++ [
      dapptools.dapp
      pkgs.yarn
    ];
    shellHook = ''
      export NIX_PATH="nixpkgs=${pkgs.path}"
      export DAPPTOOLS=${dappSrc}

      export KLAB_PATH=${toString ./deps/klab}
      export PATH=$KLAB_PATH/node_modules/.bin/:$KLAB_PATH/bin:$PATH
      export KLAB_EVMS_PATH=$KLAB_PATH/evm-semantics
    '';
  }
