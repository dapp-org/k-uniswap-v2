# k-uniswap-v2

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
