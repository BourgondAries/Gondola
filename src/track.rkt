#! /usr/bin/env racket
#lang racket

(provide track-position)

;; A track is a list of (t x y z) coordinates sorted by t.
;; The height is found by interpolating the two nearest
;; points
(define example-track '((0 0 1 0) (1 2 3 0) (2 8 -1 1)))

(define (find-surrounding-points track t)
  (let ([l (findf (lambda (p) (< (first p) t)) (reverse track))]
        [r (findf (lambda (p) (>= (first p) t)) track)])
    (values l r)))

(define (interpolate l r t)
  (let* ([dt (- (first r) (first l))]
         [dx/dt (/ (- (second r) (second l)) dt)]
         [dy/dt (/ (- (third r) (third l)) dt)]
         [dz/dt (/ (- (fourth r) (fourth l)) dt)])
    (list
      (+ (second l) (* dx/dt (- t (first l))))
      (+ (third l) (* dy/dt (- t (first l))))
      (+ (fourth l) (* dz/dt (- t (first l)))))))

(define (track-position track t)
  (if (empty? track)
    '(0 0 0)
    (let-values ([(l r) (find-surrounding-points track t)])
      (cond
        ([and (false? l) (false? r)] '(0 0 0))
        ([false? l] (second r))
        ([false? r] (second l))
        (else (interpolate l r t))))))

; (track-position example-track 1.5)
