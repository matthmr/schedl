#!/usr/bin/guile -s
!#

;;;; Premable

(define load-path--local (string-drop-right (car (command-line)) 12))
(set! %load-path (append (list load-path--local) %load-path))

(use-modules (interactive))

;;;; Fails (comment or remove when commiting to master)

;;;; Unit definitions

(unit-ex-succ (1 1 (2100 2101 2102)) (31 12 2099) (1 1 2100))
(unit-ex-succ (1 1 (2100 2102 (- 2103 * 2))) (31 12 2100) (1 1 2103))
(unit-ex-succ (10 jan 2100) (1 1 2100) (10 1 2100))
(unit-ex-succ (mon jan) (31 12 2099) (4 1 2100))
(unit-ex-succ (10 (- jan feb) 2100) (20 1 2100) (10 2 2100))
(unit-ex-succ ((- mon wed) 1 2100) (3 1 2100) (5 1 2100))
(unit-ex-fail (31 2 2100) (1 2 2100) (1 3 2100))
(unit-ex-fail ((- 29 30) 2 2100) (1 2 2100) (1 3 2100))
(unit-ex-succ (2 *) (31 12 2099) (2 1 2100))
(unit-ex-succ (2 *) (1 12 2099) (1 1 2100))
(unit-ex-succ ((10 20) (jan feb)) (30 1 2100) (10 2 2100))

;;;; Final Log

(unit-log-end)
