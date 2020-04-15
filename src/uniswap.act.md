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

### Burn

The `burn` function burns all the liquidity tokens owned by the pair
contract and sends a proportionate amount of each token in the pair to the
address specified by `to`.
Sending liquidity tokens to the contract and calling `burn` should happen
atomically, otherwise the tokens can be withdrawn by a third-party with a call
to `skim`.

`burn` also optionally generates protocol fees, if the value of `feeTo` is not `0`.

This function requires that the `UniswapV2Pair` contract's balance of the
two pair tokens does not exceed `MAX_UINT_112 - 1`.

```act
behaviour burn of UniswapV2Pair
interface burn(address to)

for all

    Reserve0           : uint112
    Reserve1           : uint112
    BlockTimestampLast : uint32
    Token0             : address UniswapV2Pair
    Token1             : address UniswapV2Pair
    Balance            : uint256
    BalanceFeeTo       : uint256
    BalanceToken0      : uint112
    BalanceToken1      : uint112
    BalanceToToken0    : uint256
    BalanceToToken1    : uint256
    FeeTo              : address
    Factory            : address UniswapV2Factory
    KLast              : uint256
    Supply             : uint256
    Price0             : uint256
    Price1             : uint256
    LockState          : uint256

storage

    reserve0_reserve1_blockTimestampLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockTimestampLast) => #WordPackUInt112UInt112UInt32(BalanceToken0, BalanceToken1, BlockTimestamp)
    token0 |-> Token0
    token1 |-> Token1
    factory |-> Factory
    kLast |-> KLast => #if FeeOn #then Reserve0 * Reserve1 #else KLast #fi
    totalSupply |-> Supply => #if Minting #then (Supply - Balance) + Fee #else Supply - Balance #fi
    balanceOf[FeeTo] |-> BalanceFeeTo => #if Minting #then BalanceFeeTo + Fee #else BalanceFeeTo #fi
    balanceOf[ACCT_ID] |-> Balance => 0
    price0CumulativeLast |-> Price0 => #if TimeElapsed > 0 and Reserve0 =/= 0 and Reserve1 =/= 0 #then chop(Price0 + PriceIncrease0) #else Price0 #fi
    price1CumulativeLast |-> Price1 => #if TimeElapsed > 0 and Reserve0 =/= 0 and Reserve1 =/= 0 #then chop(Price1 + PriceIncrease1) #else Price1 #fi
    lockState |-> LockState => LockState

storage Token0

    balanceOf[ACCT_ID] |-> BalanceToken0 => BalanceToken0 - Amount0
    balanceOf[to] |-> BalanceToToken0 => BalanceToToken0 + Amount0


storage Token1

    balanceOf[ACCT_ID] |-> BalanceToken1 => BalanceToken1 - Amount1
    balanceOf[to] |-> BalanceToToken1 => BalanceToToken1 + Amount1

storage Factory

    feeTo |-> FeeTo

returns Amount0 : Amount1

where

    FeeOn := FeeTo =/= 0
    RootK := #sqrt(Reserve0 * Reserve1)
    RootKLast := #sqrt(KLast)
    Fee := Supply * (RootK - RootKLast) / ((RootK * 5) + RootKLast)
    Minting := (KLast =/= 0) and FeeOn and (RootK > RootKLast) and (Fee > 0)
    Amount0 := (Balance * BalanceToken0) / Supply
    Amount1 := (Balance * BalanceToken1) / Supply
    Amount0WithFee := (Balance * BalanceToken0) / (Supply + Fee)
    Amount1WithFee := (Balance * BalanceToken1) / (Supply + Fee)
    BlockTimestamp := TIME mod pow32
    TimeElapsed := #if BlockTimestamp < BlockTimestampLast #then (pow32 + BlockTimestamp) - BlockTimestampLast #else BlockTimestamp - BlockTimestampLast #fi
    PriceIncrease0 := ((Reserve1 * pow112) / Reserve0) * TimeElapsed
    PriceIncrease1 := ((Reserve0 * pow112) / Reserve1) * TimeElapsed

iff in range uint256

    // _mintFee
    Reserve0 * Reserve1
    RootK
    RootKLast
    RootK - RootKLast
    Supply * (RootK - RootKLast)
    RootK * 5
    (RootK * 5) + RootKLast
    Fee
    Supply + Fee
    BalanceFeeTo + Fee

    // burn
    Balance * BalanceToken0
    Balance * BalanceToken1
    Amount0
    Amount1
    Amount0WithFee
    Amount1WithFee
    Supply - Balance
    // TODO move to fee-on spec
    Reserve0 * Reserve1

    // _safeTransfer
    BalanceToken0 - Amount0
    BalanceToken1 - Amount1
    BalanceToken0 - Amount0WithFee
    BalanceToken1 - Amount1WithFee
    BalanceToToken0 + Amount0
    BalanceToToken1 + Amount1
    BalanceToToken0 + Amount0WithFee
    BalanceToToken1 + Amount1WithFee

iff

    Amount0 > 0
    Amount1 > 0
    Amount0WithFee > 0
    Amount1WithFee > 0
    LockState == 1
    VCallValue == 0
    VCallDepth < 1024

if

    to =/= ACCT_ID
    FeeTo =/= ACCT_ID
    FeeTo == 0
    Supply =/= 0
    TimeElapsed == 0
    Reserve0 =/= 0
    Reserve1 =/= 0
    BlockTimestamp > BlockTimestampLast
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
