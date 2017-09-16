; ds - Data Structures

; This file contains the data structures used throughout the program.
; Various constants will also be defined here.

#lang racket

(provide (all-defined-out))

(require "util.rkt")

;; Constants
(define frame-time-ms 1000/60)
(define float32-size 4)

;; Structures
(skeltal data data-null (time
                         W A S D UP LEFT DOWN RIGHT SPACE ESCAPE ENTER
                         texture-to-load active-texture window
                         shader-vertex shader-fragment shader-program
                         texture-vertices vao vbo triangle gondola))

(skeltal gondola gondola-null (t x y z))

(skeltal texture texture-null (name identifier))
