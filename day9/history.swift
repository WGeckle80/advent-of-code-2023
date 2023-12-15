// Wyatt Geckle
//
// Advent of Code 2023 Day 9


import Foundation
import SwiftGlibc


/// Returns an array of the first or last elements of the values array
/// and its difference subarrays.
///
/// - Parameters:
///   - values: The integer values of a history.
///   - first: Select either the first or last of a difference subarray
///            to add to the returned array.
/// - Returns: A list of the first or last values in the values array
///            and its difference subarrays.
func createDifferenceArray(values: [Int], first: Bool) -> [Int] {
    if values.reduce(true, {acc, elem in acc && elem == 0}) {
        return [0]
    }

    var diff: [Int] = []
    diff.reserveCapacity(values.count - 1)

    for i in 0...values.endIndex - 2 {
        diff.append(values[i + 1] - values[i])
    }

    let prependValue = if first {values[0]} else {values.last!}

    return [prependValue] + createDifferenceArray(values: diff, first: first)
}

/// Returns the next value in a line's history.
///
/// - Parameters:
///   - history: A line in the puzzle input file representing a history.
/// - Returns: The next value of the history.
func nextHistory(history: Substring) -> Int {
    let historyValues = history.split(separator: " ").map({(elem) in
        Int(elem)!
    })

    return createDifferenceArray(values: historyValues, first: false).reduce(0, +)
}

/// Returns the previous value in a line's history.
///
/// - Parameters:
///   - history: A line in the puzzle input file representing a history.
/// - Returns: The previous value of the history.
func previousHistory(history: Substring) -> Int {
    let historyValues = history.split(separator: " ").map({(elem) in
        Int(elem)!
    })

    let firstDiffs = createDifferenceArray(values: historyValues, first: true)

    var prevHist = 0

    for (i, diff) in firstDiffs.enumerated() {
        if i % 2 == 0 {
            prevHist += diff
        } else {
            prevHist -= diff
        }
    }

    return prevHist
}


let args = CommandLine.arguments

// If no file is provided as an argument, print error message and exit
// with usage error code.
if args.count == 1 {
    fputs("Please provide the puzzle input file.\n", stderr)
    exit(64)
}

// Attempt to read the provided argument file and print the answers for
// parts one and two.  Print error and exit with I/O error code if an
// error occurs.
let url = URL(fileURLWithPath: args[1])
do {
    let fileData = try Data(contentsOf: url)
    let fileString = String(data: fileData, encoding: .utf8)!
    let fileLines = fileString.split(separator: "\n")

    print("Part One: \(fileLines.map(nextHistory).reduce(0, +))")
    print("Part Two: \(fileLines.map(previousHistory).reduce(0, +))")
} catch {
    fputs("\(error)\n", stderr)
    exit(74)
}

