```k
// encoded underflow protection is logical underflow protection
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
```
