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
    UniswapV2Pair.add
    UniswapV2Pair.sub
    UniswapV2Pair.mul
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
    UniswapV2Pair.add
    UniswapV2Pair.sub
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
    UniswapV2Pair.add
    UniswapV2Pair.sub
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

calls

    UniswapV2Pair.add
    UniswapV2Pair.sub

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

calls

    UniswapV2Pair.add
    UniswapV2Pair.sub

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

calls

    UniswapV2Pair.add
    UniswapV2Pair.sub

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

calls

    UniswapV2Pair.add
    UniswapV2Pair.sub

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

## SafeMath

```act
behaviour add of UniswapV2Pair
interface add(uint256 x, uint256 y) internal

pc

    10940 => 3579

stack

    y : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256

    x + y

if

    // TODO: strengthen
    #sizeWordStack(WS) <= 100
```

```act
behaviour sub of UniswapV2Pair
interface sub(uint256 x, uint256 y) internal

pc

    8814 => 3579

stack

    y : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256

    x - y

if

    // TODO: strengthen
    #sizeWordStack(WS) <= 100
```

```act
behaviour mul of UniswapV2Pair
interface mul(uint256 x, uint256 y) internal

pc

    8680 => 3579

stack

    y : x : JMPTO : WS => JMPTO : x * y : WS

iff in range uint256

    x * y

if

    #sizeWordStack(WS) <= 1000
```
