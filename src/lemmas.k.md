```k
// encoded underflow protection is logical underflow protection
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
  requires #rangeUInt(256, A) andBool #rangeUInt(256, B)

// dealing with short strings in storage
rule X &Int #asInteger(WS ++ #asByteStack(Y)) => X &Int Y
  requires X <=Int 255
rule 1 &Int (2 *Int X) => 0

rule (#asInteger(WS ++ #asByteStack(Y)) /Int 256) *Int 256 => #asInteger(WS)
  requires #rangeBytes(1, Y)

rule #asInteger(#padRightToWidthAux((W -Int sizeWordStackAux(#asByteStack(X), 0)), #asByteStack(X), .WordStack)) => X
  requires #sizeWordStack(#asByteStack(X)) <=Int W

rule (A *Int B) /Int A => B
  requires notBool (A ==Int 0)
```
