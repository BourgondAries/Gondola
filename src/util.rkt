#lang racket

(provide skeltal lens-effect)

(require lens (for-syntax racket/list syntax/parse))

;; Take a value and apply a side-effect without changing the value
(define (lens-effect lens data proc)
  (lens-transform lens data proc)
  data)

;; Create a struct with an initial value with everything null
(define-syntax (skeltal stx)
  (syntax-parse stx
    [(_ structure-name:id initializer-name:id (name:id ...))
     (with-syntax ([(nulls ...) (make-list (length (syntax-e #'(name ...))) 'null)])
       #'(begin
         (struct/lens structure-name (name ...) #:prefab)
         (define initializer-name (structure-name nulls ...))))]))
