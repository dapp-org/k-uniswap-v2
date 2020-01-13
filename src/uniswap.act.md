UniswapV2
=========

## Accessors

### factory

```act
behaviour factory of UniswapV2
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
behaviour token0 of UniswapV2
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
behaviour token1 of UniswapV2
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
behaviour price0CumulativeLast of UniswapV2
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
behaviour price1CumulativeLast of UniswapV2
interface price1CumulativeLast()

for all

    Price1 : uint256

storage

    price1CumulativeLast |-> Price1

iff

    VCallValue == 0

returns Price1
```

### getReserves

```act
behaviour getReserves of UniswapV2
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

## Mutators

### Sync

```solidity
// force reserves to match balances
function sync() external lock {
    _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
}
```

```act
```

# ERC20

UniswapV2 liquidity token behaviours.

## Accessors

```act
behaviour decimals of UniswapV2
interface decimals()

for all

    Decimals : uint8

storage

    decimals |-> Decimals

iff

    VCallValue == 0

returns Decimals
```

```act
behaviour totalSupply of UniswapV2
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
behaviour balanceOf of UniswapV2
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
behaviour allowance of UniswapV2
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
behaviour DOMAIN_SEPARATOR of UniswapV2
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
behaviour PERMIT_TYPEHASH of UniswapV2
interface PERMIT_TYPEHASH()

iff

    VCallValue == 0

returns keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"))

```

```act
behaviour nonces of UniswapV2
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
behaviour transfer-diff of UniswapV2
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
behaviour transfer-same of UniswapV2
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

### Burn

```act
behaviour forfeit of UniswapV2
interface forfeit(uint value)

for all

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
behaviour approve of UniswapV2
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
behaviour transferFrom-diff of UniswapV2
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
behaviour transferFrom-same of UniswapV2
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

### BurnFrom

```act
behaviour forfeitFrom of UniswapV2
interface forfeitFrom(address from, uint value)

for all

    FromBal : uint256
    Allowed : uint256
    Supply  : uint256

storage

    allowance[from][CALLER_ID] |-> Allowed => #if (Allowed == maxUInt256) #then Allowed #else Allowed - value #fi
    balanceOf[from]            |-> FromBal => FromBal - value
    totalSupply                |-> Supply  => Supply - value

iff in range uint256

    FromBal - value
    Supply - value

iff
    value <= Allowed
    VCallValue == 0
```

### Permit

```solidity
function permit(
    address owner, address spender, uint value, uint nonce, uint deadline, uint8 v, bytes32 r, bytes32 s
)
    external
{
    require(nonce == nonces[owner]++, "ERC20: INVALID_NONCE");
    require(deadline > block.timestamp, "ERC20: EXPIRED"); // solium-disable-line security/no-block-members
    require(v == 27 || v == 28, "ERC20: INVALID_V");
    require(s <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "ERC20: INVALID_S");
    bytes32 digest = keccak256(abi.encodePacked(
        "\x19\x01",
        DOMAIN_SEPARATOR,
        keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, deadline))
    ));
    address recoveredAddress = ecrecover(digest, v, r, s);
    require(recoveredAddress != address(0) && recoveredAddress == owner, "ERC20: INVALID_SIGNATURE");
    _approve(owner, spender, value);
}
```

```act
behaviour permit of UniswapV2
interface permit(address owner, address spender, uint value, uint nonce, uint deadline, uint8 v, bytes32 r, bytes32 s)

for all

    Nonce   : uint256
    Allowed : uint256
    Domain_separator : bytes32

storage

    nonces[owner]             |-> Nonce => 1 + Nonce
    DOMAIN_SEPARATOR          |-> Domain_separator
    allowance[owner][spender] |-> Allowed => value

iff
    (owner == #symEcrec(keccakIntList(#asWord(#parseHexWord("0x19") : #parseHexWord("0x1") : .WordStack) Domain_separator keccakIntList(keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")) owner spender value nonce deadline)), v, r, s)) and (0 =/= #symEcrec(keccakIntList(#asWord(#parseHexWord("0x19") : #parseHexWord("0x1") : .WordStack) Domain_separator keccakIntList(keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")) owner spender value nonce deadline)), v, r, s))

    deadline > TIME
    nonce == Nonce

    v == 27 or v == 28
    s <= #parseHexWord("0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0")

    VCallValue == 0
    VCallDepth < 1024

if

    #rangeUInt(256, Nonce + 1)
```
