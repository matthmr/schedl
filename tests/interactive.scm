;;;; Export interface

(define-module (interactive)
  #:export (unit unit-ex-fail unit-ex-succ
                 sched/int/unit
                 unit-log-end)
  #:declarative? #f)

;;;; Interactive schedl

(load "../schedl")

(define (sched/int/set-now day mon year . wday)
  (set! now/day day)
  (set! now/mon mon)
  (set! now/year year))

(define (sched/int/set-file day mon year . wday)
  (set! file/day day)
  (set! file/mon mon)
  (set! file/year year))

(define (sched/int/set-now/wday wday)
  (set! now/wday (sched/week->day wday)))

(define (sched/int/set-file/wday wday)
  (set! file/wday (sched/week->day wday)))

(define (sched/int/set . thing)
  (let ((set-now (memq #:now thing))
        (set-file (memq #:file thing)))
    (when set-now
      (let ((now (list-head (cdr set-now) 3)))
        (apply sched/int/set-now now)
        (set! now/wday
          (apply sched/time/wday-from-ts now))))
    (when set-file
      (let ((file (list-head (cdr set-file) 3)))
        (apply sched/int/set-file file)
        (set! file/wday
          (apply sched/time/wday-from-ts file))))))

;;;; Interactive functions

(define (sched/int/desc)
  (format #t "file: ~a\n"
          `(,file/day ,file/mon ,file/year . ,file/wday))
  (format #t "now: ~a\n"
          `(,now/day ,now/mon ,now/year . ,now/wday)))

(define-syntax sched/int/instance?
  (syntax-rules ()
    ((sched/int/instance? ts)
     (sched/ts/instance? (quote ts)))
    ))

;;;; Units

(define-syntax inc
  (syntax-rules ()
    ((inc n)
     (set! n (1+ n)))
    ))

(define units-done 0)
(define units-failed 0)

(define unit-succ-fmt
  "SUCCESS: expected ~a, got ~a\n")

(define unit-fail-fmt
  "FAIL: expected ~a, got ~a\n")

(define unit-log-end-fmt
  "\nDONE: [~a/~a] passed\n")

(define (unit-succ ts/unit ts/file ts/now expect)
  (format #t unit-succ-fmt
          expect expect ts/unit ts/file ts/now)
  (inc units-done))

(define (unit-fail ts/unit ts/file ts/now expect)
  (format #t unit-fail-fmt
          expect (not expect) ts/unit ts/file ts/now)
  (inc units-failed)
  (inc units-done))

(define (unit-log-end . exit?)
  (format #t unit-log-end-fmt
          (- units-done units-failed) units-done)
  (set! units-done 0)
  (set! units-failed 0)
  (if (and (not (null? exit?))
           (car exit?))
      (exit)))

(define-syntax unravel-ts
  (syntax-rules ()
    ((unravel-ts ts)
     (let ((ts* ts))
       (list (car ts*) (cadr ts*) (caddr ts*))
       ))
    ))

(define (sched/int/unit ts/unit ts/file ts/now expect)
  (apply sched/int/set-file (unravel-ts ts/file))
  (apply sched/int/set-now  (unravel-ts ts/now))
  (display "\n---\n")
  (let ((passed? (eq? (sched/ts/instance? ts/unit) expect)))
    (apply
     (if passed? unit-succ unit-fail)
     (list ts/unit ts/file ts/now expect))
    (format #t "  on ts/unit: ~a\n  on ts/file: ~a\n  on ts/now: ~a\n---\n" ts/unit
            (list file/day file/mon file/year)
            (list now/day now/mon now/year))
    ))

(define-syntax unit
  (syntax-rules ()
    ((unit ts/unit ts/file ts/now expect)
     (sched/int/unit 'ts/unit 'ts/file 'ts/now 'expect))
    ))

(define-syntax unit-ex-succ
  (syntax-rules ()
    ((unit-ex-succ ts/unit ts/file ts/now)
     (unit ts/unit ts/file ts/now #t))
    ))

(define-syntax unit-ex-fail
  (syntax-rules ()
    ((unit-ex-fail ts/unit ts/file ts/now)
     (unit ts/unit ts/file ts/now #f))
    ))

;; Similar to default init, but with color
(define (sched/int/use-unit)
  (set! unit-succ-fmt
        "\x1b[32mSUCCESS\x1b[0m: expected ~a, got ~a\n")

  (set! unit-fail-fmt
        "\x1b[31mFAIL\x1b[0m: expected ~a, got ~a\n")

  (set! unit-log-end-fmt
        "\n\x1b[33mDONE\x1b[0m: [~a/~a] passed\n"))
