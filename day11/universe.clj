;; Wyatt Geckle
;;
;; Advent of Code 2023 Day 11


(use '[clojure.string :only (split)])


(defn vec-new [size init-val]
  "Returns a new vector of specified size filled with init-val."
  (vec (repeat size init-val)))

(defn matrix-rotated-ccw [matrix]
  "Returns a 90 degrees counter-clockwise rotation of an input matrix."
  ;; For each column in the input matrix, make a list of its elements,
  ;; and append it to the accumulator matrix in reverse order.
  (loop [accum []
         col-idx (dec (count (first matrix)))]
    (if (< col-idx 0)
      accum
      (recur (conj accum (mapv (fn [row] (get row col-idx)) matrix))
             (dec col-idx)))))

(defn matrix-rotated-cw [matrix]
  "Returns a 90 degrees clockwise rotation of an input matrix."
  ;; For each column in the input matrix, make a list of its elements,
  ;; reverse the list, and append it to the accumulator matrix.
  (loop [accum []
         col-idx 0]
    (if (>= col-idx (count (first matrix)))
      accum
      (recur (conj accum
                   (vec (reverse (map (fn [row] (get row col-idx)) matrix))))
             (inc col-idx)))))

(defn expanded-universe [universe-matrix]
  "Given a universe character matrix, returns it with empty rows
  expanded."
  (let [widen-empty-rows #(reduce (fn [accum row] (if (.contains row \#)
                                                    (conj accum row)
                                                    (conj accum row row)))
                                  []
                                  %)]
    (widen-empty-rows
      (matrix-rotated-ccw
        (widen-empty-rows
          (matrix-rotated-cw universe-matrix))))))

(defn marked-universe [universe-matrix]
  "Given a universe character matrix, returns it with empty rows marked
  with '%'."
  (let [marked-row (vec-new (count (first universe-matrix)) \%)
        mark-empty-rows #(reduce (fn [accum row] (if (.contains row \#)
                                                   (conj accum row)
                                                   (conj accum marked-row)))
                                 []
                                 %)]
    (mark-empty-rows
      (matrix-rotated-ccw
        (mark-empty-rows
          (matrix-rotated-cw universe-matrix))))))

(defn galaxy-coordinates
  "Given a universe character matrix, returns the coordinates of
  galaxies.  If the argument is given, empty gaps denoted by '%'
  have a variable length"
  ([universe]
    ;; If no empty gap length is given, loop through the matrix and
    ;; accumulate the coordinates of galaxies into a list.
    (loop [accum ()
           row-idx 0]
      (if (>= row-idx (count universe))
        accum
        (recur (loop [accum accum
                      col-idx 0]
                 (if (>= col-idx (count (first universe)))
                   accum
                   (recur (if (= (get (get universe row-idx) col-idx) \#)
                            (conj accum [row-idx col-idx])
                            accum)
                          (inc col-idx))))
               (inc row-idx)))))
  ([universe empty-len]
    ;; If an empty gap length is given, loop through the rows.  If a
    ;; row is an empty row as denoted by being full of '%', offset
    ;; the current universe row.  If not, loop through the current
    ;; row, accumulating the galaxy coordinates and offsetting
    ;; the universe column appropriately.
    (let [empty-row (vec-new (count (first universe)) \%)]
      (loop [accum ()
             row-idx 0
             uni-row 0]
        (cond
          (>= row-idx (count universe)) accum
          (= (get universe row-idx) empty-row) (recur accum
                                                      (inc row-idx)
                                                      (+ uni-row empty-len))
          :else (recur (loop [accum accum
                              col-idx 0
                              uni-col 0]
                         (if (>= col-idx (count (first universe)))
                           accum
                           (let [curr (get (get universe row-idx) col-idx)]
                             (cond
                               (= curr \#) (recur (conj accum
                                                        [uni-row uni-col])
                                                  (inc col-idx)
                                                  (inc uni-col))
                               (= curr \%) (recur accum
                                                  (inc col-idx)
                                                  (+ uni-col empty-len))
                               :else (recur accum
                                            (inc col-idx)
                                            (inc uni-col))))))
                       (inc row-idx)
                       (inc uni-row)))))))

(defn distances-from-reference [points reference]
  "Calculates the shortest distances of points from a reference point."
  (map
    #(+ (Math/abs (- (first %) (first reference)))
        (Math/abs (- (last %) (last reference))))
    points))

(defn sum-of-galaxy-distances [points]
  "Calculates the sum of shortest distance pairs using the given
  points."
  ;; The sum of shortest distance pairs is the same as half of the sum
  ;; of all shortest distances from each point.
  (/ (apply + (map #(apply + (distances-from-reference points %))
                   points))
     2))


(if (nil? *command-line-args*)
  (binding [*out* *err*]
    (println "Please provide the puzzle input file."))
  (let [universe (mapv vec (split (slurp (first *command-line-args*)) #"\n"))
        expanded-coordinates (galaxy-coordinates (expanded-universe universe))
        marked-coordinates (galaxy-coordinates (marked-universe universe)
                                               1000000)]
    (printf "Part One: %d\n" (sum-of-galaxy-distances expanded-coordinates))
    (printf "Part Two: %d\n" (sum-of-galaxy-distances marked-coordinates))))

