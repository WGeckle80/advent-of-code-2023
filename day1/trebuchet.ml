(* Wyatt Geckle
 *
 * Advent of Code 2023 Day 1
 *)


open Str


let readlines (file: in_channel) : string list =
    let rec aux curr =
        try
            let line = input_line file in
            aux (line :: curr)
        with e ->
            if e = End_of_file then
                curr
            else
                raise e in
    aux [] |> List.rev

let string_reverse (str: string) : string =
    str |> String.to_seq |> List.of_seq
    |> List.rev |> List.to_seq |> String.of_seq

let sum (lst: int list) : int =
    let rec aux lst curr =
        match lst with
        | [] -> curr
        | h :: t -> aux t (curr + h) in
    aux lst 0


let rec part_one_calibration_vals (line: string) : int =
    let is_digit character =
        match character with
        | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> true
        | _ -> false in

    let len = String.length line in

    if len = 0 then
        failwith "Invalid input"
    else
        let left_advance = if is_digit (String.sub line 0 1) then 0 else 1 in
        let right_advance = if is_digit
            (String.sub line (len - 1) 1) then 0 else 1 in

        if left_advance = 0 && right_advance = 0 then
            10*int_of_string (String.sub line 0 1)
            + int_of_string (String.sub line (len - 1) 1)
        else
            String.sub line left_advance (len - left_advance - right_advance)
            |> part_one_calibration_vals

let part_two_calibration_vals (line: string) : int =
    let get_digit str_num =
        match str_num with
        | "0" | "zero" -> 0
        | "1" | "one" -> 1
        | "2" | "two" -> 2
        | "3" | "three" -> 3
        | "4" | "four" -> 4
        | "5" | "five" -> 5
        | "6" | "six" -> 6
        | "7" | "seven" -> 7
        | "8" | "eight" -> 8
        | "9" | "nine" -> 9
        | _ -> 0 in

    let nums = {|[0-9]\|one\|two\|three\|four\|five|}
        ^ {|\|six\|seven\|eight\|nine|} in
    let rev_nums = {|[0-9]\|enin\|thgie\|neves\|xis|}
        ^ {|\|evif\|ruof\|eerht\|owt\|eno|} in
    let reversed_line = string_reverse line in

    try
        let _ = Str.search_forward (Str.regexp nums) line 0 in
        let tens = line |> Str.matched_string |> get_digit in

        let _ = Str.search_forward
            (Str.regexp rev_nums) reversed_line 0 in
        let ones = reversed_line |> Str.matched_string |> string_reverse
            |> get_digit in

        10*tens + ones
    with e ->
        failwith "Invalid input"


let () =
    if Array.length Sys.argv = 1 then
        Printf.eprintf "Please provide the puzzle input file.\n"
    else
        let file = open_in Sys.argv.(1) in
        let lines = readlines file in
        close_in file;

        let part_one_sum = List.map part_one_calibration_vals lines |> sum in
        Printf.printf "Part One: %d\n" part_one_sum;

        let part_two_sum = List.map part_two_calibration_vals lines |> sum in
        Printf.printf "Part Two: %d\n" part_two_sum

