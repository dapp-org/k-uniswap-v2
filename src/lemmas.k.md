### Underflow Checking

Underflow checking as encoded in EVM bytecode by solidity (which knows only 256 bit words), entails
the logical (`Int` based) no-underflow condition on the RHS.

This is required because `K` needs help reasoning its way through the `-Word` operation to simplify
it to match the logical no-underflow constraint expressed within the specs (`iff in range uint256`).

```k
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
  requires #rangeUInt(256, A) andBool #rangeUInt(256, B)
```

### Numerical Constants

The `evm-semantics` only defines ranges and constants for a few solidity types. A couple of extra
ones are required for these specs.

#### `uint32`

```k
syntax Int ::= "maxUInt32"   [function]
rule maxUInt32 => 4294967295 [macro]

rule #rangeUInt(32, X) => #range(0 <= X <= maxUInt32) [macro]
```

#### `uint112`

```k
syntax Int ::= "pow112"                           [function]
rule pow112 => 5192296858534827628530496329220096 [macro]

syntax Int ::= "maxUInt112"                           [function]
rule maxUInt112 => 5192296858534827628530496329220095 [macro]

rule #rangeUInt(112, X) => #range(0 <= X <= maxUInt112) [macro]

// MaxUInt160 two's complement
syntax Int ::= "twos160"
rule twos160 => 115792089237316195423570985007226406215939081747436879206741300988257197096960 [macro]
rule twos160 &Int X => 0
```

#### `uint224`

```k
syntax Int ::= "pow224"                                                             [function]
rule pow224 => 26959946667150639794667015087019630673637144422540572481103610249216 [macro]
```

### Packed Storage { `uint112` `uint112` `uint32` }

These lemmas let `K` simplify the expressions produced when accessing packed storage locations
(e.g. `reserve0_reserve1_blockNumberLast`).

```k
// Reserve0
rule (maxUInt112 &Int ((Z *Int pow224) +Int ((Y *Int pow112) +Int X))) => X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// Reserve1
rule (maxUInt112 &Int (((Z *Int pow224) +Int ((Y *Int pow112) +Int X)) /Int pow112)) => Y
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// BlockNumberLast
rule (maxUInt32 &Int (((Z *Int pow224) +Int ((Y *Int pow112) +Int X)) /Int pow224)) => Z
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
```
