# Storage Layout

## Helpers

`#WordPackUInt112UInt112UInt32(X, Y, Z)` packs `X`, `Y`, and `Z` into a word.

```k
syntax Int ::= "#WordPackUInt112UInt112UInt32" "(" Int "," Int "," Int ")" [function]
rule #WordPackUInt112UInt112UInt32(X, Y, Z) => Z *Int pow224 +Int Y *Int pow112 +Int X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
```

`#bytes4(X)` returns a bytestack containing the first four bytes of `X`.

```k
syntax WordStack ::= "#bytes4" "(" Int ")" [function]
rule #bytes4(X) => #asByteStack(X >>Int 224)
  requires #rangeUInt(256, X)
```

## UniswapV2Exchange

### Constants

```k
syntax Int ::= "Constants.TransferSelector" [function]
rule Constants.TransferSelector => #asWord(#padRightToWidth(32, #bytes4(keccak(#parseByteStackRaw("transfer(address,uint256)"))))) [macro]

syntax Int ::= "Constants.PermitTypehash" [function]
rule Constants.PermitTypehash => keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")) [macro]
```

### Storage

```k
syntax Int ::= "#UniswapV2Exchange.totalSupply" [function]
rule #UniswapV2Exchange.totalSupply => 0

syntax Int ::= "#UniswapV2Exchange.balanceOf" "[" Int "]" [function]
rule #UniswapV2Exchange.balanceOf[A] => #hashedLocation("Solidity", 1, A)

syntax Int ::= "#UniswapV2Exchange.allowance" "[" Int "][" Int "]" [function]
rule #UniswapV2Exchange.allowance[A][B] => #hashedLocation("Solidity", 2, A B)

syntax Int ::= "#UniswapV2Exchange.DOMAIN_SEPARATOR" [function]
rule #UniswapV2Exchange.DOMAIN_SEPARATOR => 3

syntax Int ::= "#UniswapV2Exchange.nonces" "[" Int "]" [function]
rule #UniswapV2Exchange.nonces[A] => #hashedLocation("Solidity", 4, A)

syntax Int ::= "#UniswapV2Exchange.factory" [function]
rule #UniswapV2Exchange.factory => 5

syntax Int ::= "#UniswapV2Exchange.token0" [function]
rule #UniswapV2Exchange.token0 => 6

syntax Int ::= "#UniswapV2Exchange.token1" [function]
rule #UniswapV2Exchange.token1 => 7

syntax Int ::= "#UniswapV2Exchange.reserve0_reserve1_blockTimestampLast" [function]
rule #UniswapV2Exchange.reserve0_reserve1_blockTimestampLast => 8

syntax Int ::= "#UniswapV2Exchange.price0CumulativeLast" [function]
rule #UniswapV2Exchange.price0CumulativeLast => 9

syntax Int ::= "#UniswapV2Exchange.price1CumulativeLast" [function]
rule #UniswapV2Exchange.price1CumulativeLast => 10

syntax Int ::= "#UniswapV2Exchange.kLast" [function]
rule #UniswapV2Exchange.kLast => 11

syntax Int ::= "#UniswapV2Exchange.unlocked" [function]
rule #UniswapV2Exchange.unlocked => 12
```

## UniswapV2Factory

### Storage

```k
syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 0

syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 1

syntax Int ::= "#UniswapV2Factory.getExchange" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange[A][B] => #hashedLocation("Solidity", 2, A B)
```

The length of the `allExchanges` array is stored at slot 3.

```k
syntax Int ::= "#UniswapV2Factory.allExchanges.length" [function]
rule #UniswapV2Factory.allExchanges.length => 3
```

The first address in the `allExchanges` array is stored at the keccak hash of
slot 3, the number represented to here by `exchanges0`. Subsequent addresses are
stored at a `uint256` offset from this key.

```k
syntax Int ::= "exchanges0" [function]
rule exchanges0 => 87903029871075914254377627908054574944891091886930582284385770809450030037083 [macro]

syntax Int ::= "#UniswapV2Factory.allExchanges" "[" Int "]" [function]
rule #UniswapV2Factory.allExchanges[N] => exchanges0 +Int N
```

The largest index that can be represented at slot 3 before integer overflow is
`maxUInt256 - exchanges0`.  The maximum number of addresses that can be stored
by the `allExchanges` array is therefore `maxUInt256 - exchanges0 + 1`.

Max. exchanges: 27889059366240281169193357100633332908378892778709981755071813198463099602853

`K` applies a chop rule when getting the position offset but Solidity doesn't
do any overflow checking on the index because it is already constrained by the
length of the array. Hence we skip this constraint here.

TODO: ensure overflow protection when pushing items to the array in
`createExchange`.

```
rule chop(exchanges0 +Int N) => exchanges0 +Int N
```
