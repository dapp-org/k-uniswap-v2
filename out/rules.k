requires "edsl.k"

module RULES
    imports EVM
    imports EDSL
    imports K-REFLECTION

// -*- mode: k3; -*-
// VERIFICATION.k

    rule #rangeUInt    (   1 ,      X ) => #range ( 0               <= X <= 1               ) [macro]

    syntax Int ::= nthbyteof ( Int , Int , Int ) [function, smtlib(smt_nthbyteof), proj]
 // ------------------------------------------------------------------------------
    rule nthbyteof(V, I, N) => nthbyteof(V /Int 256, I, N -Int 1) when N  >Int (I +Int 1) [concrete]
    rule nthbyteof(V, I, N) =>           V modInt 256             when N ==Int (I +Int 1) [concrete]

    rule bool2Word(notBool(A ==K 0)) => A
         requires #rangeUInt(1, A)

    //Blasphemy
    rule notBool(notBool(A)) => A

    rule ( WS1 ++ WS2 ) ++ WS3 => WS1 ++ ( WS2 ++ WS3 )


    // These rules exist in KEVM, but are marked [concrete].
    // Declared here to allow symbolic arguments.

    rule #lookup( (KEY |-> VAL) M, KEY ) => VAL
    rule #lookup(               M, KEY ) => 0 requires notBool KEY in_keys(M)

    rule #range(WM, START, WIDTH) => #range(WM, START +Int WIDTH -Int 1, WIDTH, .WordStack)

    rule WM[ N := W : WS     ] => (WM[N <- W])[N +Int 1 := WS]

    // We use #asByteStack to represet byte arrays rather than the #buf abstraction.
    // To enable this both #buf and #sizeByteArray must be symbolic.

    rule #buf(LEN, BYTES) => #padToWidth(LEN, #asByteStack( BYTES ))
    rule #sizeByteArray ( WS ) => #sizeWordStack(WS)

    // Operator direction normalization rules. Required to reduce the number of
    // forms of inequalities that can be matched by general lemmas. We chose to
    // keep <Int and <=Int because those operators are used in all range lemmas
    // and in #range macros. Operators >Int and >=Int are still allowed
    // anywhere except rules LHS. In all other places they will be matched and
    // rewritten by rules below.
    rule notBool (X <Int Y)  => Y <=Int X
    rule notBool (X <=Int Y) => Y <Int X
    rule notBool (X >Int Y)  => X <=Int Y
    rule notBool (X >=Int Y) => X <Int Y



    rule 0 <=Int nthbyteof(V, I, N)          => true
    rule         nthbyteof(V, I, N) <Int 256 => true

    rule #asWord( nthbyteof(V,  0, 32)
                : nthbyteof(V,  1, 32)
                : nthbyteof(V,  2, 32)
                : nthbyteof(V,  3, 32)
                : nthbyteof(V,  4, 32)
                : nthbyteof(V,  5, 32)
                : nthbyteof(V,  6, 32)
                : nthbyteof(V,  7, 32)
                : nthbyteof(V,  8, 32)
                : nthbyteof(V,  9, 32)
                : nthbyteof(V, 10, 32)
                : nthbyteof(V, 11, 32)
                : nthbyteof(V, 12, 32)
                : nthbyteof(V, 13, 32)
                : nthbyteof(V, 14, 32)
                : nthbyteof(V, 15, 32)
                : nthbyteof(V, 16, 32)
                : nthbyteof(V, 17, 32)
                : nthbyteof(V, 18, 32)
                : nthbyteof(V, 19, 32)
                : nthbyteof(V, 20, 32)
                : nthbyteof(V, 21, 32)
                : nthbyteof(V, 22, 32)
                : nthbyteof(V, 23, 32)
                : nthbyteof(V, 24, 32)
                : nthbyteof(V, 25, 32)
                : nthbyteof(V, 26, 32)
                : nthbyteof(V, 27, 32)
                : nthbyteof(V, 28, 32)
                : nthbyteof(V, 29, 32)
                : nthbyteof(V, 30, 32)
                : nthbyteof(V, 31, 32)
                : .WordStack ) => V
      requires 0 <=Int V andBool V <Int pow256


    rule #asWord( nthbyteof(#unsigned(V),  0, 32)
                : nthbyteof(#unsigned(V),  1, 32)
                : nthbyteof(#unsigned(V),  2, 32)
                : nthbyteof(#unsigned(V),  3, 32)
                : nthbyteof(#unsigned(V),  4, 32)
                : nthbyteof(#unsigned(V),  5, 32)
                : nthbyteof(#unsigned(V),  6, 32)
                : nthbyteof(#unsigned(V),  7, 32)
                : nthbyteof(#unsigned(V),  8, 32)
                : nthbyteof(#unsigned(V),  9, 32)
                : nthbyteof(#unsigned(V), 10, 32)
                : nthbyteof(#unsigned(V), 11, 32)
                : nthbyteof(#unsigned(V), 12, 32)
                : nthbyteof(#unsigned(V), 13, 32)
                : nthbyteof(#unsigned(V), 14, 32)
                : nthbyteof(#unsigned(V), 15, 32)
                : nthbyteof(#unsigned(V), 16, 32)
                : nthbyteof(#unsigned(V), 17, 32)
                : nthbyteof(#unsigned(V), 18, 32)
                : nthbyteof(#unsigned(V), 19, 32)
                : nthbyteof(#unsigned(V), 20, 32)
                : nthbyteof(#unsigned(V), 21, 32)
                : nthbyteof(#unsigned(V), 22, 32)
                : nthbyteof(#unsigned(V), 23, 32)
                : nthbyteof(#unsigned(V), 24, 32)
                : nthbyteof(#unsigned(V), 25, 32)
                : nthbyteof(#unsigned(V), 26, 32)
                : nthbyteof(#unsigned(V), 27, 32)
                : nthbyteof(#unsigned(V), 28, 32)
                : nthbyteof(#unsigned(V), 29, 32)
                : nthbyteof(#unsigned(V), 30, 32)
                : nthbyteof(#unsigned(V), 31, 32)
                : .WordStack ) => #unsigned(V)
      requires #rangeSInt(256, V)

    rule #asWord( nthbyteof(keccakIntList(V),  0, 32)
                : nthbyteof(keccakIntList(V),  1, 32)
                : nthbyteof(keccakIntList(V),  2, 32)
                : nthbyteof(keccakIntList(V),  3, 32)
                : nthbyteof(keccakIntList(V),  4, 32)
                : nthbyteof(keccakIntList(V),  5, 32)
                : nthbyteof(keccakIntList(V),  6, 32)
                : nthbyteof(keccakIntList(V),  7, 32)
                : nthbyteof(keccakIntList(V),  8, 32)
                : nthbyteof(keccakIntList(V),  9, 32)
                : nthbyteof(keccakIntList(V), 10, 32)
                : nthbyteof(keccakIntList(V), 11, 32)
                : nthbyteof(keccakIntList(V), 12, 32)
                : nthbyteof(keccakIntList(V), 13, 32)
                : nthbyteof(keccakIntList(V), 14, 32)
                : nthbyteof(keccakIntList(V), 15, 32)
                : nthbyteof(keccakIntList(V), 16, 32)
                : nthbyteof(keccakIntList(V), 17, 32)
                : nthbyteof(keccakIntList(V), 18, 32)
                : nthbyteof(keccakIntList(V), 19, 32)
                : nthbyteof(keccakIntList(V), 20, 32)
                : nthbyteof(keccakIntList(V), 21, 32)
                : nthbyteof(keccakIntList(V), 22, 32)
                : nthbyteof(keccakIntList(V), 23, 32)
                : nthbyteof(keccakIntList(V), 24, 32)
                : nthbyteof(keccakIntList(V), 25, 32)
                : nthbyteof(keccakIntList(V), 26, 32)
                : nthbyteof(keccakIntList(V), 27, 32)
                : nthbyteof(keccakIntList(V), 28, 32)
                : nthbyteof(keccakIntList(V), 29, 32)
                : nthbyteof(keccakIntList(V), 30, 32)
                : nthbyteof(keccakIntList(V), 31, 32)
                : .WordStack ) => keccakIntList(V)

    rule #asWord( nthbyteof(#symEcrec(MSG, V, R, S),  0, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  1, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  2, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  3, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  4, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  5, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  6, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  7, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  8, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S),  9, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 10, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 11, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 12, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 13, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 14, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 15, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 16, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 17, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 18, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 19, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 20, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 21, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 22, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 23, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 24, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 25, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 26, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 27, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 28, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 29, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 30, 32)
                : nthbyteof(#symEcrec(MSG, V, R, S), 31, 32)
                : .WordStack ) => #symEcrec(MSG, V, R, S)


rule ACCTCODE in SetItem( 1 )
                 SetItem ( 2 )
                 SetItem ( 3 )
                 SetItem ( 4 )
                 SetItem ( 5 )
                 SetItem ( 6 )
                 SetItem ( 7 )
                 SetItem ( 8 )
                 SetItem ( 9 )
                 => false
     requires ACCTCODE ==Int 0 orBool 10 <=Int ACCTCODE

    syntax IntList ::= bytesToWords ( WordStack )       [function]

    rule BS [0 .. M] [0 .. N ] => BS [ 0 .. N]
      requires N <=Int M

// --------------------------------------------------------------
    rule bytesToWords ( WS )
         => #asWord(#take(#sizeWordStack(WS) modInt 32, WS)) byteStack2IntList(#drop(#sizeWordStack(WS) modInt 32, WS))
         requires 0 <Int #sizeWordStack(WS) modInt 32

    rule bytesToWords ( WS ) => byteStack2IntList(WS)
         requires #sizeWordStack(WS) modInt 32 ==Int 0

// for terms came from bytecode not via #hashedLocation
    rule keccak(WS) => keccakIntList(bytesToWords(WS))
      requires ( notBool #isConcrete(WS) )

    rule 0 <=Int keccakIntList(N)     => true
    rule keccaktIntList(N) <Int pow256 => true

    rule #padToWidth(32, #asByteStack(V)) => #asByteStackInWidth(V, 32)
      requires 0 <=Int V andBool V <Int pow256

    rule #padToWidth(32, #asByteStack( #unsigned(V) ))
      => #asByteStackInWidth( #unsigned(V), 32)
      requires #rangeSInt(256, V)

    rule #padToWidth(32, #asByteStack( keccakIntList (V) ))
      => #asByteStackInWidth( keccakIntList (V), 32)

    rule #padToWidth(32, #asByteStack( #symEcrec(MSG, V, R, S) ))
      => #asByteStackInWidth( #symEcrec(MSG, V, R, S), 32)

   // for Vyper
    rule #padToWidth(N, #asByteStack(#asWord(WS))) => WS
      requires #sizeWordStack(WS) <=Int 32 andBool N ==Int #sizeWordStack(WS)

    // storing a symbolic boolean value in memory
    rule #padToWidth(32, #asByteStack(bool2Word(E)))
      => #asByteStackInWidthaux(0, 30, 32, nthbyteof(bool2Word(E), 31, 32) : .WordStack)

    // for Solidity
    rule #asWord(WS) /Int D => #asWord(#take(#sizeWordStack(WS) -Int log256Int(D), WS))
      requires D modInt 256 ==Int 0 andBool D >=Int 0
       andBool #sizeWordStack(WS) >=Int log256Int(D)
       andBool #sizeWordStack(WS) <=Int 32

    // for Solidity >= 0.5.6
    rule #asWord(WS) >>Int D => #asWord(#take(#sizeWordStack(WS) -Int (D /Int 8), WS))
     requires D modInt 8 ==Int 0 andBool D >=Int 0
       andBool #sizeWordStack(WS) >=Int (D /Int 8)
       andBool #sizeWordStack(WS) <=Int 32

    rule #sizeWordStack(#take(N, _)) => N
    rule #sizeWordStack(WS) >=Int 0 => true [smt-lemma]

    syntax WordStack ::= #asByteStackInWidth    ( Int, Int )                 [function]
                       | #asByteStackInWidthaux ( Int, Int, Int, WordStack ) [function]
 // -----------------------------------------------------------------------------------
    rule #asByteStackInWidth(X, N) => #asByteStackInWidthaux(X, N -Int 1, N, .WordStack)

    rule #asByteStackInWidthaux(X, I, N, WS) => #asByteStackInWidthaux(X, I -Int 1, N, nthbyteof(X, I, N) : WS) when I >Int 0
    rule #asByteStackInWidthaux(X, 0, N, WS) => nthbyteof(X, 0, N) : WS

    rule 0 +Int N => N
    rule N +Int 0 => N

    rule N -Int 0 => N

    rule 1 *Int N => N
    rule N *Int 1 => N
    rule 0 *Int _ => 0
    rule _ *Int 0 => 0

    rule N /Int 1 => N
    rule N *Int A /Int A => N

    rule 0 |Int N => N
    rule N |Int 0 => N
    rule N |Int N => N

    rule 0 &Int N => 0
    rule N &Int 0 => 0
    rule N &Int N => N

    rule N <<Int 0 => N
    rule N >>Int 0 => N

    rule (I1 +Int I2) +Int I3 => I1 +Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 +Int I2) -Int I3 => I1 +Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 -Int I2) +Int I3 => I1 -Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
    rule (I1 -Int I2) -Int I3 => I1 -Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)

    rule I1 &Int (I2 &Int I3) => (I1 &Int I2) &Int I3 when #isConcrete(I1) andBool #isConcrete(I2)

    // 0xffff...f &Int N = N
    rule MASK &Int N => N  requires MASK ==Int (2 ^Int (log2Int(MASK) +Int 1)) -Int 1 // MASK = 0xffff...f
                            andBool 0 <=Int N andBool N <=Int MASK

    // 0xffff...f &Int N = N
    rule N &Int MASK => N  requires MASK ==Int (2 ^Int (log2Int(MASK) +Int 1)) -Int 1 // MASK = 0xffff...f
                            andBool 0 <=Int N andBool N <=Int MASK


    /// GAS Simplification
    rule (#if C #then B1 #else B2 #fi) >Int A => true
      requires B1 >Int A andBool B2 >Int A

    rule (#if C #then B1 #else B2 #fi) >=Int A => true
      requires B1 >=Int A andBool B2 >=Int A

    rule #if C #then (#if C #then B1 #else B2 #fi) -Int D #else (#if C #then B3 #else B4 #fi) -Int E #fi =>
         #if C #then B1 -Int D #else B4 -Int E #fi

    // avoid nested #ifte
    rule #if C1 #then A #else (B +Int #if C2 #then B2 #else B3 #fi) #fi =>
         #if C1 #then A #else B #fi +Int #if (C2 andBool notBool C1) #then B2 #else 0 #fi +Int #if ((notBool C2) andBool (notBool C1)) #then B3 #else 0 #fi

   //simplify trivial #ifs
   rule #if C1 #then A #else B #fi => A
      requires A ==K B

   // propagate stuff out of #ifs
    rule #if C #then X #else Y #fi => Y +Int #if C #then X -Int Y #else 0 #fi
      requires #isConcrete(X)
      andBool  #isConcrete(Y)
      andBool  X >Int Y
      andBool  Y =/=Int 0

    rule #if C #then X #else Y #fi => X +Int #if C #then 0 #else Y -Int X #fi
      requires #isConcrete(X)
      andBool  #isConcrete(Y)
      andBool  Y >Int X
      andBool  X =/=Int 0

    rule #if C #then X +Int A #else X +Int B #fi => X +Int (#if C #then A #else B #fi)

    rule #if C #then (A +Int X) #else (B +Int X) #fi => ( #if C #then A #else B #fi ) +Int X

    rule #if C #then G -Int X #else G -Int Y #fi => G -Int (#if C #then X #else Y #fi)

    rule #if C #then X -Int G #else Y -Int G #fi => (#if C #then X #else Y #fi) -Int G

    rule #if C #then ((P -Int X) -Int A) #else ((Q -Int X) -Int B) #fi => (#if C #then (P -Int A) #else (Q -Int B) #fi) -Int X

    // NEW GAS LEMMAS
    // join together concrete numbers
    rule (A -Int  B) -Int C  =>  A -Int (B +Int C)
    rule (A -Int  B) +Int C  =>  A -Int (B -Int C)
    rule (A +Int B) -Int C  => A +Int (B -Int C)
    rule (A +Int B) +Int  C => A +Int (B +Int C)

    // deal with 0
    rule  A +Int (0 -Int  C) => A -Int C
      requires (notBool #isConcrete(C))
    rule  A -Int (0 -Int  C) => A +Int C
      requires (notBool #isConcrete(C))


    // deal with negative concrete number
    rule A -Int B => A +Int (0 -Int B)
      requires #isConcrete(B)
      andBool B <Int 0

    rule A +Int B => A -Int (0 -Int B)
      requires #isConcrete(B)
      andBool B <Int 0

    // SORT

    //    DIV
    rule  A -Int ( (B /Int 64)  +Int C) => (0 -Int ( (B /Int 64) -Int (A -Int C)))
      requires (notBool #isVariable(A))
      andBool (notBool #isConcrete(A))
      andBool (A =/=K (D /Int 64))
    rule  A -Int ( (B /Int 64)  -Int C) => (0 -Int ( (B /Int 64) -Int (A +Int C)))
      requires (notBool #isVariable(A))
      andBool (notBool #isConcrete(A))
      andBool (A =/=K (D /Int 64))
    rule  A +Int ( (B /Int 64) +Int  C) => (B /Int 64) +Int (A +Int  C)
      requires (notBool #isVariable(A))
      andBool (notBool #isConcrete(A))
      andBool (A =/=K (D /Int 64))
    rule  A +Int ( (B /Int 64) -Int  C) => (B /Int 64) +Int (A -Int  C)
      requires (notBool #isVariable(A))
      andBool (notBool #isConcrete(A))
      andBool (A =/=K (D /Int 64))

    //    VAR
    rule  A -Int (B  +Int C) => (0 -Int (B -Int (A -Int C)))
      requires #isVariable(B)
      andBool (notBool #isVariable(A))
      andBool (A =/=K 0)
    rule  A -Int (B  -Int C) => (0 -Int (B -Int (A +Int C)))
      requires #isVariable(B)
      andBool (notBool #isVariable(A))
      andBool (A =/=K 0)
    rule  A +Int (B +Int  C) => B +Int (A +Int  C)
      requires #isVariable(B)
      andBool (notBool #isVariable(A))
      andBool (A =/=K 0)
    rule  A +Int (B -Int  C) => B +Int (A -Int  C)
      requires #isVariable(B)
      andBool (notBool #isVariable(A))
      andBool (A =/=K 0)

    //    CONCRETE
    rule  A -Int (B  +Int C) => (0 -Int (B -Int (A -Int C)))
      requires #isConcrete(A)
      andBool A =/=Int 0
      andBool (notBool #isConcrete(B))
    rule  A -Int (B  -Int C) => (0 -Int (B -Int (A +Int C)))
      requires #isConcrete(A)
      andBool A =/=Int 0
      andBool (notBool #isConcrete(B))
    rule  A +Int (B +Int  C) => B +Int (A +Int  C)
      requires #isConcrete(A)
      andBool (notBool #isConcrete(B))
    rule  A +Int (B -Int  C) => B +Int (A -Int  C)
      requires #isConcrete(A)
      andBool (notBool #isConcrete(B))

    // SOLVE
    //    duplicates
    rule A -Int (A +Int B) => 0 -Int B
    rule A -Int (A -Int B) => B
    rule A -Int (B +Int (A +Int C)) => 0 -Int (B +Int C)
    rule A -Int (B +Int (A -Int C)) => 0 -Int (B -Int C)

    //    concrete
    rule  A -Int (B  -Int C) => (A -Int  B) +Int C
      requires #isConcrete(A)
      andBool  #isConcrete(B)
    rule  A -Int (B  +Int C) => (A -Int  B) -Int C
      requires #isConcrete(A)
      andBool  #isConcrete(B)
    rule  A +Int (B -Int  C) => (A +Int  B) -Int C
      requires #isConcrete(A)
      andBool  #isConcrete(B)
    rule  A +Int (B +Int  C) => (A +Int  B) +Int C
      requires #isConcrete(A)
      andBool  #isConcrete(B)



    /// ---


    rule A -Int A => 0

    rule bool2Word(A) |Int bool2Word(B) => bool2Word(A  orBool B)
    rule bool2Word(A) &Int bool2Word(B) => bool2Word(A andBool B)

    rule bool2Word(A)  ==K 0 => notBool(A)
    rule bool2Word(A)  ==K 1 => A

    rule 1 |Int bool2Word(X) => 1
    rule  bool2Word(X) |Int 1 => 1
    rule 1 &Int bool2Word(X) => bool2Word(X)
    rule bool2Word(X) &Int 1 => bool2Word(X)

    rule chop(bool2Word(B)) => bool2Word(B)





    rule 0 <=Int chop(V)             => true
    rule         chop(V) <Int pow256 => true

    rule 0 <=Int keccak(V)             => true
    rule         keccak(V) <Int pow256 => true

    rule 0 <=Int X &Int Y             => true requires 0 <=Int X andBool X <Int pow256 andBool 0 <=Int Y andBool Y <Int pow256
    rule         X &Int Y <Int pow256 => true requires 0 <=Int X andBool X <Int pow256 andBool 0 <=Int Y andBool Y <Int pow256





    rule chop(I) => I requires 0 <=Int I andBool I <Int pow256




rule chop(#unsigned(W)) => #unsigned(W)
  requires #rangeSInt(256, W)

rule #signed(#unsigned(W)) => W
  requires #rangeSInt(256, W)

rule #unsigned(#signed(W)) => W
  requires #rangeUInt(256, W)

rule W0 s<Word W1 => #signed(W0) <Word #signed(W1)

rule   #signed(X) ==K   #signed(Y) => X ==K Y requires #rangeUInt(256,X) orBool #rangeUInt(256,Y)
rule #unsigned(X) ==K #unsigned(Y) => X ==K Y requires #rangeSInt(256,X) orBool #rangeSInt(256,Y)


rule A modInt pow160 => A
  requires #rangeAddress(A)

syntax Bool ::= #notPrecompileAddress ( Int ) [function]
// ---------------------------------------
rule #notPrecompileAddress ( X ) => 0 ==Int X orBool (10 <=Int X andBool #rangeAddress(X))

// ABSTRACT SEMANTICS.k

  rule <k> LT W0 W1 => bool2Word(W0  <Int W1) ~> #push ... </k> [trusted]
  rule <k> GT W0 W1 => bool2Word(W0  >Int W1) ~> #push ... </k> [trusted]
  rule <k> EQ W0 W1 => bool2Word(W0 ==Int W1) ~> #push ... </k> [trusted]
  rule <k> ISZERO W => bool2Word(W  ==Int 0 ) ~> #push ... </k> [trusted]


//RULES MUST USE ==K and not ==Int
//Warning: assumes injective hashing
rule #newAddr(A, B) ==K 0 => false

rule 0 ==K #newAddr(A, B, C) => false

rule keccakIntList(A B .IntList) ==K keccakIntList(C D .IntList) => A ==Int C andBool B ==Int D

rule keccakIntList(A B C .IntList) ==K keccakIntList(D E F .IntList) => A ==Int D andBool B ==Int E andBool C ==Int F


rule keccakIntList(C) ==K A => false
     requires 0 <=Int A andBool A <=Int 20

rule keccakIntList(C) +Int B ==K A => false
     requires 0 <=Int A andBool A <=Int 20
     andBool 0 <=Int B andBool B <=Int 20

rule A ==K keccakIntList(C) +Int B => false
     requires 0 <=Int A andBool A <=Int 20
     andBool 0 <=Int B andBool B <=Int 20

rule keccakIntList(C) +Int B ==K keccakIntList(A) => false
     requires 0 <=Int B andBool B <=Int 20

rule keccakIntList(A) +Int B ==K keccakIntList(A) +Int C => false
     requires B =/=Int C

rule keccakIntList(A) +Int B ==K keccakIntList(C) +Int D => false
     requires B =/=K C


rule keccakIntList(A) ==K keccakIntList(C) +Int B => false
     requires 0 <=Int B andBool B <=Int 20


rule A ==K keccakIntList(C) => false
     requires 0 <=Int A andBool A <=Int 20

//Symbolic wrapper over the argument of #ecrec, no implementation.
//                         hash v  r   s
syntax Int ::= #symEcrec ( Int , Int , Int , Int ) [function]

rule <k> ECREC => #end EVMC_SUCCESS ... </k>
       <callData> DATA </callData>
       <output> _ => #ecrec(#symEcrec(#asWord(#take(32, DATA)), #asWord(#take(32, #drop(32, DATA))), #asWord(#take(32, #drop(64, DATA))), #asWord(#take(32, #drop(96, DATA))))) </output>
    requires notBool #isConcrete(DATA) andBool #sizeWordStack(DATA) ==Int 128
[trusted]

rule #memoryUsageUpdate(MU, START, WIDTH) => maxInt(MU, (START +Int WIDTH) up/Int 32) requires WIDTH  >Int 0


// ./src/storage.k.md

syntax Int ::= "Constants.PermitTypehash" [function]
rule Constants.PermitTypehash => keccak(#parseByteStackRaw("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")) [macro]
syntax Int ::= "#UniswapV2Exchange.totalSupply" [function]
rule #UniswapV2Exchange.totalSupply => 0
syntax Int ::= "#UniswapV2Exchange.balanceOf" "[" Int "]" [function]
rule #UniswapV2Exchange.balanceOf[A] => #hashedLocation("Solidity", 1, A)
syntax Int ::= "#UniswapV2Exchange.allowance" "[" Int "][" Int "]" [function]
rule #UniswapV2Exchange.allowance[A][B] => #hashedLocation("Solidity", 2, A B)
syntax Int ::= "#UniswapV2Exchange.DOMAIN_SEPARATOR" [function]
rule #UniswapV2Exchange.DOMAIN_SEPARATOR => 3
syntax Int ::= "#UniswapV2Exchange.nonces" "[" Int "]" [function]
rule #UniswapV2Exchange.nonces[A] => #hashedLocation("Solidity", 4, A)
syntax Int ::= "#UniswapV2Exchange.factory" [function]
rule #UniswapV2Exchange.factory => 5
syntax Int ::= "#UniswapV2Exchange.token0" [function]
rule #UniswapV2Exchange.token0 => 6
syntax Int ::= "#UniswapV2Exchange.token1" [function]
rule #UniswapV2Exchange.token1 => 7
// word packing helper
syntax Int ::= "#WordPackUInt112UInt112UInt32" "(" Int "," Int "," Int ")" [function]
rule #WordPackUInt112UInt112UInt32(X, Y, Z) => Z *Int pow224 +Int Y *Int pow112 +Int X
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

syntax Int ::= "#UniswapV2Exchange.reserve0_reserve1_blockTimestampLast" [function]
rule #UniswapV2Exchange.reserve0_reserve1_blockTimestampLast => 8
syntax Int ::= "#UniswapV2Exchange.price0CumulativeLast" [function]
rule #UniswapV2Exchange.price0CumulativeLast => 9
syntax Int ::= "#UniswapV2Exchange.price1CumulativeLast" [function]
rule #UniswapV2Exchange.price1CumulativeLast => 10
syntax Int ::= "#UniswapV2Exchange.kLast" [function]
rule #UniswapV2Exchange.kLast => 11
syntax Int ::= "#UniswapV2Exchange.unlocked" [function]
rule #UniswapV2Exchange.unlocked => 12
syntax Int ::= "#UniswapV2Factory.feeTo" [function]
rule #UniswapV2Factory.feeTo => 0
syntax Int ::= "#UniswapV2Factory.feeToSetter" [function]
rule #UniswapV2Factory.feeToSetter => 1
syntax Int ::= "#UniswapV2Factory.getExchange" "[" Int "][" Int "]" [function]
rule #UniswapV2Factory.getExchange[A][B] => #hashedLocation("Solidity", 2, A B)
syntax Int ::= "#UniswapV2Factory.allExchanges.length" [function]
rule #UniswapV2Factory.allExchanges.length => 3
syntax Int ::= "exchanges0" [function]
rule exchanges0 => 87903029871075914254377627908054574944891091886930582284385770809450030037083 [macro]

syntax Int ::= "#UniswapV2Factory.allExchanges" "[" Int "]" [function]
rule #UniswapV2Factory.allExchanges[N] => exchanges0 +Int N
// ./src/lemmas.k.md

syntax Int ::= "pow32"   [function]
rule pow32 => 4294967296 [macro]

syntax Int ::= "pow112"                           [function]
rule pow112 => 5192296858534827628530496329220096 [macro]

syntax Int ::= "pow224"                                                             [function]
rule pow224 => 26959946667150639794667015087019630673637144422540572481103610249216 [macro]
syntax Int ::= "maxUInt32"   [function]
rule maxUInt32 => 4294967295 [macro]

syntax Int ::= "maxUInt112"                           [function]
rule maxUInt112 => 5192296858534827628530496329220095 [macro]

syntax Int ::= "maxUInt224"                                                             [function]
rule maxUInt224 => 26959946667150639794667015087019630673637144422540572481103610249215 [macro]
syntax Int ::= "notMaxUInt112"                                                                       [function]
rule notMaxUInt112 => 115792089237316195423570985008687907853269979473343705504629955477416800419840 [macro]

syntax Int ::= "notMaxUInt160"                                                                       [function]
rule notMaxUInt160 => 115792089237316195423570985007226406215939081747436879206741300988257197096960 [macro]

syntax Int ::= "notMaxUInt224"                                                                       [function]
rule notMaxUInt224 => 115792089210356248756420345214020892766250353992003419616917011526809519390720 [macro]
rule #rangeUInt(32, X) => #range(0 <= X <= maxUInt32)   [macro]
rule #rangeUInt(112, X) => #range(0 <= X <= maxUInt112) [macro]
rule A -Word B <=Int A => #rangeUInt(256, A -Int B)
  requires #rangeUInt(256, A) andBool #rangeUInt(256, B)
rule (maxUInt32 &Int X) => (X modInt pow32)
rule ((X modInt pow32) modInt pow32) => (X modInt pow32)
rule (X &Int maxUInt32) => (maxUInt32 &Int X)
rule (X &Int maxUInt112) => (maxUInt112 &Int X)
rule (X &Int maxUInt160) => (maxUInt160 &Int X)
rule (X &Int notMaxUInt224) => (notMaxUInt224 &Int X)
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

// BlockTimestampLast
rule (maxUInt32 &Int (((Z *Int pow224) +Int ((Y *Int pow112) +Int X)) /Int pow224)) => Z
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
// all regions potentially non-zero
rule (notMaxUInt112 &Int ((Z *Int pow224) +Int ((Y *Int pow112) +Int X))) => ((Z *Int pow224) +Int (Y *Int pow112))
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// reserve0 is zero
rule (notMaxUInt112 &Int ((Z *Int pow224) +Int (Y *Int pow112))) => ((Z *Int pow224) +Int (Y *Int pow112))
  requires #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// reserve1 is zero
rule (notMaxUInt112 &Int ((Z *Int pow224) +Int X)) => (Z *Int pow224)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(32, Z)
// all regions potentially non-zero OR reserve0 is zero
rule (X |Int ((Z *Int pow224) +Int (Y *Int pow112))) => ((Z *Int pow224) +Int (Y *Int pow112) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// reserve1 is zero
rule (X |Int (Z *Int pow224)) => ((Z *Int pow224) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(32, Z)
syntax Int ::= "notMaxUInt112xPow112"                                                                       [function]
rule notMaxUInt112xPow112 => 115792089210356248756420345214020892766250359184300278151744640057305848610815 [macro]
rule (I +Int ((Z *Int pow224) +Int ((Y *Int pow112) -Int J))) => ((Z *Int pow224) +Int ((Y *Int pow112) +Int (I -Int J)))
  requires #rangeUInt(112, I -Int J)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
// all regions potentially non-zero
rule (notMaxUInt112xPow112 &Int ((Z *Int pow224) +Int ((Y *Int pow112) +Int X))) => ((Z *Int pow224) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// reserve1 is zero
rule (notMaxUInt112xPow112 &Int ((Z *Int pow224) +Int X)) => ((Z *Int pow224) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(32, Z)
// all regions potentially non-zero OR reserve1 is zero
rule ((pow112 *Int Y) |Int ((Z *Int pow224) +Int X)) => ((Z *Int pow224) +Int (Y *Int pow112) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)

// reserve0 is zero
rule ((pow112 *Int Y) |Int (Z *Int pow224)) => ((Z *Int pow224) +Int (Y *Int pow112))
  requires #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
rule (maxUInt224 &Int ((Z *Int pow224) +Int ((Y *Int pow112) +Int X))) => ((Y *Int pow112) +Int X)
requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
rule ((Z *Int pow224) |Int ((Y *Int pow112) +Int X)) => ((Z *Int pow224) +Int (Y *Int pow112) +Int X)
  requires #rangeUInt(112, X)
  andBool #rangeUInt(112, Y)
  andBool #rangeUInt(32, Z)
// Overwrite A with B
rule ((notMaxUInt160 &Int A)) |Int B => B
  requires #rangeAddress(B)
  andBool (#rangeAddress(A) orBool #rangeUInt(256, A))

// Commutativity
rule ((A &Int notMaxUInt160)) |Int B => B
  requires #rangeAddress(B)
  andBool (#rangeAddress(A) orBool #rangeUInt(256, A))

rule (B |Int (notMaxUInt160 &Int A)) => B
  requires #rangeAddress(B)
  andBool (#rangeAddress(A) orBool #rangeUInt(256, A))

rule (B |Int (A &Int notMaxUInt160)) => B
  requires #rangeAddress(B)
  andBool (#rangeAddress(A) orBool #rangeUInt(256, A))
// mask first four bytes to zero
rule maxUInt224 &Int #asWord(WS) => #asWord(#padToWidth(32, #drop(4, WS)))
  requires #sizeWordStack(WS) ==Int 32

// mask everything except first four bytes to zero
rule notMaxUInt224 &Int #asWord(WS) => #asWord(#padRightToWidth(32, #take(4, WS)))
  requires #sizeWordStack(WS) ==Int 32
// write first four bytes
rule X |Int #asWord(#padToWidth(32, WS)) => #asWord(#take(4, #asByteStack(X)) ++ WS)
  requires X &Int notMaxUInt224 ==Int X
  andBool #rangeUInt(256, X)
  andBool #sizeWordStack(WS) ==Int 28
rule #padToWidth(32, #asByteStack(#asWord(#padRightToWidth(32, (nthbyteof(XX, 28, 32) : nthbyteof(XX, 29, 32) : nthbyteof(XX, 30, 32) : nthbyteof(XX, 31, 32) : .WordStack) )))) => (nthbyteof(XX, 28, 32) : nthbyteof(XX, 29, 32) : nthbyteof(XX, 30, 32) : nthbyteof(XX, 31, 32) : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : 0 : .WordStack)


// dyn_ prefix for handling dynamic data

// real size of the "rest" of the wordstack with some weird ceil32 voodoo
syntax Int ::= "#dyn_size" "(" ByteArray "," ByteArray ")" [function, smtlib(cleanCalldata)]

rule #sizeWordStack(XS
  ++ #padToWidth((#ceil32(#sizeWordStack(XS)) -Int #sizeWordStack(XS)), .WordStack)
  ++ CD) => #dyn_size(XS, CD)


//
// syntax Int ::= "#dyn_length" "(" ByteArray "," ByteArray ")" [function, smtlib(dyn_length)]
// rule #asWord(takeWordStack(32, (
//        #padToWidth(32, #asByteStack(#getValue(#uint256(#sizeWordStack(XS)))))
//     ++ XS
//     ++ #padToWidth((#ceil32(#sizeWordStack(XS)) -Int #sizeWordStack(XS)), .WordStack)
//     ++ CD
//   ))) => #dyn_length(XS, CD)

// TODO - temporary rule to neglect dynamic memory gas
// rule #memoryUsageUpdate(X, Y, #dyn_length(Z, CD)) => 0

// ?
// rule #padToWidth(32, #asByteStack(#dyn_length(ABI_calldata, CD))) => (nthbyteof(#dyn_length(ABI_calldata, CD), 0, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 1, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 2, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 3, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 4, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 5, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 6, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 7, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 8, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 9, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 10, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 11, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 12, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 13, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 14, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 15, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 16, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 17, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 18, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 19, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 20, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 21, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 22, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 23, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 24, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 25, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 26, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 27, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 28, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 29, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 30, 32)
//  : nthbyteof(#dyn_length(ABI_calldata, CD), 31, 32)
//  : .WordStack
// )

// rule #take(#dyn_length(ABI_calldata, CD), #drop(32, #padToWidth(32, X) ++ (ABI_calldata ++ XX))) => ABI_calldata

// rule takeWordStack(32, padToWidth(32, X) ++ XS) => X
// rule #take(32, #padToWidth(32, X) ++ XS) => X

// takeWordStack(32, #padToWidth(32, X) ++ XS)
// X  #asByteStack(#getValue(#uint256(#sizeWordStack(ABI_calldata))))
// XS ABI_calldata ++ (#padToWidth((#ceil32(#sizeWordStack(ABI_calldata)) - #sizeWordStack(ABI_calldata)), .WordStack) ++ CD)

rule #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1,    #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, #drop(1, (#padToWidth(32, X) ++ XS))))))))))))))))))))))))))))))))) => XS

rule #take(#sizeWordStack(X), X ++ XS) => X


// ??
// rule takeWordStack(#dyn_length(ABI_calldata, CD), (ABI_calldata ++ #padToWidth((#ceil32(#sizeWordStack(ABI_calldata)) -Int #sizeWordStack(ABI_calldata)), .WordStack) ++ CD)) => (ABI_calldata ++ #padToWidth((#ceil32(#sizeWordStack(ABI_calldata)) -Int #sizeWordStack(ABI_calldata)), .WordStack))

//rule (maxInt(0, ((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32)) *Int 3) +Int ((maxInt(0, ((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32)) *Int maxInt(0, ((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32))) /Int 512) =>
//  (((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32) *Int 3) +Int (( ((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32) *Int  ((#dyn_length(ABI_calldata, CD) +Int 583) /Int 32)) /Int 512)



// !!! padToWidth(32, X) => X if len(X) >= 32 !!!



// map propagae map_update
rule #range(XS [ K1 <- V1 ], K2, Length, .WordStack) => #range(XS, K2, Length, .WordStack)
requires K1 >=Int K2 +Int Length

// map propagate assign
rule #range(X [ K1 := V1:WordStack ], K2, Length, WS) => #range(X, K2, Length, WS)
  requires K2 +Int Length <=Int K1


syntax Int ::= "not31"                                                             [function]
rule not31 => 115792089237316195423570985008687907853269984665640564039457584007913129639904 [macro]

// todo get better rule :(
rule chop(520 +Int ((X +Int 31) &Int not31)) => 520 +Int ((X +Int 31) &Int not31)

rule maxInt(X, Y /Int Z) => Y /Int Z
  requires X *Int Z <=Int Y

rule maxInt(Y /Int Z, X) => Y /Int Z
  requires X *Int Z <=Int Y

rule (X +Int Y) -Word Z => Y +Int (X -Int Z)
  requires #isConcrete(X)
  andBool #isConcrete(Z)
  andBool notBool #isConcrete(Y)
  andBool X >=Int Z


syntax Bool ::= "#unknown_address" "(" Int  ")" [function, smtlib(unknown_address)]
syntax Int ::= "#usedGas" "(" Int  ")" [function, smtlib(usedGas)]

endmodule
