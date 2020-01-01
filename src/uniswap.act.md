# ERC20

UniswapV2 liquidity token behaviour.

## Accessors

```act
behaviour totalSupply of ERC20
interface totalSupply()

types

    Supply : uint256

storage

    totalSupply |-> Supply

iff

    VCallValue == 0

returns Supply
```

```act
behaviour balanceOf of ERC20
interface balanceOf(address who)

types

    BalanceOf : uint256

storage

    balanceOf[who] |-> BalanceOf

iff

    VCallValue == 0

returns BalanceOf
```

```act
behaviour allowance of ERC20
interface allowance(address holder, address spender)

types

    Allowed : uint256

storage

    allowance[holder][spender] |-> Allowed

iff

    VCallValue == 0

returns Allowed
```

```act
behaviour DOMAIN_SEPARATOR of ERC20
interface DOMAIN_SEPARATOR()

types

    Dom : uint256

storage

    DOMAIN_SEPARATOR |-> Dom

iff

    VCallValue == 0

returns Dom
```

```act
behaviour PERMIT_TYPEHASH of ERC20
interface PERMIT_TYPEHASH()

iff

    VCallValue == 0

returns keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 expiration)"))
```

```act
behaviour nonces of ERC20
interface nonces(address who)

types

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
behaviour transfer-diff of ERC20
interface transfer(address to, uint value)

types

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
behaviour transfer-same of ERC20
interface transfer(address to, uint value)

types

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

### Burn

```act
behaviour burn of ERC20
interface burn(uint value)

types

    SrcBal : uint256
    Supply : uint256


storage

    balanceOf[CALLER_ID] |-> SrcBal => SrcBal - value
    totalSupply          |-> Supply => Supply - value

iff

    VCallValue == 0

iff in range uint256

    SrcBal - value
    Supply - value
```

### Approve

```act
behaviour approve-diff of ERC20
interface approve(address spender, uint value)

types

    Allowance : uint256

storage

    allowance[CALLER_ID][spender] |-> Allowance => Value

iff

    VCallValue == 0

if

    CALLER_ID =/= spender

returns 1
```

```act
behaviour approve-same of ERC20
interface approve(address spender, uint value)

types

    Allowance : uint256

storage

    allowance[CALLER_ID][CALLER_ID] |-> Allowance => Value

iff

    VCallValue == 0

if

    CALLER_ID == spender

returns 1
```

### TransferFrom

```act
behaviour transferFrom-diff of ERC20
interface transferFrom(address from, address to, uint value)

types

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
behaviour transferFrom-same of ERC20
interface transferFrom(address from, address to, uint value)

types

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
