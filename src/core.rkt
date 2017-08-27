#lang racket

(provide core#io)

(require "init.rkt" "logger.rkt")

(define (core#io state)
  (if (null? state)
    (let ([state* (initialize)])
      (if (not (null? state*))
        (core#io state*)
        null))
    (transfer#io state)))

(define (transfer#io state)
  state)
