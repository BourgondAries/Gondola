#lang racket

(provide core#io)

(require ffi/vector lens opengl opengl/util threading "ds.rkt" "glfw/glfw.rkt" "init.rkt" "logger.rkt" "util.rkt" (for-syntax racket/syntax syntax/parse))

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

(define (load-texture-to-load state)
  (if (and (not (null? (data-texture-to-load state)))
           (not (equal? (texture-name (data-active-texture state)) (data-texture-to-load state))))
    (~>
      (lens-transform data-active-texture-lens state
                      (lambda (x)
                        (when (not (null? (texture-identifier x)))
                          (glDeleteTextures 1 (u32vector (texture-identifier x))))
                        (texture (data-texture-to-load state) (load-texture (data-texture-to-load state)))))
      (lens-effect data-active-texture-lens _ (lambda (x)
                                                (let ([id (texture-identifier x)])
                                                  (glBindTexture GL_TEXTURE_2D id)))))
    state))

(define (check-if-new-tex state)
  (if (= (data-W state) 1)
    (~>
      (lens-set data-texture-to-load-lens state "scenes/initial/cliff_house.png"))
    state))

(define (transfer#io state)
  (cond
    [(= (glfwWindowShouldClose (data-window state)) 1) null]
    [(and (not (null? (data-ESCAPE state))) (= (data-ESCAPE state) 1)) null]
    [else (glfwPollEvents)
          (info state)
          (glClear (bitwise-ior GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
          (~>
            state
            (capture-key-states W A S D UP LEFT DOWN RIGHT SPACE ESCAPE ENTER)
            check-if-new-tex
            load-texture-to-load
            ((lambda (x)
               (glEnableVertexAttribArray 0)
               (glVertexAttribPointer 0 3 GL_FLOAT #f 0 0)
               (glDrawArrays GL_TRIANGLES 0 3)
               x))
            (lens-effect data-window-lens _ (lambda~> glfwSwapBuffers))
            limit-frames-per-second)]))
