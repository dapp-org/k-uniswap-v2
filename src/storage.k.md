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

