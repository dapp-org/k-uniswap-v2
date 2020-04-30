UniswapV2Factory
================

## Accessors

### feeTo

Returns the address to which fees are minted.

```act
behaviour feeTo of UniswapV2Factory
interface feeTo()

for all

    To : address

storage

    feeTo |-> To

iff

    VCallValue == 0

returns To
```

### feeToSetter

Returns the address that is allowed to update `feeTo`.

```act
behaviour feeToSetter of UniswapV2Factory
interface feeToSetter()

for all

    Setter : address

storage

    feeToSetter |-> Setter

iff

    VCallValue == 0

returns Setter
```

### getPair

Returns the exchange address for a given pair of tokens. In practice, token
arguments can be provided in any order `(A, B)` or `(B, A)` because
`createPair` stores two records - one for each pairing.

```act
behaviour getPair of UniswapV2Factory
interface getPair(address tokenA, address tokenB)

for all

    Pair : address

storage

    getPair[tokenA][tokenB] |-> Pair

iff

    VCallValue == 0

returns Pair
```

### allPairs

`allPairs` is an array which stores the address of every exchange created
using the `Factory`.

`pair0` is a concrete value, representing the storage key of the first
array element (the keccak hash of slot 3). Subsequent array elements are stored
at an offset from this value: `pair0 + index`.

The maximum number of addresses that can be stored by the `allPairs` array
before overflow is `(maxUInt256 - pair0) + 1`.

We do not currently specify the behaviour of the array after overflow has occured.

```act
behaviour allPairs of UniswapV2Factory
interface allPairs(uint256 index)

for all

    Pair   : address
    Length : uint256

storage

    allPairs.length |-> Length
    allPairs[index] |-> Pair

iff

    Length > index
    VCallValue == 0

if

    // Ignore array overflow
    Length <= maxPairs

returns Pair
```

### allPairsLength

Returns the total number of exchange pairs created by this factory by querying the
length of the `allPairs` array.

```act
behaviour allPairsLength of UniswapV2Factory
interface allPairsLength()

for all

    Length : uint256

storage

    allPairs.length |-> Length

iff

    VCallValue == 0

returns Length
```

## Mutators

### updating the fee setter

The current fee setter can appoint a new fee setter.

```act
behaviour setFeeToSetter of UniswapV2Factory
interface setFeeToSetter(address usr)

for all

    Setter : address

storage

    feeToSetter |-> Setter => usr

iff
    VCallValue == 0
    CALLER_ID == Setter
```

### updating the fee recipient

The current fee setter can appoint a new fee recipient.

 ```act
behaviour setFeeTo of UniswapV2Factory
interface setFeeTo(address usr)

for all

    FeeTo  : address
    Setter : address

storage

    feeToSetter |-> Setter
    feeTo       |-> FeeTo => usr

iff

    VCallValue == 0
    CALLER_ID == Setter
```

### createPair

`createPair` allows anyone to create a new instance of the `UniswsapV2Pair`
exchange contract by providing a pair of token addresses.

Token address arguments are not valid if equal to zero, or if they are equal to
each other.

The address of the new exchange will be constant for any given token pair,
regardless of the order in which they are provided.

The address of every new exchange pair is added to the `allPairs` array, which is
primarily used by the contract to provide a count of all created pairs. The
maximum number of exchange pairs which can be created before overflowing the array
is:
```
87,903,029,871,075,914,254,377,627,908,054,574,944,891,091,886,930,582,284,385,770,809,450,030,037,083
```
We don't specify the behaviour of `createPair` after array overflow.

```act
behaviour createPair-lt of UniswapV2Factory
interface createPair(address tokenA, address tokenB)

for all

    Pair             : address UniswapV2Pair
    Length           : uint256
    Domain_separator : uint256
    Empty            : address
    Any              : address

creates storage Pair

    // Set during contract creation
    #UniswapV2Pair.lockState        |-> 1
    #UniswapV2Pair.DOMAIN_SEPARATOR |-> Domain_separator

    // Set via initialize
    #UniswapV2Pair.factory          |-> ACCT_ID
    #UniswapV2Pair.token0           |-> tokenA
    #UniswapV2Pair.token1           |-> tokenB

storage

    #UniswapV2Factory.getPair[tokenA][tokenB] |-> Empty  => Pair
    #UniswapV2Factory.getPair[tokenB][tokenA] |-> 0      => Pair
    #UniswapV2Factory.allPairs[Length]        |-> Any    => Pair
    #UniswapV2Factory.allPairs.length         |-> Length => Length + 1

gas

    ( (#if (notBool ( Junk_5 ==K 0 ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_5 ==K 0 ) andBool ( Junk_5 ==K 0 ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if (notBool ( Junk_6 ==K 0 ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_6 ==K 0 ) andBool ( Junk_6 ==K 0 ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if ( ( Length ==K ( Length +Int 1 ) ) orBool (notBool ( Junk_8 ==K Length ) ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_8 ==K 0 ) andBool (notBool ( ( Length ==K ( Length +Int 1 ) ) orBool (notBool ( Junk_8 ==K Length ) ) ) ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if ( ( Any ==K Pair ) orBool (notBool ( Junk_7 ==K Any ) ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_7 ==K 0 ) andBool (notBool ( ( Any ==K Pair ) orBool (notBool ( Junk_7 ==K Any ) ) ) ) ) #then 15000 #else 0 #fi) +Int 2414776 ) ) ) ) ) ) ) )

iff

    tokenA =/= 0
    tokenA =/= tokenB
    Empty == 0
    VCallValue == 0

if

    // The new exchange address
    Pair == #newAddr(                                 \
      ACCT_ID,                                        \
      keccak(                                         \
        #take(20, #asByteStack(tokenA <<Int 96)) ++   \
        #take(20, #asByteStack(tokenB <<Int 96))      \
      ),                                              \
      UniswapV2Pair_bin                               \
    )

    // The domain separator is set when the new
    // exchange is created
    Domain_separator == keccakIntList(                \
        Constants.EIP712Domain                        \
        keccak(#parseByteStackRaw("Uniswap V2"))      \
        keccak(#parseByteStackRaw("1"))               \
        VChainId                                      \
        Pair                                          \
    )

    // Ignore array overflow
    Length <= maxPairs

    tokenA < tokenB
    VCallDepth < 1024

calls

    UniswapV2Pair.initialize

returns Pair
```

```act
behaviour createPair-gt of UniswapV2Factory
interface createPair(address tokenA, address tokenB)

for all

    Pair             : address UniswapV2Pair
    Length           : uint256
    Domain_separator : uint256
    Empty            : address
    Any              : address

creates storage Pair

    // Set during contract creation
    #UniswapV2Pair.lockState        |-> 1
    #UniswapV2Pair.DOMAIN_SEPARATOR |-> Domain_separator

    // Set via initialize
    #UniswapV2Pair.factory          |-> ACCT_ID
    #UniswapV2Pair.token0           |-> tokenB
    #UniswapV2Pair.token1           |-> tokenA

storage

    #UniswapV2Factory.getPair[tokenB][tokenA] |-> Empty  => Pair
    #UniswapV2Factory.getPair[tokenA][tokenB] |-> 0      => Pair
    #UniswapV2Factory.allPairs[Length]        |-> Any    => Pair
    #UniswapV2Factory.allPairs.length         |-> Length => Length + 1

gas

    ( (#if (notBool ( Junk_5 ==K 0 ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_5 ==K 0 ) andBool ( Junk_5 ==K 0 ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if (notBool ( Junk_6 ==K 0 ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_6 ==K 0 ) andBool ( Junk_6 ==K 0 ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if ( ( Length ==K ( Length +Int 1 ) ) orBool (notBool ( Junk_8 ==K Length ) ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_8 ==K 0 ) andBool (notBool ( ( Length ==K ( Length +Int 1 ) ) orBool (notBool ( Junk_8 ==K Length ) ) ) ) ) #then 15000 #else 0 #fi) +Int \
    ( (#if ( ( Any ==K Pair ) orBool (notBool ( Junk_7 ==K Any ) ) ) #then 0 #else 4200 #fi) +Int \
    ( (#if ( ( Junk_7 ==K 0 ) andBool (notBool ( ( Any ==K Pair ) orBool (notBool ( Junk_7 ==K Any ) ) ) ) ) #then 15000 #else 0 #fi) +Int 2414786 ) ) ) ) ) ) ) )

iff

    tokenB =/= 0
    tokenA =/= tokenB
    Empty == 0
    VCallValue == 0

if

    // The new exchange address
    Pair == #newAddr(                                 \
      ACCT_ID,                                        \
      keccak(                                         \
        #take(20, #asByteStack(tokenB <<Int 96)) ++   \
        #take(20, #asByteStack(tokenA <<Int 96))      \
      ),                                              \
      UniswapV2Pair_bin                               \
    )

    // The domain separator is set when the new
    // exchange is created
    Domain_separator == keccakIntList(                \
        Constants.EIP712Domain                        \
        keccak(#parseByteStackRaw("Uniswap V2"))      \
        keccak(#parseByteStackRaw("1"))               \
        VChainId                                      \
        Pair                                          \
    )

    // Ignore array overflow
    Length <= maxPairs

    tokenB < tokenA
    VCallDepth < 1024

calls

    UniswapV2Pair.initialize

returns Pair
```

UniswapV2Pair
=============

## Accessors

### MINIMUM_LIQUIDITY

```act
behaviour MINIMUM_LIQUIDITY of UniswapV2Pair
interface MINIMUM_LIQUIDITY()

iff

    VCallValue == 0

returns 1000
```

### factory

```act
behaviour factory of UniswapV2Pair
interface factory()

for all

    Factory : address

storage

    factory |-> Factory

iff

    VCallValue == 0

returns Factory
```

### token0

```act
behaviour token0 of UniswapV2Pair
interface token0()

for all

    Token0 : address

storage

    token0 |-> Token0

iff

    VCallValue == 0

returns Token0
```

### token1

```act
behaviour token1 of UniswapV2Pair
interface token1()

for all

    Token1 : address

storage

    token1 |-> Token1

iff

    VCallValue == 0

returns Token1
```

### price0CumulativeLast

```act
behaviour price0CumulativeLast of UniswapV2Pair
interface price0CumulativeLast()

for all

    Price0 : uint256

storage

    price0CumulativeLast |-> Price0

iff

    VCallValue == 0

returns Price0
```

### price1CumulativeLast

```act
behaviour price1CumulativeLast of UniswapV2Pair
interface price1CumulativeLast()

for all

    Price1 : uint256

storage

    price1CumulativeLast |-> Price1

iff

    VCallValue == 0

returns Price1
```

```act
behaviour kLast of UniswapV2Pair
interface kLast()

for all

    KLast : uint256

storage

    kLast |-> KLast

iff

    VCallValue == 0

returns KLast
```

### getReserves

```act
behaviour getReserves of UniswapV2Pair
interface getReserves()

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32

storage

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast)

iff

    VCallValue == 0

returns Reserve0 : Reserve1 : BlockTimestampLast
```

## Mutators

### initialize

```act
behaviour initialize of UniswapV2Pair
interface initialize(address _token0, address _token1)

for all

    Factory : address

storage

    factory |-> Factory
    token0  |-> _ => _token0
    token1  |-> _ => _token1

iff

    CALLER_ID  == Factory
    VCallValue == 0
```

### Burn

The `burn` function burns all the liquidity tokens owned by the pair
contract and sends a proportional amount of each token in the pair to the
address specified by `to`.
Sending liquidity tokens to the contract and calling `burn` should happen
atomically, otherwise the tokens can be withdrawn by a third-party with a call
to `skim`.

`burn` also optionally generates protocol fees, if the value of `feeTo` is not
`0`. The fees are sent to the `feeTo` address.

This function requires that the `UniswapV2Pair` contract's balance of the
two pair tokens does not exceed `MAX_UINT_112 - 1`.

There are 6 specs for `burn`:

`feeOn`specs:
- `klast == 0`
- `klast =/= 0`
    - `fee == 0`
    - `fee =/= 0`
`feeOff` specs:
- `klast == 0`
- `klast =/= 0`

The variants on `feeOn` are there to clearly display how the function behaves in
these two states. The variants on `kLast` are there for performance reasons, to
ensure the proofs run in a reasonable amount of time, without causing timeouts
or out-of-memory errors.

There are other possible variants which we're not exploring here:
- `totalSupply == 0`
- `feeTo == CALLER_ID`
- `to == CALLER_ID`

The `totalSupply == 0` variant would cover the case when `burn` is called when
no liquidity has been minted yet. In that case, there will be a division by
zero, which will cause the caller to lose their gas. This scenario is relatively
rare and relatively low-risk, so it hasn't been prioritized.

The `feeTo == CALLER_ID` and `to == CALLER_ID` variants would require a separate
spec to work around storage collisions. Because these variants do not
meaningfully affect the security of the system, they haven't been prioritized.

#### FeeOn variants

##### KLast == 0

```act
behaviour burn-feeOn-kLastZero of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    Balance_FeeTo      : uint256
    Balance0           : uint112
    Balance1           : uint112
    Balance0_To        : uint256
    Balance1_To        : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => #WordPackUInt112UInt112UInt32((Balance0 - Amount0), (Balance1 - Amount1), BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
    kLast |-> KLast => (Balance0 - Amount0) * (Balance1 - Amount1)
    totalSupply |-> Supply => Supply - Balance
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease0 + Price0) #else Price0 #fi
    price1CumulativeLast |-> Price1 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease1 + Price1) #else Price1 #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> Balance0 => (Balance0 - Amount0)
    balanceOf[to] |-> Balance0_To => (Balance0_To + Amount0)


storage Token1

    balanceOf[ACCT_ID] |-> Balance1 => (Balance1 - Amount1)
    balanceOf[to] |-> Balance1_To => (Balance1_To + Amount1)

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    FeeOn := FeeTo =/= 0
    Amount0 := (Balance * Balance0) / Supply
    Amount1 := (Balance * Balance1) / Supply
    BlockTimestamp := TIME mod pow32
    TimeElapsed := (BlockTimestamp -Word BlockTimestampLast ) mod pow32
    PriceIncrease0 := ((pow112 * Reserve1) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((pow112 * Reserve0) / Reserve1) * TimeElapsed

iff in range uint256

    // burn
    Balance * Balance0
    Balance * Balance1
    Amount0
    Amount1

    Supply - Balance

    // _safeTransfer
    Balance0_To + Amount0
    Balance1_To + Amount1

iff in range uint112

    // _safeTransfer
    Balance0 - Amount0
    Balance1 - Amount1

iff

    Amount0 > 0
    Amount1 > 0

    LockState == 1
    VCallValue == 0
    VCallDepth < 1024

if

    // variant: diff
    to =/= ACCT_ID
    // variant: feeTo-diff
    FeeTo =/= ACCT_ID
    FeeTo =/= 0

    // variant: no supply
    Supply =/= 0
    KLast == 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Pair.transfer-diff
    UniswapV2Factory.feeTo
```

##### KLast =/= 0

###### Fee == 0

```act
behaviour burn-feeOn-kLastNonZero-feeZero of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    Balance_FeeTo      : uint256
    Balance0           : uint112
    Balance1           : uint112
    Balance0_To        : uint256
    Balance1_To        : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> \
        #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => \
        #WordPackUInt112UInt112UInt32((Balance0 - Amount0), (Balance1 - Amount1), BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
            (Balance0 - Amount0) * (Balance1 - Amount1)
    totalSupply |-> Supply => upply - Balance
        #fi
    balanceOf[FeeTo] |-> Balance_FeeTo => Balance_FeeTo
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 =>                                        \
        #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then \
            chop(PriceIncrease0 + Price0)                                     \
        #else                                                                 \
            Price0                                                            \
        #fi
    price1CumulativeLast |-> Price1 =>                                        \
        #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then \
            chop(PriceIncrease1 + Price1)                                     \
        #else                                                                 \
            Price1                                                            \
        #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> Balance0 => (Balance0 - Amount0)
    balanceOf[to] |-> Balance0_To => (Balance0_To + Amount0)


storage Token1

    balanceOf[ACCT_ID] |-> Balance1 => (Balance1 - Amount1)
    balanceOf[to] |-> Balance1_To => (Balance1_To + Amount1)

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    FeeOn := FeeTo =/= 0
    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    Fee := (Supply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)
    Minting := (KLast =/= 0) and FeeOn and (RootK > RootKLast) and (Fee > 0)
    Amount0 := (Balance * Balance0) / Supply
    Amount1 := (Balance * Balance1) / Supply
    BlockTimestamp := TIME mod pow32
    TimeElapsed := (BlockTimestamp -Word BlockTimestampLast ) mod pow32
    PriceIncrease0 := ((pow112 * Reserve1) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((pow112 * Reserve0) / Reserve1) * TimeElapsed

iff in range uint256

    // _mintFee
    Reserve0 * Reserve1
    RootK
    RootKLast

    // burn
    Balance * Balance0
    Balance * Balance1
    Amount0
    Amount1
    Supply - Balance

    Balance0_To + Amount0
    Balance1_To + Amount1

iff in range uint112

    Balance0 - Amount0
    Balance1 - Amount1

iff

    RootK > RootKLast impliesBool (                       \
            #rangeUInt(256, RootK - RootKLast)            \
        and #rangeUInt(256, Supply * (RootK - RootKLast)) \
        and #rangeUInt(256, RootK * 5)                    \
        and #rangeUInt(256, (RootK * 5) + RootKLast)      \
    )

    Amount0 > 0
    Amount1 > 0

    LockState == 1

    VCallValue == 0
    VCallDepth < 1024

if

    Fee == 0

    to =/= ACCT_ID
    FeeTo =/= ACCT_ID
    FeeTo =/= 0

    // variant: no supply
    Supply =/= 0
    KLast =/= 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo
```

###### Fee == 0

```act
behaviour burn-feeOn-kLastNonZero-feeNonZero of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    Balance_FeeTo      : uint256
    Balance0           : uint112
    Balance1           : uint112
    Balance0_To        : uint256
    Balance1_To        : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> \
        #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => \
        #WordPackUInt112UInt112UInt32((Balance0 - Amount0), (Balance1 - Amount1), BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
    kLast |-> KLast => (Balance0 - Amount0) * (Balance1 - Amount1)
    totalSupply |-> Supply => (Supply + Fee) - Balance
    balanceOf[FeeTo] |-> Balance_FeeTo => Balance_FeeTo + Fee
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 =>                                        \
        #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then \
            chop(PriceIncrease0 + Price0)                                     \
        #else                                                                 \
            Price0                                                            \
        #fi
    price1CumulativeLast |-> Price1 =>                                        \
        #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then \
            chop(PriceIncrease1 + Price1)                                     \
        #else                                                                 \
            Price1                                                            \
        #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> Balance0 => Balance0 - Amount0
    balanceOf[to] |-> Balance0_To => Balance0_To + Amount0


storage Token1

    balanceOf[ACCT_ID] |-> Balance1 =>  \ (Balance1 - Amount1) \
    balanceOf[to] |-> Balance1_To =>       \ (Balance1_To + Amount1) \

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    FeeOn := FeeTo =/= 0
    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    Fee := (Supply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)
    Minting := (KLast =/= 0) and FeeOn and (RootK > RootKLast) and (Fee > 0)
    Amount0 := (Balance * Balance0) / (Supply + Fee)
    Amount1 := (Balance * Balance1) / (Supply + Fee)
    BlockTimestamp := TIME mod pow32
    TimeElapsed := (BlockTimestamp -Word BlockTimestampLast ) mod pow32
    PriceIncrease0 := ((pow112 * Reserve1) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((pow112 * Reserve0) / Reserve1) * TimeElapsed

iff in range uint256

    // _mintFee
    Reserve0 * Reserve1
    RootK
    RootKLast

    // burn
    Balance * Balance0
    Balance * Balance1
    Amount0
    Amount1
    Supply - Balance

    Balance0_To + Amount0
    Balance1_To + Amount1

iff in range uint112

   Balance0 - Amount0
   Balance1 - Amount1

iff

    RootK > RootKLast impliesBool (                       \
            #rangeUInt(256, RootK - RootKLast)            \
        and #rangeUInt(256, Supply * (RootK - RootKLast)) \
        and #rangeUInt(256, RootK * 5)                    \
        and #rangeUInt(256, (RootK * 5) + RootKLast)      \
        and #rangeUInt(256, Fee)                          \
        and #rangeUInt(256, Supply + Fee)                 \
        and #rangeUInt(256, Balance_FeeTo + Fee)          \
    )

    Amount0 > 0
    Amount1 > 0

    LockState == 1

    VCallValue == 0
    VCallDepth < 1024

if

    Fee =/= 0

    to =/= ACCT_ID
    FeeTo =/= ACCT_ID
    FeeTo =/= 0

    // variant: no supply
    Supply =/= 0
    KLast =/= 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo
```

#### FeeOff variants

##### KLast == 0

```act
behaviour burn-feeOff-kLastZero of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    Balance_FeeTo      : uint256
    Balance0           : uint112
    Balance1           : uint112
    Balance0_To        : uint256
    Balance1_To        : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => #WordPackUInt112UInt112UInt32((Balance0 - Amount0), (Balance1 - Amount1), BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
    kLast |-> KLast => 0
    totalSupply |-> Supply => Supply - Balance
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease0 + Price0) #else Price0 #fi
    price1CumulativeLast |-> Price1 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease1 + Price1) #else Price1 #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> Balance0 => (Balance0 - Amount0)
    balanceOf[to] |-> Balance0_To => (Balance0_To + Amount0)


storage Token1

    balanceOf[ACCT_ID] |-> Balance1 => (Balance1 - Amount1)
    balanceOf[to] |-> Balance1_To => (Balance1_To + Amount1)

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    Amount0 := (Balance * Balance0) / Supply
    Amount1 := (Balance * Balance1) / Supply
    BlockTimestamp := TIME mod pow32
    TimeElapsed := (BlockTimestamp -Word BlockTimestampLast ) mod pow32
    PriceIncrease0 := ((pow112 * Reserve1) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((pow112 * Reserve0) / Reserve1) * TimeElapsed

iff in range uint256

    // burn
    Balance * Balance0
    Balance * Balance1
    Amount0
    Amount1

    Supply - Balance

    // _safeTransfer
    Balance0_To + Amount0
    Balance1_To + Amount1

iff in range uint112

    // _safeTransfer
    Balance0 - Amount0
    Balance1 - Amount1

iff

    Amount0 > 0
    Amount1 > 0

    LockState == 1
    VCallValue == 0
    VCallDepth < 1024

if

    // variant: diff
    to =/= ACCT_ID

    FeeTo == 0
    KLast == 0

    // variant: no supply
    Supply =/= 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Pair.transfer-diff
    UniswapV2Factory.feeTo
```

##### KLast =/= 0

```act
behaviour burn-feeOff-kLastNonZero of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    Balance_FeeTo      : uint256
    Balance0           : uint112
    Balance1           : uint112
    Balance0_To        : uint256
    Balance1_To        : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => #WordPackUInt112UInt112UInt32((Balance0 - Amount0), (Balance1 - Amount1), BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
    kLast |-> KLast => 0
    totalSupply |-> Supply => Supply - Balance
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease0 + Price0) #else Price0 #fi
    price1CumulativeLast |-> Price1 => #if (TimeElapsed > 0) and (Reserve0 =/= 0) and (Reserve1 =/= 0) #then chop(PriceIncrease1 + Price1) #else Price1 #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> Balance0 => (Balance0 - Amount0)
    balanceOf[to] |-> Balance0_To => (Balance0_To + Amount0)


storage Token1

    balanceOf[ACCT_ID] |-> Balance1 => (Balance1 - Amount1)
    balanceOf[to] |-> Balance1_To => (Balance1_To + Amount1)

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    Amount0 := (Balance * Balance0) / Supply
    Amount1 := (Balance * Balance1) / Supply
    BlockTimestamp := TIME mod pow32
    TimeElapsed := (BlockTimestamp -Word BlockTimestampLast ) mod pow32
    PriceIncrease0 := ((pow112 * Reserve1) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((pow112 * Reserve0) / Reserve1) * TimeElapsed

iff in range uint256

    // burn
    Balance * Balance0
    Balance * Balance1
    Amount0
    Amount1

    Supply - Balance

    // _safeTransfer
    Balance0_To + Amount0
    Balance1_To + Amount1

iff in range uint112

    // _safeTransfer
    Balance0 - Amount0
    Balance1 - Amount1

iff

    Amount0 > 0
    Amount1 > 0

    LockState == 1
    VCallValue == 0
    VCallDepth < 1024

if

    // variant: diff
    to =/= ACCT_ID

    FeeTo == 0
    KLast =/= 0

    // variant: no supply
    Supply =/= 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Pair.transfer-diff
    UniswapV2Factory.feeTo
```

### Sync

```act
behaviour sync of UniswapV2Pair
interface sync()

for all

    LockState          : uint256
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Price0             : uint256
    Price1             : uint256
    Balance0           : uint256
    Balance1           : uint256
    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32

storage

    lockState |-> LockState => LockState
    token0    |-> Token0
    token1    |-> Token1

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => \
      #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    price0CumulativeLast |-> Price0 =>                                                                                      \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and (((TIME mod pow32) -Word BlockTimestampLast) mod pow32) > 0                 \
        #then chop(((((pow112 * Reserve1) / Reserve0) * (((TIME mod pow32) -Word BlockTimestampLast) mod pow32)) + Price0)) \
        #else Price0                                                                                                        \
      #fi

    price1CumulativeLast |-> Price1 =>                                                                                      \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and (((TIME mod pow32) -Word BlockTimestampLast) mod pow32) > 0                 \
        #then chop(((((pow112 * Reserve0) / Reserve1) * (((TIME mod pow32) -Word BlockTimestampLast) mod pow32)) + Price1)) \
        #else Price1                                                                                                        \
      #fi

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

iff in range uint112

    Balance0
    Balance1

iff

    LockState  == 1
    VCallValue == 0
    VCallDepth  < 1024

calls

    UniswapV2Pair.balanceOf
```

### Skim

```act
behaviour skim of UniswapV2Pair
interface skim(address to)

for all

    LockState          : uint256
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    SrcBal0            : uint256
    SrcBal1            : uint256
    DstBal0            : uint256
    DstBal1            : uint256
    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32

storage

    lockState |-> LockState => LockState
    token0    |-> Token0
    token1    |-> Token1
    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast)

storage Token0

    balanceOf[ACCT_ID] |-> SrcBal0 => Reserve0
    balanceOf[to]      |-> DstBal0 => DstBal0 + (SrcBal0 - Reserve0)

storage Token1

    balanceOf[ACCT_ID] |-> SrcBal1 => Reserve1
    balanceOf[to]      |-> DstBal1 => DstBal1 + (SrcBal1 - Reserve1)

iff in range uint256

    SrcBal0 - Reserve0
    DstBal0 + (SrcBal0 - Reserve0)

    SrcBal1 - Reserve1
    DstBal1 + (SrcBal1 - Reserve1)

iff

    LockState   == 1
    VCallValue  == 0
    VCallDepth   < 1024

if

    to =/= ACCT_ID

calls

    UniswapV2Pair.balanceOf
```

```act
behaviour skim-back of UniswapV2Pair
interface skim(address to)

for all

    LockState          : uint256
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    SrcBal0            : uint256
    SrcBal1            : uint256
    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32

storage

    lockState |-> LockState => LockState
    token0    |-> Token0
    token1    |-> Token1
    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast)

storage Token0

    balanceOf[ACCT_ID] |-> SrcBal0 => SrcBal0

storage Token1

    balanceOf[ACCT_ID] |-> SrcBal1 => SrcBal1

iff in range uint256

    SrcBal0 - Reserve0
    SrcBal1 - Reserve1

iff

    LockState  == 1
    VCallValue == 0
    VCallDepth  < 1024

if

    to == ACCT_ID

calls

    UniswapV2Pair.balanceOf
```

### Mint

`mint` allows anyone to mint new liquidity tokens to the `to` address in return for adding tokens to
the pool.

6 specs in total are required to exhaustively cover the behaviour. They cover the following cases:

- no fee minted (`FeeLiquidity == 0`)
  - first call to contract (`TotalSupply == 0`)
    - diff: `to =/= 0`
    - same: `to == 0`
  - subsequent call to contract (`TotalSupply > 0`
    - lt: `(Amount0 * TotalSupply) / Reserve0 < (Amount1 * TotalSupply) / Reserve1`
    - gte: `(Amount0 * TotalSupply) / Reserve0 >= (Amount1 * TotalSupply) / Reserve1`
- fee minted (`FeeLiquidity > 0`)
  - diff: `to =/= FeeTo`
  - same: `to == FeeTo`

The decomposition into both `diff` and `same` cases, and fee and no fee cases, is required to avoid
logical inconsistencies when writing to multiple locations within the same storage mapping in a
single spec. The decomposition into first / subsequent cases in the no fee minted branch is a
performance optimization to keep proof times somewhat reasonable.

#### `mint`: no fee minted

```act
behaviour mint-noFee-first-diff of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    DstBal      : uint256
    Burned      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share minting ---

    MINIMUM_LIQUIDITY := 1000

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // --- reentrancy guard ---

    lockState |-> LockState => LockState

    // --- cache invariant ---

    kLast |-> KLast => #if FeeOn #then Balance0 * Balance1 #else 0 #fi

    // --- mint tokens ---

    balanceOf[to] |-> DstBal      => DstBal + #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY
    balanceOf[0]  |-> Burned      => Burned + MINIMUM_LIQUIDITY
    totalSupply   |-> TotalSupply => TotalSupply + #sqrt(Amount0 * Amount1)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Amount0 * Amount1
    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

    Burned + MINIMUM_LIQUIDITY

    DstBal + #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

iff

    // --- conditional artihmetic safety checks (_mintFee) ---

    (FeeOn) impliesBool #rangeUInt(256, Balance0 * Balance1)

    (FeeOn and KLast > 0) impliesBool #rangeUInt(256, Reserve0 * Reserve1)

    (FeeOn and KLast > 0 and RootK > RootKLast) impliesBool ( \
          #rangeUInt(256, RootK * 5)                          \
      and #rangeUInt(256, RootK * 5 + RootKLast)              \
      and #rangeUInt(256, RootK - RootKLast)                  \
      and #rangeUInt(256, TotalSupply * (RootK - RootKLast))  \
    )

    // --- LP shares must be minted ---

    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY > 0

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- no fee minting ---

    FeeLiquidity == 0

    // --- no storage collisions ---

    to =/= 0

    // --- first call ---

    TotalSupply == 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY
```

```act
behaviour mint-noFee-first-same of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    Burned      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share minting ---

    MINIMUM_LIQUIDITY := 1000

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // --- reentrancy guard ---

    lockState |-> LockState => LockState

    // --- cache invariant ---

    kLast |-> KLast => #if FeeOn #then Balance0 * Balance1 #else 0 #fi

    // --- mint tokens ---

    balanceOf[0]  |-> Burned      => Burned + #sqrt(Amount0 * Amount1)
    totalSupply   |-> TotalSupply => TotalSupply + #sqrt(Amount0 * Amount1)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Amount0 * Amount1
    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

    Burned + MINIMUM_LIQUIDITY

    Burned + MINIMUM_LIQUIDITY + #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

iff

    // --- conditional artihmetic safety checks (_mintFee) ---

    (FeeOn) impliesBool #rangeUInt(256, Balance0 * Balance1)

    (FeeOn and KLast > 0) impliesBool #rangeUInt(256, Reserve0 * Reserve1)

    (FeeOn and KLast > 0 and RootK > RootKLast) impliesBool ( \
          #rangeUInt(256, RootK * 5)                          \
      and #rangeUInt(256, RootK * 5 + RootKLast)              \
      and #rangeUInt(256, RootK - RootKLast)                  \
      and #rangeUInt(256, TotalSupply * (RootK - RootKLast))  \
    )

    // --- LP shares must be minted ---

    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY > 0

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- no fee minting ---

    FeeLiquidity == 0

    // --- burn all liquidity ---

    to == 0

    // --- first call ---

    TotalSupply == 0

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY
```

```act
behaviour mint-noFee-subsequent-lt of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    DstBal      : uint256
    Burned      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share burning ---

    SharesBurned := #if TotalSupply == 0 #then MINIMUM_LIQUIDITY #else 0 #fi

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // --- reentrancy guard ---

    lockState |-> LockState => LockState

    // --- cache invariant ---

    kLast |-> KLast => #if FeeOn #then Balance0 * Balance1 #else 0 #fi

    // --- mint tokens ---

    balanceOf[to] |-> DstBal      => DstBal + (Amount0 * TotalSupply / Reserve0)
    totalSupply   |-> TotalSupply => TotalSupply + (Amount0 * TotalSupply / Reserve0)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Amount0 * TotalSupply
    Amount1 * TotalSupply

    DstBal + (Amount0 * TotalSupply / Reserve0)
    TotalSupply + (Amount0 * TotalSupply / Reserve0)

iff

    // --- no divide by zeros ---

    Reserve0 > 0
    Reserve1 > 0

    // --- conditional artihmetic safety checks ---

    (FeeOn) impliesBool #rangeUInt(256, Balance0 * Balance1)

    (FeeOn and KLast > 0) impliesBool #rangeUInt(256, Reserve0 * Reserve1)

    (FeeOn and KLast > 0 and RootK > RootKLast) impliesBool ( \
          #rangeUInt(256, RootK * 5)                          \
      and #rangeUInt(256, RootK * 5 + RootKLast)              \
      and #rangeUInt(256, RootK - RootKLast)                  \
      and #rangeUInt(256, TotalSupply * (RootK - RootKLast))  \
    )

    // --- LP shares must be minted ---

    (Amount0 * TotalSupply) / Reserve0 > 0

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- no fee minting ---

    FeeLiquidity == 0

    // --- subsequent lt ---

    TotalSupply > 0
    (Amount0 * TotalSupply) / Reserve0 < (Amount1 * TotalSupply) / Reserve1

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns (Amount0 * TotalSupply) / Reserve0
```

```act
behaviour mint-noFee-subsequent-gte of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    DstBal      : uint256
    Burned      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share burning ---

    SharesBurned := #if TotalSupply == 0 #then MINIMUM_LIQUIDITY #else 0 #fi

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // -- reentrancy guard ---

    lockState |-> LockState => LockState

    // -- cache invariant ---

    kLast |-> KLast => #if FeeOn #then Balance0 * Balance1 #else 0 #fi

    // -- mint tokens ---

    balanceOf[to] |-> DstBal      => DstBal + (Amount1 * TotalSupply / Reserve1)
    totalSupply   |-> TotalSupply => TotalSupply + (Amount1 * TotalSupply / Reserve1)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Amount0 * TotalSupply
    Amount1 * TotalSupply

    DstBal + (Amount1 * TotalSupply / Reserve1)
    TotalSupply + (Amount1 * TotalSupply / Reserve1)

iff

    // --- no divide by zeros ---

    Reserve0 > 0
    Reserve1 > 0

    // --- conditional artihmetic safety checks ---

    (FeeOn) impliesBool #rangeUInt(256, Balance0 * Balance1)

    (FeeOn and KLast > 0) impliesBool #rangeUInt(256, Reserve0 * Reserve1)

    (FeeOn and KLast > 0 and RootK > RootKLast) impliesBool ( \
          #rangeUInt(256, RootK * 5)                          \
      and #rangeUInt(256, RootK * 5 + RootKLast)              \
      and #rangeUInt(256, RootK - RootKLast)                  \
      and #rangeUInt(256, TotalSupply * (RootK - RootKLast))  \
    )

    // --- LP shares must be minted ---

    (Amount1 * TotalSupply) / Reserve1 > 0

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- no fee minting ---

    FeeLiquidity == 0

    // --- subsequent gte ---

    TotalSupply > 0
    (Amount0 * TotalSupply) / Reserve0 >= (Amount1 * TotalSupply) / Reserve1

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns (Amount1 * TotalSupply) / Reserve1
```

#### `mint`: fee minted

```act
behaviour mint-feeMinted-diff of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    DstBal      : uint256
    FeeBal      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share minting ---

    Reserve0Liquidity := (Amount0 * (TotalSupply + FeeLiquidity)) / Reserve0
    Reserve1Liquidity := (Amount1 * (TotalSupply + FeeLiquidity)) / Reserve1

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // -- reentrancy guard ---

    lockState |-> LockState => LockState

    // -- cache invariant ---

    kLast |-> KLast => Balance0 * Balance1

    // -- mint tokens ---

    balanceOf[to]    |-> DstBal      => DstBal + #min(Reserve0Liquidity, Reserve1Liquidity)
    balanceOf[FeeTo] |-> FeeBal      => FeeBal + FeeLiquidity
    totalSupply      |-> TotalSupply => TotalSupply + FeeLiquidity + #min(Reserve0Liquidity, Reserve1Liquidity)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Balance0 * Balance1

    Reserve0 * Reserve1

    Amount0 * (TotalSupply + FeeLiquidity)
    Amount1 * (TotalSupply + FeeLiquidity)

    RootK * 5
    RootK * 5 + RootKLast
    RootK - RootKLast
    TotalSupply * (RootK - RootKLast)

    FeeBal + FeeLiquidity
    TotalSupply + FeeLiquidity

iff

    Reserve0 > 0
    Reserve1 > 0

    Reserve0Liquidity < Reserve1Liquidity impliesBool (                   \
          #rangeUInt(256, DstBal + Reserve0Liquidity)                     \
      and #rangeUInt(256, TotalSupply + FeeLiquidity + Reserve0Liquidity) \
      and Reserve0Liquidity > 0                                           \
    )

    Reserve0Liquidity >= Reserve1Liquidity impliesBool (                  \
          #rangeUInt(256, DstBal + Reserve1Liquidity)                     \
      and #rangeUInt(256, TotalSupply + FeeLiquidity + Reserve1Liquidity) \
      and Reserve1Liquidity > 0                                           \
    )

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- fee minted ---

    FeeOn
    KLast > 0
    RootK > RootKLast
    FeeLiquidity > 0

    // implied by FeeLiquidity > 0, but added here to make life easier for the prover
    TotalSupply > 0

    // --- no storage collisions ---

    to =/= FeeTo

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns #min(Reserve0Liquidity, Reserve1Liquidity)
```

```act
behaviour mint-feeMinted-same of UniswapV2Pair
interface mint(address to)

for all

    Token0 : address UniswapV2Pair
    Token1 : address UniswapV2Pair

    Balance0 : uint256
    Balance1 : uint256
    Reserve0 : uint112
    Reserve1 : uint112

    PriceLast0 : uint256
    PriceLast1 : uint256
    BlockTimestampLast : uint32

    Factory : address UniswapV2Factory
    FeeTo   : address
    KLast   : uint256

    FeeBal      : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- input token amounts ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- fee liquidity Calculations ---

    FeeOn := FeeTo =/= 0

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- LP share minting ---

    Reserve0Liquidity := (Amount0 * (TotalSupply + FeeLiquidity)) / Reserve0
    Reserve1Liquidity := (Amount1 * (TotalSupply + FeeLiquidity)) / Reserve1

    // --- time elapsed since last block in which _update was called ---

    TimeElapsed := ((TIME mod pow32) -Word BlockTimestampLast) mod pow32

storage Token0

    balanceOf[ACCT_ID] |-> Balance0

storage Token1

    balanceOf[ACCT_ID] |-> Balance1

storage Factory

    feeTo |-> FeeTo

storage

    token0  |-> Token0
    token1  |-> Token1
    factory |-> Factory

    // -- reentrancy guard ---

    lockState |-> LockState => LockState

    // -- cache invariant ---

    kLast |-> KLast => Balance0 * Balance1

    // -- mint tokens ---

    balanceOf[FeeTo] |-> FeeBal => FeeBal + FeeLiquidity + #min(Reserve0Liquidity, Reserve1Liquidity)
    totalSupply |-> TotalSupply => TotalSupply + FeeLiquidity + #min(Reserve0Liquidity, Reserve1Liquidity)

    // --- sync reserves to balances, update cached timestamp ---

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) \
      => #WordPackUInt112UInt112UInt32(Balance0, Balance1, (TIME mod pow32))

    // --- price accumulator updates ---

    price0CumulativeLast |-> PriceLast0 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve1) / Reserve0) * TimeElapsed) + PriceLast0)) \
        #else PriceLast0                                                            \
      #fi

    price1CumulativeLast |-> PriceLast1 =>                                          \
      #if Reserve0 =/= 0 and Reserve1 =/= 0 and TimeElapsed > 0                     \
        #then chop(((((pow112 * Reserve0) / Reserve1) * TimeElapsed) + PriceLast1)) \
        #else PriceLast1                                                            \
      #fi

iff in range uint112

    Balance0
    Balance1

iff in range uint256

    Amount0
    Amount1

    Balance0 * Balance1

    Reserve0 * Reserve1

    Amount0 * (TotalSupply + FeeLiquidity)
    Amount1 * (TotalSupply + FeeLiquidity)

    RootK * 5
    RootK * 5 + RootKLast
    RootK - RootKLast
    TotalSupply * (RootK - RootKLast)

    FeeBal + FeeLiquidity
    TotalSupply + FeeLiquidity

iff

    Reserve0 > 0
    Reserve1 > 0

    Reserve0Liquidity < Reserve1Liquidity impliesBool (                   \
          #rangeUInt(256, FeeBal + FeeLiquidity + Reserve0Liquidity)      \
      and #rangeUInt(256, TotalSupply + FeeLiquidity + Reserve0Liquidity) \
      and Reserve0Liquidity > 0                                           \
    )

    Reserve0Liquidity >= Reserve1Liquidity impliesBool (                  \
          #rangeUInt(256, FeeBal + FeeLiquidity + Reserve1Liquidity)      \
      and #rangeUInt(256, TotalSupply + FeeLiquidity + Reserve1Liquidity) \
      and Reserve1Liquidity > 0                                           \
    )

    // --- no reentrancy ---

    LockState == 1

    // --- mint is not payable ---

    VCallValue == 0

    // --- call stack does not overflow ---

    VCallDepth < 1024

if
    // --- fee minted ---

    FeeOn
    KLast > 0
    RootK > RootKLast
    FeeLiquidity > 0

    // implied by FeeLiquidity > 0, but added here to make life easier for the prover
    TotalSupply > 0

    // --- fee recipient mints ---

    to == FeeTo

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns #min(Reserve0Liquidity, Reserve1Liquidity)
```

# ERC20

UniswapV2 liquidity token behaviours.

## Accessors

```act
behaviour name of UniswapV2Pair
interface name()

iff

    VCallValue == 0

returnsRaw #asByteStackInWidthaux(32, 31, 32, #enc(#string("Uniswap V2")))
```

```act
behaviour symbol of UniswapV2Pair
interface symbol()

iff

    VCallValue == 0

returnsRaw #asByteStackInWidthaux(32, 31, 32, #enc(#string("UNI-V2")))
```

```act
behaviour decimals of UniswapV2Pair
interface decimals()

iff

    VCallValue == 0

returns 18
```

```act
behaviour totalSupply of UniswapV2Pair
interface totalSupply()

for all

    Supply : uint256

storage

    totalSupply |-> Supply

iff

    VCallValue == 0

returns Supply
```

```act
behaviour balanceOf of UniswapV2Pair
interface balanceOf(address who)

for all

    BalanceOf : uint256

storage

    balanceOf[who] |-> BalanceOf

iff

    VCallValue == 0

returns BalanceOf
```

```act
behaviour allowance of UniswapV2Pair
interface allowance(address holder, address spender)

for all

    Allowed : uint256

storage

    allowance[holder][spender] |-> Allowed

iff

    VCallValue == 0

returns Allowed
```

```act
behaviour DOMAIN_SEPARATOR of UniswapV2Pair
interface DOMAIN_SEPARATOR()

for all

    Dom : uint256

storage

    DOMAIN_SEPARATOR |-> Dom

iff

    VCallValue == 0

returns Dom
```

```act
behaviour PERMIT_TYPEHASH of UniswapV2Pair
interface PERMIT_TYPEHASH()

iff

    VCallValue == 0

returns Constants.PermitTypehash
```

```act
behaviour nonces of UniswapV2Pair
interface nonces(address who)

for all

    Nonce : uint256

storage

    nonces[who] |-> Nonce

iff

    VCallValue == 0

returns Nonce
```

## Mutators

### Transfer

```act
behaviour transfer-diff of UniswapV2Pair
interface transfer(address to, uint value)

for all

    SrcBal : uint256
    DstBal : uint256

storage

    balanceOf[CALLER_ID] |-> SrcBal => SrcBal - value
    balanceOf[to]        |-> DstBal => DstBal + value

iff

    VCallValue == 0

iff in range uint256

    SrcBal - value
    DstBal + value

if
    to =/= CALLER_ID

returns 1
```

```act
behaviour transfer-same of UniswapV2Pair
interface transfer(address to, uint value)

for all

    SrcBal : uint256

storage

    balanceOf[CALLER_ID] |-> SrcBal => SrcBal

iff

    VCallValue == 0

iff in range uint256

    SrcBal - value

if
    to == CALLER_ID

returns 1
```

### Approve

```act
behaviour approve of UniswapV2Pair
interface approve(address spender, uint value)

for all

    Allowance : uint256

storage

    allowance[CALLER_ID][spender] |-> Allowance => Value

iff

    VCallValue == 0

returns 1
```

### TransferFrom

```act
behaviour transferFrom-diff of UniswapV2Pair
interface transferFrom(address from, address to, uint value)

for all

    SrcBal  : uint256
    DstBal  : uint256
    Allowed : uint256

storage

    allowance[from][CALLER_ID] |-> Allowed => #if (Allowed == maxUInt256) #then Allowed #else Allowed - value #fi
    balanceOf[from]            |-> SrcBal  => SrcBal - value
    balanceOf[to]              |-> DstBal  => DstBal + value

iff in range uint256

    SrcBal - value
    DstBal + value

iff
    value <= Allowed
    VCallValue == 0

if
    from =/= to

returns 1
```

```act
behaviour transferFrom-same of UniswapV2Pair
interface transferFrom(address from, address to, uint value)

for all

    FromBal : uint256
    Allowed : uint256

storage

    allowance[from][CALLER_ID] |-> Allowed => #if (Allowed == maxUInt256) #then Allowed #else Allowed - value #fi
    balanceOf[from]            |-> FromBal => FromBal

iff in range uint256

    FromBal - value

iff
    value <= Allowed
    VCallValue == 0

if
    from == to

returns 1
```

### Permit

Authority over the transfer of Uniswap V2 liquidity tokens can be delegated in a zero-gas manner:
anyone who holds a message signed by `owner` can use `permit` to set the vaule in the `approvals`
mapping for `owner` -> `spender` to `value`. Each message has a `deadline`, after which it is no
longer valid.

The `v`, `r` and `s` parameters are the individual components of the signature, split as required by
`ecrecover`.

The message is constructed and verified according to
[`EIP-712`](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md), where the typehash is
given by `keccak("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256
deadline)")` and the domain seperator is set in the constructor with:

```solidity
DOMAIN_SEPARATOR = keccak256(
    abi.encode(
        keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
        keccak256(bytes(name)),
        keccak256(bytes('1')),
        chainId,
        address(this)
    )
);
```

Checks against [ECDSA
Malleability](https://github.com/bitcoin-core/secp256k1/blob/1b4d256e2ea09895de331e4969430551ef0e54ac/include/secp256k1.h#L483)
are omitted as the existence of multiple valid signatures for the same message does not cause an
issue: the user's wishes are being carried out, and the nonce protects against replay.

Nonces can overflow, allowing for replay attacks against `owner` once `uint256(-1)` `permit`
operations have been processed on their behalf. This should not be a concern in practice, especially
if messages have deadlines. The behaviour of the contract in the call where overflow occurs is not
covered by this spec.

Note that the `nonce` is omitted from the signature of the solidity function, but is still included
and checked as part of the signed message.

```act
behaviour permit of UniswapV2Pair
interface permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s)

for all

    Nonce            : uint256
    Allowed          : uint256
    Domain_separator : bytes32

storage

    nonces[owner]             |-> Nonce => Nonce + 1
    DOMAIN_SEPARATOR          |-> Domain_separator
    allowance[owner][spender] |-> Allowed => value

iff

    0 =/= maxUInt160 & #symEcrec(                                                  \
      keccakIntList(                                                               \
        #asWord(#parseHexWord("0x19") : #parseHexWord("0x1") : .WordStack)         \
        Domain_separator                                                           \
        keccakIntList(Constants.PermitTypehash owner spender value Nonce deadline) \
      ), v, r, s)

    owner == maxUInt160 & #symEcrec(                                               \
      keccakIntList(                                                               \
        #asWord(#parseHexWord("0x19") : #parseHexWord("0x1") : .WordStack)         \
        Domain_separator                                                           \
        keccakIntList(Constants.PermitTypehash owner spender value Nonce deadline) \
      ), v, r, s)

    TIME <= deadline

    VCallValue == 0
    VCallDepth < 1024

if

    // ignore overflow case
    #rangeUInt(256, Nonce + 1)
```
