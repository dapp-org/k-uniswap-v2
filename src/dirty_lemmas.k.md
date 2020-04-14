```k
rule chop(X *Int (maxUInt32 &Int Y)) => X *Int (maxUInt32 &Int Y)
     requires #rangeUInt(224, X)
     andBool  #rangeUint(256, Y)
```
