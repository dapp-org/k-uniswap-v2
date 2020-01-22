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

```k
syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 0

syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 1

syntax Int ::= "#UniswapV2Factory.getExchange_" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange_[A][B] => #hashedLocation("Solidity", 2, A B)

syntax Int ::= "#UniswapV2Factory.exchanges.length" [function]
rule #UniswapV2Factory.exchanges.length => 3

// exchanges: position 0 - keccak(uint256(3))
syntax Int ::= "exchanges0" [function]
rule exchanges0 => 87903029871075914254377627908054574944891091886930582284385770809450030037083 [macro]

// exchanges: position with offset
syntax Int ::= "#UniswapV2Factory.exchanges" "[" Int "]" [function]
rule #UniswapV2Factory.exchanges[N] => exchanges0 +Int N

// exchanges: max indexes before int overflow
rule chop(exchanges0 +Int N) => exchanges0 +Int N
  requires N <=Int (maxUInt256 -Int exchanges0)
```
