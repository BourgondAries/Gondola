#lang racket

(provide core#io)

(require lens threading "ds.rkt" "glfw/glfw.rkt" "init.rkt" "logger.rkt")

(define (core#io state)
  (if (null? state)
    (let ([state* (initialize)])
      (if (not (null? state*))
        (core#io state*)
        null))
    (transfer#io state)))

(define (transfer#io state)
  (cond
    [(= (glfwWindowShouldClose (data-window state)) 1) null]
    [else (glfwPollEvents)
          (lens-transform data-time-lens state
                          (lambda (x)
                            (info x)
                            (let* ([current (current-inexact-milliseconds)]
                                   [difference (- current x)]
                                   [margin (- 16.667 difference)])
                              (when (> margin 0)
                                (sleep (/ margin 1000)))
                              (current-inexact-milliseconds))))]))
