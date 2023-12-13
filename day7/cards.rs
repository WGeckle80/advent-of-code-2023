/* Wyatt Geckle
 *
 * Advent of Code 2023 Day 7
 */

use std::cmp::Ordering;
use std::collections::HashMap;
use std::env;
use std::fs::read_to_string;
use std::process::exit;

#[derive(Clone, Debug, PartialEq)]
enum CardType {
    Two = 0,
    Three = 1,
    Four = 2,
    Five = 3,
    Six = 4,
    Seven = 5,
    Eight = 6,
    Nine = 7,
    Ten = 8,
    Jack = 9,
    Queen = 10,
    King = 11,
    Ace = 12,
}

#[derive(Clone, Debug, PartialEq)]
enum HandType {
    HighCard = 0,
    OnePair = 1,
    TwoPair = 2,
    ThreeOfAKind = 3,
    FullHouse = 4,
    FourOfAKind = 5,
    FiveOfAKind = 6,
}

#[derive(Clone, Debug, PartialEq)]
enum JokerCardType {
    Joker = 0,
    Two = 1,
    Three = 2,
    Four = 3,
    Five = 4,
    Six = 5,
    Seven = 6,
    Eight = 7,
    Nine = 8,
    Ten = 9,
    Queen = 10,
    King = 11,
    Ace = 12,
}

/* Given a character, returns its card type. */
fn get_card_type(card: char) -> CardType {
    match card {
        '2' => CardType::Two,
        '3' => CardType::Three,
        '4' => CardType::Four,
        '5' => CardType::Five,
        '6' => CardType::Six,
        '7' => CardType::Seven,
        '8' => CardType::Eight,
        '9' => CardType::Nine,
        'T' => CardType::Ten,
        'J' => CardType::Jack,
        'Q' => CardType::Queen,
        'K' => CardType::King,
        'A' => CardType::Ace,
        _ => panic!("Unknown card."),
    }
}

/* Given a character, return its joker card type. */
fn get_joker_card_type(card: char) -> JokerCardType {
    match card {
        'J' => JokerCardType::Joker,
        '2' => JokerCardType::Two,
        '3' => JokerCardType::Three,
        '4' => JokerCardType::Four,
        '5' => JokerCardType::Five,
        '6' => JokerCardType::Six,
        '7' => JokerCardType::Seven,
        '8' => JokerCardType::Eight,
        '9' => JokerCardType::Nine,
        'T' => JokerCardType::Ten,
        'Q' => JokerCardType::Queen,
        'K' => JokerCardType::King,
        'A' => JokerCardType::Ace,
        _ => panic!("Unknown card."),
    }
}

/* Given a hand of five cards, return its hand type. */
fn get_hand_type(hand: &str) -> HandType {
    let mut hand_counts: Vec<u8> = vec![0; 13];
    let mut curr_hand_type = HandType::HighCard;

    for ch in hand.chars() {
        let card = get_card_type(ch);
        let card_idx = card as usize;

        hand_counts[card_idx] += 1;

        curr_hand_type = match hand_counts[card_idx] {
            1 => curr_hand_type,
            2 => {
                if curr_hand_type == HandType::ThreeOfAKind {
                    HandType::FullHouse
                } else if curr_hand_type == HandType::OnePair {
                    HandType::TwoPair
                } else {
                    HandType::OnePair
                }
            }
            3 => {
                if curr_hand_type == HandType::TwoPair {
                    HandType::FullHouse
                } else {
                    HandType::ThreeOfAKind
                }
            }
            4 => HandType::FourOfAKind,
            5 => HandType::FiveOfAKind,
            _ => panic!("Unknown card state."),
        };
    }

    curr_hand_type
}

/* Given a hand of five cards, return its hand type according to the
 * joker rules. */
fn get_joker_hand_type(hand: &str) -> HandType {
    let mut hand_counts: Vec<u8> = vec![0; 13];
    let mut curr_hand_type = HandType::HighCard;

    for ch in hand.chars() {
        let card = get_joker_card_type(ch);
        let card_idx = card as usize;

        hand_counts[card_idx] += 1;

        if card_idx != JokerCardType::Joker as usize {
            curr_hand_type = match hand_counts[card_idx] {
                1 => curr_hand_type,
                2 => {
                    if curr_hand_type == HandType::ThreeOfAKind {
                        HandType::FullHouse
                    } else if curr_hand_type == HandType::OnePair {
                        HandType::TwoPair
                    } else {
                        HandType::OnePair
                    }
                }
                3 => {
                    if curr_hand_type == HandType::TwoPair {
                        HandType::FullHouse
                    } else {
                        HandType::ThreeOfAKind
                    }
                }
                4 => HandType::FourOfAKind,
                5 => HandType::FiveOfAKind,
                _ => panic!("Unknown card state."),
            };
        }
    }

    curr_hand_type = match hand_counts[JokerCardType::Joker as usize] {
        0 => curr_hand_type,
        1 => match curr_hand_type {
            HandType::HighCard => HandType::OnePair,
            HandType::OnePair => HandType::ThreeOfAKind,
            HandType::TwoPair => HandType::FullHouse,
            HandType::ThreeOfAKind => HandType::FourOfAKind,
            HandType::FourOfAKind => HandType::FiveOfAKind,
            _ => panic!("Unknown card state."),
        },
        2 => match curr_hand_type {
            HandType::HighCard => HandType::ThreeOfAKind,
            HandType::OnePair => HandType::FourOfAKind,
            HandType::ThreeOfAKind => HandType::FiveOfAKind,
            _ => panic!("Unknown card state."),
        },
        3 => match curr_hand_type {
            HandType::HighCard => HandType::FourOfAKind,
            HandType::OnePair => HandType::FiveOfAKind,
            _ => panic!("Unknown card state."),
        },
        4 => HandType::FiveOfAKind,
        5 => HandType::FiveOfAKind,
        _ => panic!("Unknown card state."),
    };

    curr_hand_type
}

/* Compares two hands and returns an Ordering enum item. */
fn hand_compare(hand_a: &String, hand_b: &String) -> Ordering {
    let hand_weight_a = get_hand_type(hand_a) as u8;
    let hand_weight_b = get_hand_type(hand_b) as u8;

    if hand_weight_a < hand_weight_b {
        Ordering::Less
    } else if hand_weight_a > hand_weight_b {
        Ordering::Greater
    } else {
        let mut cards_a = hand_a.chars();
        let mut cards_b = hand_b.chars();

        for _ in 0..5 {
            let card_weight_a = get_card_type(cards_a.next().unwrap()) as u8;
            let card_weight_b = get_card_type(cards_b.next().unwrap()) as u8;

            if card_weight_a < card_weight_b {
                return Ordering::Less;
            } else if card_weight_a > card_weight_b {
                return Ordering::Greater;
            }
        }

        Ordering::Equal
    }
}

/* Compares two hands using joker rules and returns an Ordering enum
 * item. */
fn joker_hand_compare(hand_a: &String, hand_b: &String) -> Ordering {
    let hand_weight_a = get_joker_hand_type(hand_a) as u8;
    let hand_weight_b = get_joker_hand_type(hand_b) as u8;

    if hand_weight_a < hand_weight_b {
        Ordering::Less
    } else if hand_weight_a > hand_weight_b {
        Ordering::Greater
    } else {
        let mut cards_a = hand_a.chars();
        let mut cards_b = hand_b.chars();

        for _ in 0..5 {
            let card_weight_a = get_joker_card_type(cards_a
                                                    .next()
                                                    .unwrap()) as u8;
            let card_weight_b = get_joker_card_type(cards_b
                                                    .next()
                                                    .unwrap()) as u8;

            if card_weight_a < card_weight_b {
                return Ordering::Less;
            } else if card_weight_a > card_weight_b {
                return Ordering::Greater;
            }
        }

        Ordering::Equal
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() == 1 {
        eprintln!("Please provide the puzzle input file.");
        exit(64); // Return usage error code.
    }

    let file_lines: Vec<String> = read_to_string(args.get(1).unwrap())
        .unwrap()
        .lines()
        .map(String::from)
        .collect();
    let mut cards: Vec<String> = Vec::with_capacity(file_lines.len());
    let mut bids: HashMap<String, usize> = HashMap::new();

    for line in &file_lines {
        let split_line: Vec<&str> = line.split(' ').collect();
        cards.push(split_line[0].to_string());
        bids.insert(split_line[0].to_string(), split_line[1].parse().unwrap());
    }

    cards.sort_by(hand_compare);
    let mut winnings: usize = 0;
    for i in 0..file_lines.len() {
        winnings += (i + 1) * bids.get(&cards[i]).unwrap();
    }

    cards.sort_by(joker_hand_compare);
    let mut joker_winnings: usize = 0;
    for i in 0..file_lines.len() {
        joker_winnings += (i + 1) * bids.get(&cards[i]).unwrap();
    }

    println!("Part One: {}", winnings);
    println!("Part Two: {}", joker_winnings);
}
