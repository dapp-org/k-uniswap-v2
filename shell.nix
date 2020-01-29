with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "k-uniswap";
  buildInputs = [
    flex
    getopt
    utillinux
    git
    gnumake
    jq
    nodejs
    openjdk8
    parallel
    python2 # required to build some native modules in the uniswap-v2-core npm dependency tree
    wget
    (yarn.override { nodejs = nodejs-10_x; })
    zip
    z3
  ];
  shellHook = ''
    if [ -z "$KLAB_PATH" ]; then echo "WARNING: The environment variable KLAB_PATH should be set to point to the klab repo. Please fix and reënter the nix shell."; fi
    export PATH=$KLAB_PATH/node_modules/.bin/:$KLAB_PATH/bin:$PATH
    export KLAB_EVMS_PATH=$KLAB_PATH/evm-semantics
  '';
}
