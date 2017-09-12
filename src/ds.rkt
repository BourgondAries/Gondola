; ds - Data Structures

; This file contains the data structures
; used in the program in addition to the initialization
; function.

; The data structure most useful to us is one that captures all state. What's all the state then? First we need our window handle:

#lang racket

(provide (all-defined-out))

(require lens (for-syntax syntax/parse) "util.rkt" "glfw/glfw.rkt")

(struct/lens gondola (t) #:prefab)

(skeltal data data-null (time
                         W A S D UP LEFT DOWN RIGHT SPACE ESCAPE ENTER
                         scenedata window))

(define frame-time-ms 1000/60)
