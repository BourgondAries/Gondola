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
    [(_ state (~seq data:id) ...)
     (with-syntax ([(glfw* ...) (for/list ([a (syntax-e #'(data ...))]) (format-id #'s "GLFW_KEY_~a" a))]
                   [(data* ...) (for/list ([a (syntax-e #'(data ...))]) (format-id #'s "data-~a-lens" a))])
       #'(let ([state* state]) ; To avoid multiple evaluations of state
           (~>
             state*
             (lens-transform data* _ (lambda (x) (glfwGetKey (data-window state*) glfw*))) ...)))]))

(define (limit-frames-per-second state)
  (lens-transform data-time-lens state
                  (lambda (x)
                    (let* ([current (current-inexact-milliseconds)]
                           [difference (- current x)]
                           [margin (- frame-time-ms difference)])
                      (when (> margin 0)
                        (sleep (/ margin 1000)))
                      (current-inexact-milliseconds)))))

(define (load-new-texture state)
  (info (data-new-texture state))
  (if (not (null? (data-new-texture state)))
    (~>
      (lens-transform data-scenedata-lens state (lambda _ (load-texture (data-new-texture state))))
      (lens-set data-new-texture-lens _ null))
    state))

(define (check-if-new-tex state)
  (if (= (data-W state) 1)
    (~>
      (lens-set data-new-texture-lens state "scenes/initial/cliff_house.png")
      (lens-set data-W-lens _ 0))
    state))

(define (transfer#io state)
  (cond
    [(= (glfwWindowShouldClose (data-window state)) 1) null]
    [(and (not (null? (data-ESCAPE state))) (= (data-ESCAPE state) 1)) null]
    [else (glfwPollEvents)
          (info state)
          (glClear GL_COLOR_BUFFER_BIT)
          (~>
            state
            (capture-key-states W A S D UP LEFT DOWN RIGHT SPACE ESCAPE ENTER)
            check-if-new-tex
            load-new-texture
            (lens-effect data-window-lens _ (lambda~> glfwSwapBuffers))
            limit-frames-per-second)]))
