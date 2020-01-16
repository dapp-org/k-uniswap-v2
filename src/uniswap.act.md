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

### getExchange

```act
behaviour getExchange of UniswapV2Factory
interface getExchange(address tokenA, address tokenB)

for all

    Exchange : address

storage

    getExchange[tokenA][tokenB] |-> Exchange

iff

    VCallValue == 0

returns Exchange
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

UniswapV2Exchange
=================

## Accessors

### factory

```act
behaviour factory of UniswapV2Exchange
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
behaviour token0 of UniswapV2Exchange
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
behaviour token1 of UniswapV2Exchange
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
behaviour price0CumulativeLast of UniswapV2Exchange
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
behaviour price1CumulativeLast of UniswapV2Exchange
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
behaviour invariantLast of UniswapV2Exchange
interface invariantLast()

for all

    InvariantLast : uint256

storage

    invariantLast |-> InvariantLast

iff

    VCallValue == 0

returns InvariantLast
```

### getReserves

```act
behaviour getReserves of UniswapV2Exchange
interface getReserves()

for all

    Reserve0        : uint112
    Reserve1        : uint112
    BlockNumberLast : uint32

storage

    reserve0_reserve1_blockNumberLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockNumberLast)

iff

    VCallValue == 0

returns Reserve0 : Reserve1 : BlockNumberLast
```

```act
behaviour skim of UniswapV2Exchange
interface skim(address to)

for all

    Unlocked        : bool
    Token0          : address UniswapV2Exchange
    Token1          : address UniswapV2Exchange
    SrcBal0         : uint256
    SrcBal1         : uint256
    DstBal0         : uint256
    DstBal1         : uint256
    Reserve0        : uint112
    Reserve1        : uint112
    Blocknumberlast : uint32

storage

    unlocked |-> Unlocked
    token0   |-> Token0
    token1   |-> Token1
    reserve0_reserve1_blockNumberLast |-> #WordPackUInt112UInt112UInt32(Reserve0, Reserve1, BlockNumberLast)

storage Token0

    balanceOf[ACCT_ID] |-> SrcBal0 => SrcBal0 - Reserve0
    balanceOf[to]      |-> DstBal0 => DstBal0 + (SrcBal0 - Reserve0)

storage Token1

    balanceOf[ACCT_ID] |-> SrcBal1 => SrcBal1 - Reserve1
    balanceOf[to]      |-> DstBal1 => DstBal1 + (SrcBal1 - Reserve1)

iff in range uint256

    SrcBal0 - Reserve0
    SrcBal1 - Reserve1
    DstBal0 + (SrcBal0 - Reserve0)
    DstBal1 + (SrcBal1 - Reserve1)

iff

    VCallValue == 0
    Unlocked   == 1

if

    to =/= ACCT_ID
```

```act
behaviour skim-back of UniswapV2Exchange
interface skim(address to)

for all

    Unlocked : bool
    Token0   : address UniswapV2Exchange
    Token1   : address UniswapV2Exchange
    SrcBal0  : uint256
    SrcBal1  : uint256

storage

    unlocked |-> Unlocked
    token0   |-> Token0
    token1   |-> Token1

storage Token0

    balanceOf[ACCT_ID] |-> SrcBal0

storage Token1

    balanceOf[ACCT_ID] |-> SrcBal1

iff

    VCallValue == 0
    Unlocked   == 1

if

    to == ACCT_ID
```

# ERC20

UniswapV2 liquidity token behaviours.

## Accessors

```act
behaviour totalSupply of UniswapV2Exchange
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
behaviour balanceOf of UniswapV2Exchange
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
behaviour allowance of UniswapV2Exchange
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
behaviour DOMAIN_SEPARATOR of UniswapV2Exchange
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
behaviour PERMIT_TYPEHASH of UniswapV2Exchange
interface PERMIT_TYPEHASH()

iff

    VCallValue == 0

returns keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"))

```

```act
behaviour nonces of UniswapV2Exchange
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
behaviour transfer-diff of UniswapV2Exchange
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
behaviour transfer-same of UniswapV2Exchange
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
behaviour approve of UniswapV2Exchange
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
behaviour transferFrom-diff of UniswapV2Exchange
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
behaviour transferFrom-same of UniswapV2Exchange
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
