```smt2

(set-option :auto-config false) ; disable automatic self configuration
(set-option :smt.mbqi false) ; disable model-based quantifier instantiation

(declare-fun smt_sqrt (Int) Int)

; sqrt(x) is always >= 0
(assert (forall ((x Int))
                (! (>= (smt_sqrt x) 0)
                   :pattern ((smt_sqrt x)))))

; if x is >= 0 then sqrt(x) is always <= x
(assert (forall ((x Int))
                (! (=> (>= x 0) (<= (smt_sqrt x) x))
                   :pattern ((smt_sqrt x)))))

; if x and y are both > 0 then sqrt(x * y) > 0
(assert (forall ((x Int) (y Int))
                (! (=> (and (> x 0) (> y 0)) (> (smt_sqrt (* x y)) 0))
                   :pattern ((smt_sqrt (* x y))))))

;
; end of prelude
;
```
