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
