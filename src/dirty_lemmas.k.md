```k
syntax TypedArg ::= #uint112 ( Int )

rule #typeName(#uint112( _ )) => "uint112"

rule #lenOfHead(#uint112( _ )) => 32

rule #isStaticType(#uint112( _ )) => true

rule #enc(#uint112( DATA )) => #buf(32, #getValue(#uint112( DATA )))

rule #getValue(#uint112( DATA )) => DATA
  requires #rangeUInt(112, DATA)
```
