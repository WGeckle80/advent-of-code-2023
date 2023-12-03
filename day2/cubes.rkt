#lang racket

#| Wyatt Geckle
 |
 | Advent of Code 2023 Day 2
 |#


#| Return the game id from a line. |#
(define (get-game-id game-line)
  (string->number (last (string-split
                          (first (string-split game-line ":"))))))

#| Checks validity of a game, meaning that no subset may contain
 | more than 12 reds, 13 greens, or 14 blues.
 |#
(define (is-valid-game? game-line)
  (define (get-game-subsets game-line)
    ; The fist element of the line split is "Game {id}".
    ; Thus, it is discarded.
    (rest (string-split game-line #rx": |; ")))

  (define (split-game-subset game-subset)
    (string-split game-subset ", "))

  (define (is-valid-cubes? cubes)
    ; The format of cubes is "{num} {color}".
    (letrec ([split-cubes (string-split cubes)]
             [num-cubes (string->number (first split-cubes))]
             [color (last split-cubes)])
      (cond
        [(equal? color "red") (<= num-cubes 12)]
        [(equal? color "green") (<= num-cubes 13)]
        [(equal? color "blue") (<= num-cubes 14)])))

  (define (is-valid-subset? split-subset)
    (if (empty? split-subset)
      #t
      (if (is-valid-cubes? (first split-subset))
        (is-valid-subset? (rest split-subset))
        #f)))

  (define (is-valid-subsets? game-subsets)
    (if (empty? game-subsets)
      #t
      (if (is-valid-subset? (split-game-subset (first game-subsets)))
        (is-valid-subsets? (rest game-subsets))
        #f)))

  (is-valid-subsets? (get-game-subsets game-line)))

#| Gets the power of a game, which is the multiplication of the
 | minimum number of red, green, and blue cubes to play a game.
 |#
(define (get-game-power game-line)
  (define (get-cubes-list game-line)
    ; The fist element of the line split is "Game {id}".
    ; Thus, it is discarded.
    (rest (string-split game-line #rx": |; |, ")))

  (define (min-cubes cubes-list red-cubes green-cubes blue-cubes)
    (if (empty? cubes-list)
      (list red-cubes green-cubes blue-cubes)
      (letrec ([split-cubes (string-split (first cubes-list))]
               [num-cubes (string->number (first split-cubes))]
               [color (last split-cubes)])
        (cond
          [(equal? color "red") (min-cubes
                                  (rest cubes-list)
                                  (max num-cubes red-cubes)
                                  green-cubes
                                  blue-cubes)]
          [(equal? color "green") (min-cubes
                                    (rest cubes-list)
                                    red-cubes
                                    (max num-cubes green-cubes)
                                    blue-cubes)]
          [(equal? color "blue") (min-cubes
                                   (rest cubes-list)
                                   red-cubes
                                   green-cubes
                                   (max num-cubes blue-cubes))]))))

  (apply * (min-cubes (get-cubes-list game-line) 0 0 0)))


(let ([cmd-args (current-command-line-arguments)]
      [stderr (current-error-port)])
  (if (< (vector-length cmd-args) 1)
    (fprintf stderr "Please provide the puzzle input file.\n")
    (printf
      "Part One: ~a\nPart Two: ~a\n"
      (apply
        +
        (map
          get-game-id
          (filter
            is-valid-game?
            (file->lines (vector-ref cmd-args 0)))))
      (apply
        +
        (map
          get-game-power
          (file->lines (vector-ref cmd-args 0)))))))

