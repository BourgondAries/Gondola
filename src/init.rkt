; Define initial state of the program

#lang racket

(provide initialize)

(require "glfw/glfw.rkt")

(define (initialize)
  (glfwInit)
  (define window (glfwCreateWindow 800 600 "Gondola: The Webm: The Game: The Walking Simulator" #f #f))
  0)
