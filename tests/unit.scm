#!/usr/bin/guile -s
!#

;;;; Premable

(define load-path--local (string-drop-right (car (command-line)) 9))
(set! %load-path (append (list load-path--local) %load-path))

(use-modules (interactive))

;;;; Unit definitions

;; ts/year

;; ; unit
;; (unit-ex-fail '(1 1 2100) '(1 1 2099) '(31 12 2099))
;; (unit-ex-succ (1 1 2100) (1 1 2099) (1 1 2100))
;; (unit-ex-succ (2 1 2100) (1 1 2100) (3 1 2100))
;; (unit-ex-fail (1 1 2101) (1 1 2100) (31 12 2100))

;; ; or-field
(unit-ex-fail (1 1 (2100 2101 2102)) (1 1 2077) (1 1 2077))
;; (unit-ex-succ (1 1 (2100 2101 2102)) (31 12 2099) (1 1 2100))
;; (unit-ex-succ (1 1 (2100 2101 2102)) (31 12 2100) (1 1 2101))
;; (unit-ex-fail (1 1 (2100 2101 2102)) (31 12 2110) (1 1 2111))

; range
;; (unit-ex-succ (1 1 (- * *)) (31 12 2099) (1 1 2100))
;; (unit-ex-fail (1 1 (- * 2100)) (1 1 2099) (2 1 2099))
;; (unit-ex-succ (1 1 (- * 2100)) (31 12 2099) (1 1 2100))
;; (unit-ex-succ (1 12 (- * 2100)) (1 10 2099) (31 12 2100))
;; (unit-ex-fail (1 12 (- * 2100)) (31 12 2100) (1 1 2101))
;; (unit-ex-fail (1 1 (- 2100 * 2)) (1 1 2099) (2 1 2099))
;; (unit-ex-succ (1 1 (- 2100 * 2)) (1 1 2099) (2 1 2100))
;; (unit-ex-succ (1 1 (- 2100 * 2)) (1 1 2101) (2 1 2102))
;; (unit-ex-fail (1 1 (- 2100 * 2)) (1 1 2101) (2 1 2101))

; mixed or-field

;;;; Final Log
;; (unit-log-end)
