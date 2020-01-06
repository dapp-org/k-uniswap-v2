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

returns keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"))

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
behaviour approve of ERC20
interface approve(address spender, uint value)

types

    Allowance : uint256

storage

    allowance[CALLER_ID][spender] |-> Allowance => Value

iff

    VCallValue == 0

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

### BurnFrom

```act
behaviour burnFrom of ERC20
interface burnFrom(address from, uint value)

types

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
behaviour permit of ERC20
interface permit(address owner, address spender, uint value, uint nonce, uint deadline, uint8 v, bytes32 r, bytes32 s)

types

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
