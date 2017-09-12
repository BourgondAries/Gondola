#lang racket

(provide core#io)

(require lens opengl opengl/util threading "ds.rkt" "glfw/glfw.rkt" "init.rkt" "logger.rkt" "util.rkt" (for-syntax racket/syntax syntax/parse))

(define (core#io state)
  (if (null? state)
    (let ([state* (initialize)])
      (if (not (null? state*))
        (core#io state*)
        null))
    (transfer#io state)))

(define-syntax (capture-key-states stx)
  (syntax-parse stx
    [(_ state (~seq data:id glfw:id) ...)
     (with-syntax ([(glfw* ...) (for/list ([a (syntax-e #'(glfw ...))]) (format-id #'s "GLFW_KEY_~a" a))]
                   [(data* ...) (for/list ([a (syntax-e #'(data ...))]) (format-id #'s "data-~a-lens" a))])
       #'(~>
           state
           (lens-transform data* _ (lambda (x) (glfwGetKey (data-window state) glfw*))) ...))]))

(define (limit-frames-per-second state)
  (lens-transform data-time-lens state
                  (lambda (x)
                    (let* ([current (current-inexact-milliseconds)]
                           [difference (- current x)]
                           [margin (- frame-time-ms difference)])
                      (when (> margin 0)
                        (sleep (/ margin 1000)))
                      (current-inexact-milliseconds)))))

(define (transfer#io state)
  (cond
    [(= (glfwWindowShouldClose (data-window state)) 1) null]
    [(and (not (null? (data-escape state))) (= (data-escape state) 1)) null]
    [else (glfwPollEvents)
          (info state)
          (glClear GL_COLOR_BUFFER_BIT)
          (~>
            state
            ; TODO Macroize duplicates away
            (capture-key-states w W a A s S d D up UP left LEFT down DOWN right RIGHT space SPACE escape ESCAPE enter ENTER)
            (lens-effect data-window-lens _ (lambda (x)
                                              (glfwSwapBuffers x)))
            limit-frames-per-second)]))
