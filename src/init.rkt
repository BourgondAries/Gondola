; Define initial state of the program

#lang racket

(provide initialize)

(require lens threading "ds.rkt" "glfw/glfw.rkt")

(define (lens-effect lens data proc)
  (lens-transform lens data proc)
  data)

(define (initialize)
  (glfwInit)
  (~>
    (initialize-data)
    (lens-effect data-window-lens _ (lambda (x) (glfwSetInputMode x GLFW_STICKY_KEYS 1)))))
