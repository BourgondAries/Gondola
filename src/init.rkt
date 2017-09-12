; Define initial state of the program

#lang racket

(provide initialize)

(require lens threading "logger.rkt" "ds.rkt" "glfw/glfw.rkt" "util.rkt")

(define (initialize)
  (glfwInit)
  (~>
    data-null
    (lens-transform data-window-lens _ (lambda (x)
                                         (glfwCreateWindow 800 600 "Gondola" #f #f)))
    (lens-transform data-time-lens _ (lambda (x)
                                       (current-inexact-milliseconds)))
    (lens-effect data-window-lens _ (lambda (x)
                                      (glfwSetInputMode x GLFW_STICKY_KEYS 1)
                                      (glfwMakeContextCurrent x)))))
