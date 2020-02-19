# k-uniswap-v2

In this repository we provide a formal specification for UniswapV2.

## Repository Structure

- The `src` directory contains the literate markdown spec files:

  - [uniswap.act.md](src/uniswap.act.md) - defines the [act](https://github.com/dapphub/klab/blob/master/acts.md) specification for UniswapV2.
  - [lemmas.k.md](src/lemmas.k.md) - contains supporting `K` rules for the act specification.
  - [storage.k.md](src/storage.k.md) - describes the UniswapV2 storage layout.

- `uniswap-v2-core` pins the version of the contracts used to generate the bytecode for verification.
- `deps` pins the version of [klab](https://github.com/dapphub/klab) used to generate the proofs.

## HTML Report

The behavior of the contracts specified by
[uniswap.act.md](src/uniswap.act.md) generates a series of reachability
claims, defining succeeding and reverting behavior for each function of each
contract. These reachability claims are then tested against the formal
semantics of the EVM using the klab tool for interactive proof inspection and
debugging.

An HTML version of this specification, together with links to in-browser
symbolic execution previews, is available at [dapp.ci/k-uniswap](https://dapp.ci/k-uniswap/)

## Running the specs

To prove all specs:

```
git clone --recursive https://github.com/dapp-org/k-uniswap-v2
cd k-uniswap-v2
nix-shell --command 'make prove'
```

The following commands may be useful for those intending to hack on the specs:

```sh
nix-shell   # enter dev shell
make        # build klab and contracts
make dapp   # build contracts using dapp
make waffle # build contracts using waffle
```

If you have [`direnv`](https://direnv.net/) installed, you can automaticaly enter and leave the
`nix-shell` as you enter and leave the project directory tree.
