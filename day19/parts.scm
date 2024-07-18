;;;; Wyatt Geckle
;;;;
;;;; Advent of Code 2023 Day 19


(import (chicken io)
        (chicken irregex)
        (chicken port)
        (chicken process-context)
        (chicken read-syntax)
        (chicken string)
        srfi-1)


(define (workflow-name->str-expr workflow-name)
  "Transforms a workflow name into a valid Scheme expression consisting
  of true, false, or a call to another function."
  (cond ((equal? workflow-name "A") "#t")
        ((equal? workflow-name "R") "#f")
        (else (string-append "(" workflow-name " x m a s)"))))

(define (comparison->str-expr comparison)
  "Transforms a comparison from the input file in the format
  '${variable}${comparison}${value}' into a Scheme expression in the
  format '(${comparison} ${variable} ${value})'."
  (let ((subexprs-lt (string-split comparison "<"))
        (subexprs-gt (string-split comparison ">")))
    (if (> (length subexprs-lt) 1)
      (string-append "(< "
                     (first subexprs-lt)
                     " "
                     (second subexprs-lt)
                     ")")
      (string-append "(> "
                     (first subexprs-gt)
                     " "
                     (second subexprs-gt)
                     ")"))))

(define (workflow->cond-datum-pair workflow)
  "Alongside the workflow's name, returns a valid Scheme cond expression
  datum of a workflow in the puzzle input file."
  (let* ((workflow-split (string-split workflow "{}:,"))
         (name-datum (with-input-from-string (first workflow-split) read))
         (rules (reverse (cdr workflow-split)))
         (terminal (string-append "(else "
                                  (workflow-name->str-expr (first rules))
                                  ")")))
    (let loop ((cond-expression (list (with-input-from-string terminal read)))
               (conditional-rules (cdr rules)))
      (if (equal? conditional-rules '())
        (list name-datum (cons 'cond cond-expression))
        ;; For each rule except the last, add a list consisting of the
        ;; comparison and the destination workflow to the cond
        ;; expression.
        (let* ((result (first conditional-rules))
               (comparison (second conditional-rules))
               (sub-expr-str (string-append "("
                                            (comparison->str-expr comparison)
                                            " "
                                            (workflow-name->str-expr result)
                                            ")")))
          (loop (cons (with-input-from-string sub-expr-str read)
                      cond-expression)
                (cdr (cdr conditional-rules))))))))

(define (cond-datum->function-def function-name-datum cond-datum)
  "Returns a valid Scheme function definition datum wrapping a cond
  expression.  The function is named function-name-datum."
  (list 'define `(,function-name-datum x m a s) cond-datum))

(define (part->list part)
  "Returns a list consisting of the x, m, a, and s ratings of a part
  in the format '{x=${value}, m=${value}, a=${value}, s=${value}}'."
  (let* ((numbers (string-split part "xmas,="))
         (numbers-list (string-intersperse numbers " ")))
    (with-input-from-string numbers-list read)))


(let ((cmd-args (command-line-arguments))
      (stderr (current-error-port)))
  (if (< (length cmd-args) 1)
    (begin (write-line "Please provide the puzzle input file." stderr)
           (exit 1))
    (let* ((file-port (open-input-file (first cmd-args)))
           (file-contents (irregex-split "\n\n" (read-string #f file-port))))
      (close-input-port file-port)
      (let* ((workflows (string-split (first file-contents) "\n"))
             (workflow-cond-pairs (map workflow->cond-datum-pair workflows))
             (parts (string-split (second file-contents) "\n"))
             (part-lists (map part->list parts)))
        ;; For part one, convert each workflow into a function, evaluate
        ;; each part starting with the in function, and sum each of
        ;; the accepted parts' ratings.
        (map (lambda (pair) (eval (apply cond-datum->function-def pair)))
             workflow-cond-pairs)
        (print "Part One: " (apply + (map (lambda (lst) (apply + lst))
                                          (filter (lambda (lst)
                                                    (eval (cons 'in lst)))
                                                  part-lists))))
        ;; For part two, since eval evaluates expressions in the global
        ;; scope, globally redefine the workflows as datum lists, and
        ;; recurse through the conditional tree, summing all
        ;; combinations reported by the terminal accepting nodes.
        (map (lambda (pair)
               (eval (list 'define
                           (first pair)
                           (list 'quote (second pair)))))
             workflow-cond-pairs)
        (print "Part Two: "
               ;; Initially, per the prompt, consider all values of x,
               ;; m, a, and s in integer range [1, 4000].  Each min/max
               ;; value represents an inclusive range start/end.
               (let recurse ((curr-expr (cdr in))
                             (x-min 1)
                             (x-max 4000)
                             (m-min 1)
                             (m-max 4000)
                             (a-min 1)
                             (a-max 4000)
                             (s-min 1)
                             (s-max 4000))
                 (let ((test (first (first curr-expr)))
                       (result (second (first curr-expr))))
                   (if (equal? test 'else)
                     (cond ((equal? result #t)
                             (* (+ (- x-max x-min) 1)
                                (+ (- m-max m-min) 1)
                                (+ (- a-max a-min) 1)
                                (+ (- s-max s-min) 1)))
                           ((equal? result #f)
                             0)
                           (else
                             (recurse (cdr (eval (first result)))
                                      x-min
                                      x-max
                                      m-min
                                      m-max
                                      a-min
                                      a-max
                                      s-min
                                      s-max)))
                     (let* ((operator (first test))
                            (var-datum (second test))
                            (test-value (eval (third test)))
                            (new-x-min (if (and (equal? operator '>)
                                                (equal? var-datum 'x)
                                                (>= test-value x-min))
                                         (+ test-value 1)
                                         x-min))
                            (new-x-max (if (and (equal? operator '<)
                                                (equal? var-datum 'x)
                                                (<= test-value x-max))
                                         (- test-value 1)
                                         x-max))
                            (new-m-min (if (and (equal? operator '>)
                                                (equal? var-datum 'm)
                                                (>= test-value m-min))
                                         (+ test-value 1)
                                         m-min))
                            (new-m-max (if (and (equal? operator '<)
                                                (equal? var-datum 'm)
                                                (<= test-value m-max))
                                         (- test-value 1)
                                         m-max))
                            (new-a-min (if (and (equal? operator '>)
                                                (equal? var-datum 'a)
                                                (>= test-value a-min))
                                         (+ test-value 1)
                                         a-min))
                            (new-a-max (if (and (equal? operator '<)
                                                (equal? var-datum 'a)
                                                (<= test-value a-max))
                                         (- test-value 1)
                                         a-max))
                            (new-s-min (if (and (equal? operator '>)
                                                (equal? var-datum 's)
                                                (>= test-value s-min))
                                         (+ test-value 1)
                                         s-min))
                            (new-s-max (if (and (equal? operator '<)
                                                (equal? var-datum 's)
                                                (<= test-value s-max))
                                         (- test-value 1)
                                         s-max)))
                       (+ (cond ((equal? result #t)
                                  (* (+ (- new-x-max new-x-min) 1)
                                     (+ (- new-m-max new-m-min) 1)
                                     (+ (- new-a-max new-a-min) 1)
                                     (+ (- new-s-max new-s-min) 1)))
                                ((equal? result #f)
                                  0)
                                (else
                                  (recurse (cdr (eval (first result)))
                                           new-x-min
                                           new-x-max
                                           new-m-min
                                           new-m-max
                                           new-a-min
                                           new-a-max
                                           new-s-min
                                           new-s-max)))
                          ;; When recursing on the failed conditional
                          ;; path, ensure that the min and max values
                          ;; reflect proper inversion of the < and >
                          ;; comparisons.
                          (recurse (cdr curr-expr)
                                   (if (= x-max new-x-max)
                                     x-min
                                     test-value)
                                   (if (= x-min new-x-min)
                                     x-max
                                     test-value)
                                   (if (= m-max new-m-max)
                                     m-min
                                     test-value)
                                   (if (= m-min new-m-min)
                                     m-max
                                     test-value)
                                   (if (= a-max new-a-max)
                                     a-min
                                     test-value)
                                   (if (= a-min new-a-min)
                                     a-max
                                     test-value)
                                   (if (= s-max new-s-max)
                                     s-min
                                     test-value)
                                   (if (= s-min new-s-min)
                                     s-max
                                     test-value))))))))))))
