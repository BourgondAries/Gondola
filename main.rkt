#! /usr/bin/env racket
#lang racket

(require "src/core.rkt")

;; This module can later on use reloadable to allow hot-swapping of code

(let loop ([state null])
  (let ([result (core#io state)])
    (when (not (null? result))
      (loop result))))
