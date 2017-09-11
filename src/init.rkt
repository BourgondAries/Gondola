; Define initial state of the program

#lang racket

(provide initialize)

(require "ds.rkt" "glfw/glfw.rkt")

(define (initialize)
  (glfwInit)
  (initialize-data))
