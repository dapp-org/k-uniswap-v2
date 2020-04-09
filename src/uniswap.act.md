UniswapV2Factory
================

## Accessors

### feeTo

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

### allPairs

`allPairs` is an array holding the address of every pair created using the `Factory`.

`pair0` is the index in storage of the first array element. Subsequent array elements are read
from `pair0 + index`. The maximum number of addresses that can be stored by the `allPairs`
array before overflow is therefore `maxUInt256 - pair0 + 1 ==
27889059366240281169193357100633332908378892778709981755071813198463099602853`.

We do not currently specify the behaviour of the array after overflow has occured.

TODO: ensure that `createPair` checks for overflow on the `allPairs` array.

```act
behaviour allPairs of UniswapV2Factory
interface allPairs(uint256 index)

for all

    Pair : address
    Length   : uint256

storage

    allPairs.length |-> Length
    allPairs[index] |-> Pair

iff

    Length > index
    VCallValue == 0

if

    // ignore array overflow
    Length <= maxUInt256 - pair0 + 1

returns Pair
```

### feeToSetter

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

### allPairsLength

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

The current fee setter can appoint a new fee setter

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

The current fee setter can appoint a new fee recipient

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

UniswapV2Pair
=================

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

#### Inputs and Front Running

The input amounts are calculated by subtracting the cached reserves from the actual token balances.
This means that liquidity providers need to transfer any tokens they want to add to the pool before
calling `mint`. This should always be done as part of a single atomic transaction, or there is a
risk that someone will frontrun the call to `mint` with their own call to `mint` and thus steal the
tokens.

#### Proportional Minting

The amount of liquidity tokens created (`Liquidity`) is proportional to the amount of pool tokens provided:

- If the pool is empty, `Liquidity` will be `sqrt(Amount0 * Amount1)`.
- Otherwise, `Liquidity` will be `min((Amount0 * TotalSupply) / Reserve0, (Amount1 * TotalSupply) / Reserve1)`.

---

TODO: why are these numbers good?

Assumption:

- empty condition preserves `x*y=k`.
- non empty preserves LP Token <-> Pool Token price and ensures that calls to mint with unbalanced
  token amounts are not profitable.

---

#### Divide by Zero Guard

`mint` will always revert if `Liquidity` is `0`, ensuring that `Reserve0` and `Reserve1` are always
non-zero in non-empty case (`Liquidity > 0` in the empty case ensures that both `Amount0` and
`Amount1` are greater than `0`, meaning that both reserves will always be non-zero after `_update`
is invoked at the end of `mint`).

---

TODO: is there some `sync` / `skim` trickery between the initial and subsequent calls that can break this?

yes --> mint() -> erc20.burn() -> sync() -> mint()

---

#### Restrictions on Underlying Token Balances

Calls to `mint` will fail if the balance of the exchange in either `Token0` or `Token1` exceeds `uint112(-1)`.

`uint112(-1)` is `5192296858534827628530496329220095`. Assuming an 18 decimal token, this would be a
problem once the exchange has token balances greater than `5,192,296,858,534,827` (~ 5 quadrillion).
This should not be an issue for non pathological tokens, but does pose a risk for tokens with
extremely large supplies or very high decimals.

#### `sqrt`

This spec assumes a good implementation of `sqrt` by leaving the result of the call to `sqrt`
symbolic and making claims only in terms of that symbolic result. Bugs in the implementation of
`sqrt` could result in invalid behaviour for `mint` and are not covered here.

#### Reentrancy

`mint` is guarded by a mutex (`LockState`) and so is safe against reentrant calls.

TODO: fee minting
TODO: invariant checks (`kLast`)

#### `mint` fee on

```act
behaviour mint-feeOn of UniswapV2Pair
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

    DstBal : uint256
    Burned : uint256
    FeeBal : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- amounts paid into pool ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- LP share minting ---

    MINIMUM_LIQUIDITY := 1000

    EmptyLiquidity := #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

    FundedLiquidityNoFee := #min(         \
      (Amount0 * TotalSupply) / Reserve0, \
      (Amount1 * TotalSupply) / Reserve1  \
    )

    FundedLiquidityFee := #min(                            \
      (Amount0 * (TotalSupply + FeeLiquidity)) / Reserve0, \
      (Amount1 * (TotalSupply + FeeLiquidity)) / Reserve1  \
    )

    SharesMinted := #if TotalSupply == 0                                              \
      #then EmptyLiquidity                                                            \
      #else (#if WillMintFee #then FundedLiquidityFee #else FundedLiquidityNoFee #fi) \
    #fi

    // --- LP share burning ---

    SharesBurned := #if TotalSupply == 0 #then MINIMUM_LIQUIDITY #else 0 #fi

    // --- fee minting ---

    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    FeeLiquidity := (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    WillMintFee := KLast > 0 and RootK > RootKLast

    FeeMinted := #if WillMintFee #then FeeLiquidity #else 0 #fi

    // --- time since last call ---

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

    // --- cached invariant update ---

    kLast |-> KLast => Balance0 * Balance1

    // --- mint liquidity tokens ---

    balanceOf[FeeTo] |-> FeeBal => FeeBal + FeeMinted
    balanceOf[to]    |-> DstBal => DstBal + SharesMinted
    balanceOf[0]     |-> Burned => Burned + SharesBurned
    totalSupply      |-> TotalSupply => TotalSupply + SharesMinted + SharesBurned + FeeMinted

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

    // --- invariant calculation ---

    Reserve0 * Reserve1

    // --- LP share calculations ---

    Amount0
    Amount1

    Amount0 * Amount1
    EmptyLiquidity

    Amount0 * TotalSupply
    Amount0 * (TotalSupply + FeeLiquidity)

    Amount1 * TotalSupply
    Amount1 * (TotalSupply + FeeLiquidity)

    // --- fee liquidity calculation ---

    RootK - RootKLast
    TotalSupply * (RootK - RootKLast)
    RootK * 5
    (RootK * 5) + RootKLast
    (TotalSupply * (RootK - RootKLast)) / ((RootK * 5) + RootKLast)

    // --- token burning ---

    Burned + MINIMUM_LIQUIDITY

    // --- fee minting ---

    FeeBal + FeeLiquidity

    // --- token minting ---

    DstBal + EmptyLiquidity

    DstBal + (Amount0 * TotalSupply) / Reserve0
    DstBal + (Amount1 * TotalSupply) / Reserve1

    DstBal + (Amount0 * (TotalSupply + FeeLiquidity)) / Reserve0
    DstBal + (Amount1 * (TotalSupply + FeeLiquidity)) / Reserve1

    // --- total supply updates ---

    TotalSupply + FeeLiquidity

    TotalSupply + EmptyLiquidity
    TotalSupply + EmptyLiquidity + FeeLiquidity

    TotalSupply + (Amount0 * TotalSupply) / Reserve0
    TotalSupply + (Amount1 * TotalSupply) / Reserve1

    TotalSupply + (Amount0 * TotalSupply) / Reserve0 + FeeLiquidity
    TotalSupply + (Amount1 * TotalSupply) / Reserve1 + FeeLiquidity

    TotalSupply + FeeLiquidity + (Amount0 * (TotalSupply + FeeLiquidity)) / Reserve0
    TotalSupply + FeeLiquidity + (Amount1 * (TotalSupply + FeeLiquidity)) / Reserve1

iff

    // --- LP shares must be created ---

    ((TotalSupply == 0)                                      \
      and (Amount0 > 0)                                      \
      and (Amount1 > 0)                                      \
      and (EmptyLiquidity > 0)                               \
    )                                                        \
    or (((TotalSupply > 0) and not (WillMintFee))            \
      and (Reserve0 > 0)                                     \
      and (Reserve1 > 0)                                     \
      and (FundedLiquidityNoFee > 0)                         \
    )                                                        \
    or (((TotalSupply > 0) and (WillMintFee))                \
      and (Reserve0 > 0)                                     \
      and (Reserve1 > 0)                                     \
      and (FundedLiquidityFee > 0)                           \
    )

    // --- not payable ---

    VCallValue == 0

    // --- max call stack depth ---

    VCallDepth < 1024

    // --- reentrancy guard ---

    LockState == 1

if
    // --- fee on ---

    0 =/= FeeTo

    // --- no storage collisions ---

    0 =/= to
    to =/= FeeTo

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns SharesMinted
```

#### `mint` fee off

```act
behaviour mint-feeOff of UniswapV2Pair
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

    DstBal : uint256
    Burned : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- amounts paid into pool ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- LP share minting ---

    MINIMUM_LIQUIDITY := 1000

    EmptyLiquidity := #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

    FundedLiquidity := #min(              \
      (Amount0 * TotalSupply) / Reserve0, \
      (Amount1 * TotalSupply) / Reserve1  \
    )

    SharesMinted := #if TotalSupply == 0 \
      #then EmptyLiquidity               \
      #else FundedLiquidity              \
    #fi

    // --- LP share burning ---

    SharesBurned := #if TotalSupply == 0 #then MINIMUM_LIQUIDITY #else 0 #fi

    // --- time since last call ---

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

    // --- cached invariant update ---

    kLast |-> KLast => 0

    // --- mint liquidity tokens ---

    balanceOf[to]    |-> DstBal => DstBal + SharesMinted
    balanceOf[0]     |-> Burned => Burned + SharesBurned
    totalSupply      |-> TotalSupply => TotalSupply + SharesMinted + SharesBurned

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

    // --- LP share calculations ---

    Amount0
    Amount1

    Amount0 * Amount1
    EmptyLiquidity

    Amount0 * TotalSupply
    Amount1 * TotalSupply

    // --- token burning ---

    Burned + MINIMUM_LIQUIDITY

    // --- token minting ---

    DstBal + EmptyLiquidity

    DstBal + (Amount0 * TotalSupply) / Reserve0
    DstBal + (Amount1 * TotalSupply) / Reserve1

    // --- total supply updates ---

    TotalSupply + (Amount0 * TotalSupply) / Reserve0
    TotalSupply + (Amount1 * TotalSupply) / Reserve1

iff

    // --- LP shares must be created ---

    ((TotalSupply == 0)         \
      and (EmptyLiquidity > 0)  \
    )                           \
    or ((TotalSupply > 0)       \
      and (Reserve0 > 0)        \
      and (Reserve1 > 0)        \
      and (FundedLiquidity > 0) \
    )

    // --- not payable ---

    VCallValue == 0

    // --- max call stack depth ---

    VCallDepth < 1024

    // --- reentrancy guard ---

    LockState == 1

if
    // --- fee off ---

    0 == FeeTo

    // --- no storage collisions ---

    0 =/= to

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns SharesMinted
```

#### `mint` fee off first call

```act
behaviour mint-feeOff-first of UniswapV2Pair
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

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    MINIMUM_LIQUIDITY := 1000

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

    lockState |-> LockState => LockState

    kLast |-> KLast => 0

    // -- mint tokens

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

    Burned + 1000

    Amount0 * Amount1
    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY

iff

    // --- LP shares must be created ---

    #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY > 0

    VCallValue == 0
    VCallDepth < 1024

    LockState == 1

if
    // --- fee off ---

    0 == FeeTo

    // --- first call

    TotalSupply == 0

    // --- no storage collisions ---

    0 =/= to

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns #sqrt(Amount0 * Amount1) - MINIMUM_LIQUIDITY
```

#### `mint` fee off subsequent calls


```act
behaviour mint-feeOff-subsequent-lt of UniswapV2Pair
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

    DstBal : uint256
    Burned : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- amounts paid into pool ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1


    // --- time since last call ---

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

    // --- cached invariant update ---

    kLast |-> KLast => 0

    // --- mint liquidity tokens ---

    balanceOf[to] |-> DstBal => DstBal + (Amount0 * TotalSupply) / Reserve0
    totalSupply   |-> TotalSupply => TotalSupply + (Amount0 * TotalSupply) / Reserve0

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

    DstBal + (Amount0 * TotalSupply) / Reserve0
    TotalSupply + (Amount0 * TotalSupply) / Reserve0

iff

    Reserve0 > 0
    Reserve1 > 0

    (Amount0 * TotalSupply) / Reserve0 > 0

    // --- not payable ---

    VCallValue == 0

    // --- max call stack depth ---

    VCallDepth < 1024

    // --- reentrancy guard ---

    LockState == 1

if
    // --- fee off ---

    0 == FeeTo

    // --- no storage collisions ---

    0 =/= to

    TotalSupply > 0
    (Amount0 * TotalSupply) / Reserve0 < (Amount1 * TotalSupply) / Reserve1

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns (Amount0 * TotalSupply) / Reserve0
```

```act
behaviour mint-feeOff-subsequent-gt of UniswapV2Pair
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

    DstBal : uint256
    Burned : uint256
    TotalSupply : uint256

    LockState : uint256

where

    // --- amounts paid into pool ---

    Amount0 := Balance0 - Reserve0
    Amount1 := Balance1 - Reserve1

    // --- time since last call ---

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

    // --- cached invariant update ---

    kLast |-> KLast => 0

    // --- mint liquidity tokens ---

    balanceOf[to] |-> DstBal => DstBal + (Amount1 * TotalSupply) / Reserve1
    totalSupply   |-> TotalSupply => TotalSupply + (Amount1 * TotalSupply) / Reserve1

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

    DstBal + (Amount1 * TotalSupply) / Reserve1
    TotalSupply + (Amount1 * TotalSupply) / Reserve1

iff

    Reserve0 > 0
    Reserve1 > 0

    (Amount1 * TotalSupply) / Reserve1 > 0

    // --- not payable ---

    VCallValue == 0

    // --- max call stack depth ---

    VCallDepth < 1024

    // --- reentrancy guard ---

    LockState == 1

if
    // --- fee off ---

    0 == FeeTo

    // --- no storage collisions ---

    0 =/= to

    TotalSupply > 0
    (Amount0 * TotalSupply) / Reserve0 > (Amount1 * TotalSupply) / Reserve1

calls

    UniswapV2Pair.balanceOf
    UniswapV2Factory.feeTo

returns (Amount1 * TotalSupply) / Reserve1
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
