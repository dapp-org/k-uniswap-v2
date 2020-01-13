# UniswapV2Exchange

```k
// pack { uint112 uint112 uint32 }
syntax Int ::= "#WordPackUInt112UInt112UInt32" "(" Int "," Int "," Int ")" [function]
rule #WordPackUInt112UInt112UInt32(X, Y, Z) => Z *Int pow224 +Int Y *Int pow112 +Int X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

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

syntax Int ::= "#UniswapV2Exchange.unlocked" [function]
rule #UniswapV2Exchange.unlocked => 12
```

# UniswapV2ERC20

```k
syntax Int ::= "#UniswapV2ERC20.balanceOf" "[" Int "]" [function]
rule #UniswapV2ERC20.balanceOf[A] => #hashedLocation("Solidity", 1, A)
```

# UniswapV2Factory

```k
syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 0

syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 1

syntax Int ::= "#UniswapV2Factory.getExchange_" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange_[A][B] => #hashedLocation("Solidity", 2, A B)
```
