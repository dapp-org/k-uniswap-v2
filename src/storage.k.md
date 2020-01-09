# UniswapV2

```k
// pack { uint112 uint112 uint32 }
syntax Int ::= "#WordPackUInt112UInt112UInt32" "(" Int "," Int "," Int ")" [function]
rule #WordPackUInt112UInt112UInt32(X, Y, Z) => Z *Int pow224 +Int Y *Int pow112 +Int X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

syntax Int ::= "#UniswapV2.factory" [function]
rule #UniswapV2.factory => 8

syntax Int ::= "#UniswapV2.token0" [function]
rule #UniswapV2.token0 => 9

syntax Int ::= "#UniswapV2.token1" [function]
rule #UniswapV2.token1 => 10

syntax Int ::= "#UniswapV2.reserve0_reserve1_blockNumber" [function]
rule #UniswapV2.reserve0_reserve1_blockNumber => 11

syntax Int ::= "#UniswapV2.price0CumulativeLast" [function]
rule #UniswapV2.price0CumulativeLast => 12

syntax Int ::= "#UniswapV2.price1CumulativeLast" [function]
rule #UniswapV2.price1CumulativeLast => 13
```

# ERC20

```k
syntax Int ::= "#ERC20.name" [function]
rule #ERC20.name => 0

syntax Int ::= "#ERC20.symbol" [function]
rule #ERC20.symbol => 1

syntax Int ::= "#ERC20.decimals" [function]
rule #ERC20.decimals => 2

syntax Int ::= "#ERC20.totalSupply" [function]
rule #ERC20.totalSupply => 3

syntax Int ::= "#ERC20.balanceOf" "[" Int "]" [function]
rule #ERC20.balanceOf[A] => #hashedLocation("Solidity", 4, A)

syntax Int ::= "#ERC20.allowance" "[" Int "][" Int "]" [function]
rule #ERC20.allowance[A][B] => #hashedLocation("Solidity", 5, A B)

syntax Int ::= "#ERC20.DOMAIN_SEPARATOR" [function]
rule #ERC20.DOMAIN_SEPARATOR => 6

syntax Int ::= "#ERC20.nonces" "[" Int "]" [function]
rule #ERC20.nonces[A] => #hashedLocation("Solidity", 7, A)
```
