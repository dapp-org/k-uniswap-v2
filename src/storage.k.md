# UniswapV2

```k
// pack { uint112 uint112 uint32 }
syntax Int ::= "#WordPackUInt112UInt112UInt32" "(" Int "," Int "," Int ")" [function]
rule #WordPackUInt112UInt112UInt32(X, Y, Z) => Z *Int pow224 +Int Y *Int pow112 +Int X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

syntax Int ::= "#UniswapV2.name" [function]
rule #UniswapV2.name => 0

syntax Int ::= "#UniswapV2.symbol" [function]
rule #UniswapV2.symbol => 1

syntax Int ::= "#UniswapV2.decimals" [function]
rule #UniswapV2.decimals => 2

syntax Int ::= "#UniswapV2.totalSupply" [function]
rule #UniswapV2.totalSupply => 3

syntax Int ::= "#UniswapV2.balanceOf" "[" Int "]" [function]
rule #UniswapV2.balanceOf[A] => #hashedLocation("Solidity", 4, A)

syntax Int ::= "#UniswapV2.allowance" "[" Int "][" Int "]" [function]
rule #UniswapV2.allowance[A][B] => #hashedLocation("Solidity", 5, A B)

syntax Int ::= "#UniswapV2.DOMAIN_SEPARATOR" [function]
rule #UniswapV2.DOMAIN_SEPARATOR => 6

syntax Int ::= "#UniswapV2.nonces" "[" Int "]" [function]
rule #UniswapV2.nonces[A] => #hashedLocation("Solidity", 7, A)

syntax Int ::= "#UniswapV2.factory" [function]
rule #UniswapV2.factory => 8

syntax Int ::= "#UniswapV2.token0" [function]
rule #UniswapV2.token0 => 9

syntax Int ::= "#UniswapV2.token1" [function]
rule #UniswapV2.token1 => 10

syntax Int ::= "#UniswapV2.reserve0_reserve1_blockNumberLast" [function]
rule #UniswapV2.reserve0_reserve1_blockNumberLast => 11

syntax Int ::= "#UniswapV2.price0CumulativeLast" [function]
rule #UniswapV2.price0CumulativeLast => 12

syntax Int ::= "#UniswapV2.price1CumulativeLast" [function]
rule #UniswapV2.price1CumulativeLast => 13
```

# UniswapV2Factory

```k
syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 0

syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 1

syntax Int ::= "#Vat.can" "[" Int "][" Int "]" [function]
syntax Int ::= "#UniswapV2Factory.getExchange_" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange_[A][B] => #hashedLocation("Solidity", 2, A B)
```
