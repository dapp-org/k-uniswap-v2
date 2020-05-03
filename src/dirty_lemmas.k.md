```k
rule chop(((pow112 *Int A) /Int B) *Int X) => ((pow112 *Int A) /Int B) *Int X
        requires A <Int pow112
        andBool B >Int 0
        andBool X <Int pow32
```
