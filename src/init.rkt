; Define initial state of the program

#lang racket

(provide initialize)

(require lens threading rsound ffi/vector opengl opengl/util "logger.rkt" "ds.rkt" "glfw/glfw.rkt" "util.rkt")

(define (initialize)
  (glfwInit)
  (~>
    data-null
    (lens-transform data-time-lens _ (lambda _
                                       (current-inexact-milliseconds)))
    (lens-transform data-window-lens _ (lambda _
                                         (glfwCreateWindow 800 600 "Gondola" #f #f)))
    (lens-set data-active-texture-lens _ texture-null)
    (lens-effect data-window-lens _ (lambda (x)
                                      (glfwSetInputMode x GLFW_STICKY_KEYS 1)
                                      (glfwMakeContextCurrent x)))
    (lens-set data-shader-vertex-lens _ (load-shader "src/vertex.glsl" GL_VERTEX_SHADER))
    (lens-set data-shader-fragment-lens _ (load-shader "src/fragment.glsl" GL_FRAGMENT_SHADER))
    ((lambda (x)
       (lens-set data-shader-program-lens x (create-program (data-shader-vertex x)
                                                       (data-shader-fragment x)))))
    (lens-effect data-shader-program-lens _ (lambda~> glUseProgram))
    (lens-set data-texture-vertices-lens _ (f32vector -0.5  0.5 0.0 0.0
                                                       0.5  0.5 1.0 0.0
                                                       0.5 -0.5 1.0 1.0
                                                      -0.5 -0.5 0.0 1.0))
    (lens-set data-triangle-lens _ (f32vector -1.0 -1.0 0.0
                                               1.0 -1.0 0.0
                                               0.0 1.0 0.0))

    (lens-set data-vao-lens _ (glGenVertexArrays 1))
    (lens-effect data-vao-lens _ (lambda (x) (glBindVertexArray (first (u32vector->list x)))))

    (lens-set data-vbo-lens _ (glGenBuffers 1))
    (lens-effect data-vbo-lens _ (lambda (x) (glBindBuffer GL_ARRAY_BUFFER (first (u32vector->list x)))))

    (lens-effect data-triangle-lens _ (lambda (x) (glBufferData GL_ARRAY_BUFFER (* float32-size (f32vector-length x)) x GL_STATIC_DRAW)))
    (lens-set data-gondola-lens _ (gondola 0 0 0 0))
    ((lambda (x) (glEnableVertexAttribArray 0) x))
    ((lambda (x) (play (rs-read "scenes/initial/housemusicpart1.wav")) x))
    ))
