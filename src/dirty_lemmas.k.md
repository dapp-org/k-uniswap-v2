```k
rule chop(X *Int (maxUInt32 &Int Y)) => X *Int (maxUInt32 &Int Y)
     requires #rangeUInt(224, X)
     andBool  #rangeUInt(256, Y)
```
