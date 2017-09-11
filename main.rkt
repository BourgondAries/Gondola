#! /usr/bin/env racket
#lang racket

(require reloadable)

;; This module allows hot-swapping of code

(define core (reloadable-entry-point->procedure
              (make-reloadable-entry-point 'core#io "src/core.rkt")))

(reload!)

(let loop ([state null])
  (let ([result (core state)])
    (when (not (null? result))
      (loop result))))
