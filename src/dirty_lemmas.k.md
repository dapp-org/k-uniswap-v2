```k
rule #padToWidth(32, #asByteStack(X /Int Y)) => #asByteStackInWidth(X /Int Y, 32)
  requires #rangeUInt(256, X)
  andBool #rangeUInt(256, Y)
```
