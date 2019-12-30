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

    Bal_src : uint256
    Bal_dst : uint256

storage

    balanceOf[CALLER_ID] |-> Bal_src => Bal_src - value
    balanceOf[to]        |-> Bal_dst => Bal_dst + value

iff

    VCallValue == 0

iff in range uint256

    Bal_src - value
    Bal_dst + value

if
    to =/= CALLER_ID

returns 1
```

```act
behaviour transfer-same of ERC20
interface transfer(address to, uint value)

types

    Bal_src : uint256

storage

    balanceOf[CALLER_ID] |-> Bal_src => Bal_src

iff

    VCallValue == 0

iff in range uint256

    Bal_src - value

if
    to == CALLER_ID

returns 1
```

### Burn

```act
behaviour burn of ERC20
interface burn(uint value)

types

    Bal_src   : uint256
    Bal_total : uint256


storage

    balanceOf[CALLER_ID] |-> Bal_src   => Bal_src - value
    totalSupply          |-> Bal_total => Bal_total - value

iff

    VCallValue == 0

iff in range uint256

    Bal_src - value
    Bal_total - value
```
