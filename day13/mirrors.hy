; Wyatt Geckle
;
; Advent of Code 2023 Day 13


(import hyrule [dec inc]
        sys [argv exit stderr])


(defn matrix-rotated-cw [matrix]
  "Returns a 90 degrees clockwise rotation of an input matrix."
  (setv rotated (lfor _ (range (len (get matrix 0))) []))
  (for [col-index (range (len (get matrix 0)))]
    (for [row (reversed matrix)]
      (.append (get rotated col-index)
               (get row col-index))))
  rotated)

(defn num-diff-elems [list-one list-two]
  "Returns the number of elements which differ between two lists."
  (len (list (filter (fn [elems] (!= (get elems 0) (get elems 1)))
                     (zip list-one list-two)))))

(defn mirror-score [pattern [smudges 0]]
  "Returns the mirror score of a pattern given its number of smudges."

  (defn horizontal-mirror-location [pattern curr-guess]
    "Returns the row index of a horizontal mirror, or -1 if one is not
    present.  Note that, if present, and given the use of zero-based
    indexing, the current guess of the row index of a mirror must be in
    integer range [1, len(pattern))"
    (cond
      (or (< curr-guess 1) (>= curr-guess (len pattern)))
        -1
      (<= curr-guess (// (len pattern) 2))
        (if (= (sum (map (fn [rows] (num-diff-elems (get rows 0)
                                                    (get rows 1)))
                         (zip (reversed (cut pattern curr-guess))
                              (cut pattern curr-guess (* curr-guess 2)))))
               smudges)
          curr-guess
          (horizontal-mirror-location pattern (inc curr-guess)))
      True
        (let [reflect-len (- (len pattern) curr-guess)]
          (if (= (sum (map (fn [rows] (num-diff-elems (get rows 0)
                                                      (get rows 1)))
                           (zip (reversed (cut pattern
                                               (- curr-guess reflect-len)
                                               curr-guess))
                                (cut pattern
                                     curr-guess
                                     (+ curr-guess reflect-len)))))
                 smudges)
            curr-guess
            (horizontal-mirror-location pattern (inc curr-guess))))))

  (let [horiz-mirror-idx (horizontal-mirror-location pattern 1)]
    (if (> horiz-mirror-idx 0)
      (* horiz-mirror-idx 100)
      (horizontal-mirror-location (matrix-rotated-cw pattern) 1))))


(cond
  (!= __name__ "__main__")
    None
  (< (len argv) 2)
    (do
      (stderr.write "Please provide the puzzle input file.\n")
      (exit 1))
  True
    (let [patterns (list (map (fn [line] (.split line "\n"))
                              (.split (cut (with [file (open (get argv 1) "r")]
                                             (.read file))
                                           -1)
                                      "\n\n")))]
      (print f"Part One: {(sum (map mirror-score patterns))}")
      (print f"Part Two: {(sum (map (fn [pattern] (mirror-score pattern
                                                                :smudges 1))
                                    patterns))}")))

