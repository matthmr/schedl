#!/usr/bin/guile -s
!#

;;;; Premable

(define load-path--local (string-drop-right (car (command-line)) 14))
(set! %load-path (append (list load-path--local) %load-path))

(use-modules (interactive))

;;;; Fails (comment or remove when commiting to master)

;;;; Unit definitions

;;; NOTE: this is a bottom-up test suite: it'll test single scopes, with unit
;;;   matches. Later matches redo this base test. In practice, that means that
;;;  `day' gets tested with unit `mon' and `year', and when we're testing the
;;;  latter, we use the same base of `day' again. Think of it kind of like
;;;  'counting in binary' with the tests.

;;; *day

;; unit

(unit-ex-fail (10 1 2100) (1 1 2100) (2 1 2100))
(unit-ex-succ (10 1 2100) (1 1 2100) (10 1 2100))
(unit-ex-succ (10 1 2100) (1 1 2100) (11 1 2100))
(unit-ex-fail (10 1 2100) (10 1 2100) (11 1 2100))
(unit-ex-fail (10 1 2100) (11 1 2100) (12 1 2100))

; path
(unit-ex-fail (10 10 2100) (31 12 2099) (9 10 2100))
(unit-ex-fail (10 10 2100) (1 1 2100) (9 10 2100))
(unit-ex-succ (10 10 2100) (31 12 2099) (10 10 2100))
(unit-ex-succ (10 10 2100) (1 1 2100) (10 10 2100))

(unit-ex-fail (10 10 2100) (10 10 2100) (1 1 2101))
(unit-ex-fail (10 10 2100) (10 10 2100) (1 11 2100))
(unit-ex-succ (10 10 2100) (9 10 2100) (1 1 2101))
(unit-ex-succ (10 10 2100) (9 10 2100) (1 11 2100))

(unit-ex-succ (10 10 2100) (31 12 2099) (1 1 2101))
(unit-ex-succ (10 10 2100) (1 1 2100) (1 1 2101))
(unit-ex-succ (10 10 2100) (31 12 2099) (11 12 2100))
(unit-ex-succ (10 10 2100) (1 1 2100) (11 12 2100))

;; glob

(unit-ex-fail (* 10 2100) (10 10 2100) (10 10 2100))
(unit-ex-succ (* 10 2100) (1 10 2100) (2 10 2100))

; path
(unit-ex-succ (* 10 2100) (1 1 2099) (1 10 2100))
(unit-ex-succ (* 10 2100) (1 9 2100) (1 10 2100))

(unit-ex-fail (* 9 2100) (30 9 2100) (1 1 2101))
(unit-ex-fail (* 9 2100) (30 9 2100) (1 10 2100))
(unit-ex-succ (* 9 2100) (29 9 2100) (1 1 2101))
(unit-ex-succ (* 9 2100) (29 9 2100) (1 10 2100))

(unit-ex-succ (* 9 2100) (31 12 2099) (1 1 2101))
(unit-ex-succ (* 9 2100) (1 1 2100) (1 1 2101))
(unit-ex-succ (* 9 2100) (31 12 2099) (11 12 2100))
(unit-ex-succ (* 9 2100) (1 1 2100) (11 12 2100))

;; range

(unit-ex-fail ((- 10 20 2) 10 2100) (1 10 2100) (2 10 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (1 10 2100) (10 10 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 10 2100) (12 10 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 10 2100) (14 10 2100))
(unit-ex-fail ((- 10 20 2) 10 2100) (10 10 2100) (11 10 2100))

; path
(unit-ex-fail ((- 10 20 2) 10 2100) (1 10 2099) (1 10 2100))
(unit-ex-fail ((- 10 20 2) 10 2100) (10 9 2100) (1 10 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (1 10 2099) (10 10 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 9 2100) (10 10 2100))

(unit-ex-fail ((- 10 20 2) 10 2100) (21 10 2100) (1 1 2101))
(unit-ex-fail ((- 10 20 2) 10 2100) (21 10 2100) (1 11 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 10 2100) (1 1 2101))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 10 2100) (1 11 2100))

(unit-ex-succ ((- 10 20 2) 10 2100) (31 12 2099) (1 1 2101))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 9 2100) (1 1 2101))
(unit-ex-succ ((- 10 20 2) 10 2100) (31 12 2099) (1 12 2100))
(unit-ex-succ ((- 10 20 2) 10 2100) (10 9 2100) (1 12 2100))

;;; wday

;;       September
;; Su Mo Tu We Th Fr Sa
;;           1  2  3  4
;;  5  6  7  8  9 10 11
;; 12 13 14 15 16 17 18
;; 19 20 21 22 23 24 25
;; 26 27 28 29 30

;; unit

(unit-ex-fail (fri 9 2100) (1 9 2100) (2 9 2100))
(unit-ex-succ (fri 9 2100) (1 9 2100) (3 9 2100))
(unit-ex-succ (fri 9 2100) (1 9 2100) (7 9 2100))
(unit-ex-fail (fri 9 2100) (3 9 2100) (4 9 2100))
(unit-ex-fail (fri 9 2100) (3 9 2100) (7 9 2100))
(unit-ex-fail (fri 9 2100) (4 9 2100) (7 9 2100))

; path
(unit-ex-fail (fri 9 2100) (31 12 2099) (1 9 2100))
(unit-ex-fail (fri 9 2100) (1 1 2100) (1 9 2100))
(unit-ex-succ (fri 9 2100) (31 12 2099) (3 9 2100))
(unit-ex-succ (fri 9 2100) (1 1 2100) (3 9 2100))

(unit-ex-fail (fri 9 2100) (30 9 2100) (1 1 2101))
(unit-ex-fail (fri 9 2100) (30 9 2100) (1 10 2100))
(unit-ex-succ (fri 9 2100) (23 9 2100) (1 1 2101))
(unit-ex-succ (fri 9 2100) (23 9 2100) (1 10 2100))

(unit-ex-succ (fri 9 2100) (31 12 2099) (1 10 2101))
(unit-ex-succ (fri 9 2100) (1 7 2100) (1 10 2101))
(unit-ex-succ (fri 9 2100) (31 12 2099) (1 10 2100))
(unit-ex-succ (fri 9 2100) (1 7 2100) (1 10 2100))

;; range

(unit-ex-fail ((- tue fri 2) 9 2100) (5 9 2100) (6 9 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (5 9 2100) (7 9 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (7 9 2100) (9 9 2100))
(unit-ex-fail ((- tue fri 2) 9 2100) (7 9 2100) (8 9 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (10 9 2100) (14 9 2100))

; path
(unit-ex-fail ((- tue fri 2) 9 2100) (31 12 2099) (1 9 2100))
(unit-ex-fail ((- tue fri 2) 9 2100) (1 7 2100) (1 9 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (31 12 2099) (3 9 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (1 7 2100) (3 9 2100))

(unit-ex-fail ((- tue fri 2) 9 2100) (30 9 2100) (1 1 2101))
(unit-ex-fail ((- tue fri 2) 9 2100) (30 9 2100) (1 10 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (29 9 2100) (1 1 2101))
(unit-ex-succ ((- tue fri 2) 9 2100) (29 9 2100) (1 10 2100))

(unit-ex-succ ((- tue fri 2) 9 2100) (31 12 2099) (1 1 2101))
(unit-ex-succ ((- tue fri 2) 9 2100) (1 8 2100) (1 1 2101))
(unit-ex-succ ((- tue fri 2) 9 2100) (31 12 2099) (1 10 2100))
(unit-ex-succ ((- tue fri 2) 9 2100) (1 8 2099) (1 10 2100))

;;; mon ; <- COMBAK

;; glob -- glob day

(unit-ex-fail (* * 2100) (1 1 2100) (1 1 2100))
(unit-ex-succ (* * 2100) (1 1 2100) (2 1 2100))

; path
(unit-ex-succ (* * 2100) (1 1 2099) (1 1 2100))
(unit-ex-succ (* * 2100) (1 1 2100) (1 1 2101))
(unit-ex-succ (* * 2100) (1 1 2099) (1 1 2101))

;; glob -- range day

(unit-ex-fail ((- 10 20 2) * 2100) (1 1 2100) (2 1 2100))
(unit-ex-fail ((- 10 20 2) * 2100) (10 1 2100) (11 1 2100))
(unit-ex-succ ((- 10 20 2) * 2100) (1 1 2100) (10 1 2100))

;; range -- unit day

(unit-ex-fail (10 (- 5 10 2) 2100) (1 1 2100) (2 1 2100))
(unit-ex-fail (10 (- 5 10 2) 2100) (1 5 2100) (2 5 2100))
(unit-ex-succ (10 (- 5 10 2) 2100) (9 5 2100) (10 5 2100))
(unit-ex-succ (10 (- 5 10 2) 2100) (30 5 2100) (10 7 2100))
(unit-ex-fail (10 (- 5 10 2) 2100) (30 5 2100) (9 7 2100))

; path

;; range -- glob day
;; range -- range day

;;; year

;; glob -- unit mon -- unit day
;; glob -- unit mon -- glob day
;; glob -- glob mon -- unit day
;; glob -- glob mon -- glob day

;; range -- unit mon -- unit day
;; range -- unit mon -- glob day
;; range -- unit mon -- range day
;; range -- glob mon -- unit day
;; range -- glob mon -- glob day
;; range -- glob mon -- range day
;; range -- range mon -- unit day
;; range -- range mon -- glob day
;; range -- range mon -- range day

;;;; Final Log

(unit-log-end)
