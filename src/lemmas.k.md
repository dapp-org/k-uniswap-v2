```k
// encoded underflow protection is logical underflow protection
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
  requires #rangeUInt(256, A) andBool #rangeUInt(256, B)

// dealing with short strings in storage
rule 1 &Int #asInteger(WS ++ #asByteStack(X)) => 1 &Int X
rule 1 &Int (2 *Int X) => 0
```
