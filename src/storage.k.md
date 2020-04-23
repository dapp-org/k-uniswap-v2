# Storage Layout

### Constants

Defining shortnames for constants here allows us to keep act specification a
little less verbose.

```k
syntax Int ::= "Constants.EIP712Domain" [function]
rule Constants.EIP712Domain => keccak(#parseByteStackRaw("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")) [macro]

syntax Int ::= "Constants.PermitTypehash" [function]
rule Constants.PermitTypehash => keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")) [macro]
```

## UniswapV2Pair

### Storage

Here we name each storage key in order to be able to easily reference storage
slots from act specification `storage` blocks.

#### 0 - totalSupply

```k
syntax Int ::= "#UniswapV2Pair.totalSupply" [function]
rule #UniswapV2Pair.totalSupply => 0
```

#### 1 - balanceOf

```k
syntax Int ::= "#UniswapV2Pair.balanceOf" "[" Int "]" [function]
rule #UniswapV2Pair.balanceOf[A] => #hashedLocation("Solidity", 1, A)
```

Writes to `balanceOf[0]` are implemented via the `#hashedLocation("Solidity", 1, 0)` construct, which evaluates to `75506153327051474587906755573858019282972751592871715030499431892688993766217`.

The presence of both concrete and symbolic keys in the storage map means that `K` cannot deduce that none of the symbolic keys collide with the concrete one, and so leaves the map unsimplified.

We state here that no such collisions are possible, allowing for simplification.

```k
rule keccakIntList(A B) ==K 75506153327051474587906755573858019282972751592871715030499431892688993766217 => false
requires A =/=Int 0

rule keccakIntList(A B) ==K 75506153327051474587906755573858019282972751592871715030499431892688993766217 => false
requires 0 =/=Int A

rule 75506153327051474587906755573858019282972751592871715030499431892688993766217 ==K keccakIntList(A B) => false
requires A =/=Int 0

rule 78338746147236970124700731725183845421594913511827187288591969170390706184117 ==K keccakIntList(A B) => false
requires 0 =/=Int A
```

#### 2 - allowance

```k
syntax Int ::= "#UniswapV2Pair.allowance" "[" Int "][" Int "]" [function]
rule #UniswapV2Pair.allowance[A][B] => #hashedLocation("Solidity", 2, A B)
```

#### 3 - DOMAIN_SEPARATOR

```k
syntax Int ::= "#UniswapV2Pair.DOMAIN_SEPARATOR" [function]
rule #UniswapV2Pair.DOMAIN_SEPARATOR => 3
```

#### 4 - nonces

```k
syntax Int ::= "#UniswapV2Pair.nonces" "[" Int "]" [function]
rule #UniswapV2Pair.nonces[A] => #hashedLocation("Solidity", 4, A)
```

#### 5 - factory

```k
syntax Int ::= "#UniswapV2Pair.factory" [function]
rule #UniswapV2Pair.factory => 5
```

#### 6 - token0

```k
syntax Int ::= "#UniswapV2Pair.token0" [function]
rule #UniswapV2Pair.token0 => 6
```

#### 7 - token1

```k
syntax Int ::= "#UniswapV2Pair.token1" [function]
rule #UniswapV2Pair.token1 => 7
```

#### 8 - { reserve0 reserve1 blockTimestampLast }

```k
syntax Int ::= "#UniswapV2Pair.reserve0_reserve1_blockTimestampLast" [function]
rule #UniswapV2Pair.reserve0_reserve1_blockTimestampLast => 8
```

#### 9 - price0CumulativeLast

```k
syntax Int ::= "#UniswapV2Pair.price0CumulativeLast" [function]
rule #UniswapV2Pair.price0CumulativeLast => 9
```

#### 10 - price1CumulativeLast

```k
syntax Int ::= "#UniswapV2Pair.price1CumulativeLast" [function]
rule #UniswapV2Pair.price1CumulativeLast => 10
```

#### 11 - kLast

```k
syntax Int ::= "#UniswapV2Pair.kLast" [function]
rule #UniswapV2Pair.kLast => 11
```

#### 12 - lockState

```k
syntax Int ::= "#UniswapV2Pair.lockState" [function]
rule #UniswapV2Pair.lockState => 12
```

## UniswapV2Factory

#### 0 - feeTo

```k
syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 0
```

#### 1 - feeToSetter

```k
syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 1
```

#### 2 - getPair

```k
syntax Int ::= "#UniswapV2Factory.getPair" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getPair[A][B] => #hashedLocation("Solidity", 2, A B)
```

#### 3 - allPairs

The length of the `allPairs` array is stored at slot 3.

```k
syntax Int ::= "#UniswapV2Factory.allPairs.length" [function]
rule #UniswapV2Factory.allPairs.length => 3
```

The first address in the `allPairs` array is stored at the keccak hash of
slot 3, the number represented to here by `pair0`. Subsequent addresses are
stored at a `uint256` offset from this key.

```k
syntax Int ::= "#UniswapV2Factory.allPairs" "[" Int "]" [function]
rule #UniswapV2Factory.allPairs[N] => pair0 +Int N
```
