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

syntax Int ::= "#UniswapV2Exchange.reserve0_reserve1_blockNumberLast" [function]
rule #UniswapV2Exchange.reserve0_reserve1_blockNumberLast => 8

syntax Int ::= "#UniswapV2Exchange.price0CumulativeLast" [function]
rule #UniswapV2Exchange.price0CumulativeLast => 9

syntax Int ::= "#UniswapV2Exchange.price1CumulativeLast" [function]
rule #UniswapV2Exchange.price1CumulativeLast => 10

syntax Int ::= "#UniswapV2Exchange.invariantLast" [function]
rule #UniswapV2Exchange.invariantLast => 11
```

## UniswapV2Factory

```k
syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 0

syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 1

syntax Int ::= "#UniswapV2Factory.getExchange" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange[A][B] => #hashedLocation("Solidity", 2, A B)
```
