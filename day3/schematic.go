/* Wyatt Geckle
 *
 * Advent of Code 2023 Day 3
 */

package main

import (
	"fmt"
	"os"
	"strconv"
	"unicode"
)

// Given the schematic and an index of a digit, recovers the full positive integer.
// Returns the number, its starting index, and the index after its last digit.
// Returns -1 for start and end index if the given index does not map to a digit.
func completeInt(schem string, idx int) (int, int, int) {
	if idx < 0 || idx >= len(schem) || !unicode.IsDigit(rune(schem[idx])) {
		return 0, -1, -1
	}

	start := idx
	end := idx + 1

	for start > 0 && unicode.IsDigit(rune(schem[start-1])) {
		start--
	}

	for end < len(schem) && unicode.IsDigit(rune(schem[end])) {
		end++
	}

	num, err := strconv.Atoi(schem[start:end])
	if err != nil {
		return 0, -1, -1
	}

	return num, start, end
}

// Given the schematic and a starting index, finds the next positive integer.
// Returns the starting index and length of the number.
func findNextInt(schem string, start int) (int, int) {
	for start < len(schem) && !unicode.IsDigit(rune(schem[start])) {
		start++
	}

	numLen := 0

	for start+numLen < len(schem) && unicode.IsDigit(rune(schem[start+numLen])) {
		numLen++
	}

	return start, numLen
}

// Given the schematic and a starting index, finds the next asterisk.
// Returns the index which maps to the asterisk.
func findNextStar(schem string, start int) int {
	for start < len(schem) && schem[start] != '*' {
		start++
	}

	return start
}

// Given a byte, returns whether it's a symbol according to this problem.
func isSymbol(character byte) bool {
	return !unicode.IsDigit(rune(character)) && character != '.' && character != '\n'
}

// Given the schematic, return its rectangular length.
func schematicLength(schem string) int {
	length := 0

	for schem[length] != '\n' {
		length++
	}

	return length
}

// Given the schematic, return the sum of the gear ratios.
func sumGearRatios(schem string) int {
	sum := 0
	start := 0
	schemLen := schematicLength(schem)

	for {
		start = findNextStar(schem, start)

		if start == len(schem) {
			break
		}

		numAdjNums := 0
		currRatio := 1

		// Search for a potential number to the left of the asterisk.
		adjNum, adjStart, adjEnd := completeInt(schem, start-1)
		if adjStart != -1 {
			numAdjNums++
			currRatio *= adjNum
		}

		// Search for a potential number to the right of the asterisk.
		adjNum, adjStart, adjEnd = completeInt(schem, start+1)
		if adjStart != -1 {
			numAdjNums++
			currRatio *= adjNum
		}

		// Search for potential numbers from the top left of the asterisk
		// to the top right.
		//
		// If the top left is part of a number, then the top middle either
		// can't be a number or is part of the top left number.  The top
		// right is only part of a new number if the top middle is not
		// part of one.
		adjNum, adjStart, adjEnd = completeInt(schem, start-schemLen-2)
		if adjStart != -1 {
			numAdjNums++
			currRatio *= adjNum
		} else {
			adjNum, adjStart, adjEnd = completeInt(schem, start-schemLen-1)

			if adjStart != -1 {
				numAdjNums++
				currRatio *= adjNum
			}
		}
		if start-schemLen-1 >= adjEnd {
			adjNum, adjStart, adjEnd = completeInt(schem, start-schemLen)

			if adjStart != -1 {
				numAdjNums++
				currRatio *= adjNum
			}
		}

		// Search for potential numbers from the bottom left of the asterisk
		// to the bottom right.
		//
		// If the bottom left is part of a number, then the bottom middle either
		// can't be a number or is part of the bottom left number.  The bottom
		// right is only part of a new number if the bottom middle is not
		// part of one.
		adjNum, adjStart, adjEnd = completeInt(schem, start+schemLen)
		if adjStart != -1 {
			numAdjNums++
			currRatio *= adjNum
		} else {
			adjNum, adjStart, adjEnd = completeInt(schem, start+schemLen+1)

			if adjStart != -1 {
				numAdjNums++
				currRatio *= adjNum
			}
		}
		if start+schemLen+1 >= adjEnd {
			adjNum, adjStart, adjEnd = completeInt(schem, start+schemLen+2)

			if adjStart != -1 {
				numAdjNums++
				currRatio *= adjNum
			}
		}

		if numAdjNums == 2 {
			sum += currRatio
		}

		start++
	}

	return sum
}

// Given the schematic, return the sum of the part numbers.
func sumPartNumbers(schem string) int {
	sum := 0
	start := 0
	numLen := 0
	schemLen := schematicLength(schem)

	for {
		start, numLen = findNextInt(schem, start)

		if numLen == 0 {
			break
		}

		found := false
		partNum, err := strconv.Atoi(schem[start : start+numLen])
		if err != nil {
			return 0
		}

		// Search for a potential symbol to left of number.
		if start != 0 && isSymbol(schem[start-1]) {
			found = true
			sum += partNum
		}

		// Search for a potential symbol to right of number.
		if !found && start+numLen < len(schem) && isSymbol(schem[start+numLen]) {
			found = true
			sum += partNum
		}

		// Search for potential symbols from top left corner to top right corner.
		if !found {
			for i := start - schemLen - 2; i < start-schemLen+numLen; i++ {
				if i >= 0 && isSymbol(schem[i]) {
					found = true
					sum += partNum
					break
				}
			}
		}

		// Search for potential symbols from bottom left corner to bottom right corner.
		if !found {
			for i := start + schemLen; i <= start+schemLen+numLen+1; i++ {
				if i < len(schem) && isSymbol(schem[i]) {
					sum += partNum
					break
				}
			}
		}

		start += numLen
	}

	return sum
}

func main() {
	if len(os.Args) == 1 {
		fmt.Fprintf(os.Stderr, "Please provide the puzzle input file.\n")
		os.Exit(64) // Return usage error code.
	}

	schem, err := os.ReadFile(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(74) // Return I/O error code.
	}

	schem_string := string(schem)

	fmt.Printf("Part One: %d\n", sumPartNumbers(schem_string))
	fmt.Printf("Part Two: %d\n", sumGearRatios(schem_string))
}
