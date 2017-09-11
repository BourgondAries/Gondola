; ds - Data Structures

; This file contains the data structures
; used in the program in addition to the initialization
; function.

; The data structure most useful to us is one that captures all state. What's all the state then? First we need our window handle:

#lang racket

(provide (all-defined-out))

(require lens (for-syntax syntax/parse) "glfw/glfw.rkt")

(define-syntax (initial-data stx)
  (syntax-parse stx
    [(_ structure-name:id initializer-name:id ((~seq name:id initial:expr) ...))
     #'(begin
       (struct/lens structure-name (name ...) #:prefab)
       (define (initializer-name)
         (structure-name initial ...)))]))

(initial-data data initialize-data (time (current-inexact-milliseconds)
                                    w #f
                                    a #f
                                    s #f
                                    d #f
                                    up #f
                                    left #f
                                    down #f
                                    right #f
                                    space #f
                                    escape #f
                                    enter #f
                                    scenedata #f
                                    window (glfwCreateWindow 800 600 "Gondola" #f #f)))
