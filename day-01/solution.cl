#!/usr/bin/env -S sbcl --script
(require "asdf")
(asdf:load-system :uiop)

(defparameter *input* (uiop:read-file-lines "input.txt"))

; First half solution
(loop for line in *input*
      for partial-sum = 0 then
        (setf partial-sum
          (if (= (length line) 0)
            0
            (+ partial-sum (parse-integer line))))
      maximize partial-sum into result
      finally (format t "First half: ~a~%" result))

; Second half solution
(let* (
   (sums (loop for line in *input*
      for partial-sum = 0 then
        (setf partial-sum
          (if (= (length line) 0)
            0
            (+ partial-sum (parse-integer line))))
      collect partial-sum))
  (top3 (subseq (sort sums '>) 0 3)))
  (format t "Second half: ~a~%" (loop for x in top3 sum x)))


