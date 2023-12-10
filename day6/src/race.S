# Wyatt Geckle
#
# Advent of Code 2023 Day 6


.section .text

.global __start
__start:
	move	$fp, $sp		# Get frame pointer.

	addiu	$sp, $sp, -20		# Initialize stack frame.

	lw	$t0, 0($fp)		# Load argc from the stack.

	li	$t1, 1			# Error if argc is 1.
	beq	$t0, $t1, .args_error

	li	$v0, 4005		# Open the file specified by the
	lw	$a0, 8($fp)		# command line argument in read
	li	$a1, 0			# only mode.
	syscall

	blt	$v0, $zero, .open_error	# Error if open returns -1.

	sw	$v0, -4($fp)		# Put file descriptor on stack.
	
	li	$t0, 0			# Set iteration number to 0.
.read_times:
	sw	$t0, 0($sp)		# Store iteraton number on stack.

	li	$t1, 2			# Get address times + iteration
	sll	$t0, $t0, $t1		# number.
	la	$a0, times
	add	$a0, $a0, $t0

	lw	$a1, -4($fp)		# Load file descriptor as second arg.

	jal	read_next_u32		# Read next u32 to times[i].

	lw	$t0, 0($sp)		# Get iteration number from stack
	addi	$t0, $t0, 1		# and add 1 to it.

	lw	$t1, num_races		# If iteration number < num_races,
	blt	$t0, $t1, .read_times	# continue loop.

	li	$t0, 0			# Set iteration number to 0.
.read_dists:
	sw	$t0, 0($sp)		# Store iteraton number on stack.

	li	$t1, 2			# Get address dists + iteration
	sll	$t0, $t0, $t1		# number.
	la	$a0, dists
	add	$a0, $a0, $t0

	lw	$a1, -4($fp)		# Load file descriptor as second arg.

	jal	read_next_u32		# Read next u32 to dists[i].

	lw	$t0, 0($sp)		# Get iteration number from stack
	addi	$t0, $t0, 1		# and add 1 to it.

	lw	$t1, num_races		# If iteration number < num_races,
	blt	$t0, $t1, .read_dists	# continue loop.

	la	$a0, part_one_text	# Print part one text to stdout.
	li	$a1, 1
	jal	print_str

	li	$a0, 1			# Set product of number of ways to 1.
	li	$t0, 0			# Set iteration number to 0.
.calc_product:
	sw	$a0, 4($sp)		# Store product on stack.
	sw	$t0, 0($sp)		# Store iteration number on stack.

	li	$t1, 2			# Shift iteration number by 4 to access
	sll	$t0, $t0, $t1		# memory items in offsets of 4.

	la	$t2, times		# Get times[iteration number] as first
	add	$t2, $t2, $t0		# parameter, and
	lw	$a0, 0($t2)		# dists[iteration number] as second
	la	$t2, dists		# parameter.
	add	$t2, $t2, $t0
	lw	$a3, 0($t2)

	li	$a2, 0			# Ensure record dist high 32 bits is 0.
	jal	ways_to_break_record	# Calc num ways for times[i], dists[i].

	lw	$t0, 0($sp)		# Load iteration number from stack.
	lw	$a0, 4($sp)		# Load product from stack.

	addi	$t0, $t0, 1		# Add 1 to iteration number.
	mul	$a0, $a0, $v1		# Multiply product by num ways.

	lw	$t1, num_races		# If iteration number < num_races,
	blt	$t0, $t1, .calc_product	# continue loop.

	jal	print_u32		# Print part one product to stdout.

	li	$a0, 10			# Print newline to stdout.
	jal	putchar

	la	$a0, part_two_text	# Print part two text to stdout.
	li	$a1, 1
	jal	print_str

	li	$v0, 4019		# Reset file cursor to beginning.
	lw	$a0, -4($fp)
	li	$a1, 0
	li	$a2, 0
	syscall

	move	$a1, $a0		# Get time of entire line.
	move	$a0, $sp
	jal	read_line_u64

	addi	$a0, $sp, 8		# Get distance of entire line.
	lw	$a1, -4($fp)
	jal	read_line_u64

	li	$v0, 4006		# Close the opened file.
	lw	$a0, -4($fp)
	syscall

	lw	$a0, 4($sp)		# Get ways to break record for all
	lw	$a2, 8($sp)		# of time and distance lines.
	lw	$a3, 12($sp)
	jal	ways_to_break_record

	move	$a0, $v1		# Print part two value to stdout.
	jal	print_u32

	li	$a0, 10			# Print newline to stdout.
	jal	putchar

	li	$a0, 0			# Program return success.
.exit:
	li	$v0, 4001		# Program exit.
	syscall

.args_error:
	la	$a0, args_err_text	# Print command line argument error
	li	$a1, 2                  # message to stderr.
	jal	print_str

	li	$a0, 64			# Program return usage error code.
	j	.exit

.open_error:
	la	$a0, open_err_text	# Print open error message to stderr.
	li	$a1, 2
	jal	print_str
	
	li	$a0, 72			# Program return osfile error code.
	j	.exit


.section .data

num_races: .word 4			# Hardcode number of races to 4
times: .space 16			# because there's no reason to handle
dists: .space 16			# more races in this case.

args_err_text: .asciz "Please provide the puzzle input file.\n"
open_err_text: .asciz "An error occurred reading the puzzle input file.\n"
part_one_text: .asciz "Part One: "
part_two_text: .asciz "Part Two: "

