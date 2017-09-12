; ds - Data Structures

; This file contains the data structures used throughout the program.
; Various constants will also be defined here.

#lang racket

(provide (all-defined-out))

(require "util.rkt")

;; Constants
(define frame-time-ms 1000/60)

;; Structures
(skeltal data data-null (time
                         W A S D UP LEFT DOWN RIGHT SPACE ESCAPE ENTER
                         new-texture scenedata window))

(skeltal gondola gondola-null (t x y z))

