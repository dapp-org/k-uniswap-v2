```k
// encoded underflow protection is logical underflow protection
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
  requires #rangeUInt(256, A) andBool #rangeUInt(256, B)
```

### Macros

```k
syntax Int ::= "pow112" [function]
syntax Int ::= "pow224" [function]
rule pow112 => 5192296858534827628530496329220096                                   [macro]
rule pow224 => 26959946667150639794667015087019630673637144422540572481103610249216 [macro]

syntax Int ::= "maxUInt32"                              [function]
syntax Int ::= "maxUInt112"                             [function]
rule maxUInt32  =>  4294967295                          [macro]
rule maxUInt112 =>  5192296858534827628530496329220095  [macro]

rule #rangeUInt(32, X)  => #range(0 <= X <= maxUInt32)  [macro]
rule #rangeUInt(112, X) => #range(0 <= X <= maxUInt112) [macro]
```

### Packing { uint112 uint112 uint32 }

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
