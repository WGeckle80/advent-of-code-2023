# Wyatt Geckle
#
# Advent of Code 2023 Day 5
#
# MIPS Linux syscalls found at https://syscalls.w3challs.com/?arch=mips_o32
# Linux man pages found at https://www.man7.org/linux/man-pages/index.html
# Getting started guide at https://youtu.be/5AN4Fo0GiBI

.section .text

.global __start
__start:
	lw	$t0, 0($sp)		# Load argc from the stack.

	li	$t1, 1			# Error if argc is 1.
	beq	$t0, $t1, args_error

	li	$v0, 4005		# Open the file specified by the
	lw	$a0, 8($sp)		# command line argument in read
	li	$a1, 0			# only mode.
	syscall

	blt	$v0, $zero, open_error	# Error if open returns -1.

	addi	$sp, $sp, -24		# Push file descriptor to stack.
	sw	$v0, 20($sp)

	li	$a0, 0			# Read a single character from
	li	$a1, 5			# the opened file.
	move	$a2, $v0
	li	$a3, '3'
	jal	read_to_char

	move	$a0, $v0		# Print number of chars read.
	jal	print_i32

	lw	$t0, 20($sp)		# Get file descriptor from stack.

	move	$a0, $sp		# Read a single character from
	li	$a1, 5			# the opened file.
	move	$a2, $t0
	li	$a3, '\n'
	jal	read_to_char

	move	$a0, $v0		# Print number of chars read.
	jal	print_i32

	move	$a0, $sp		# Print string from file.
	li	$a1, 1
	jal	print_str

	lw	$a0, 20($sp)		# Get file descriptor from stack.

	addi	$sp, $sp, 24		# Pop items from stack.

	li	$v0, 4006		# Close the opened file.
	syscall

	li	$a0, '\n'		# Print newline.
	jal	putchar

	li	$a0, 0			# Program return success.
exit:
	li	$v0, 4001		# Program exit.
	syscall

args_error:
	la	$a0, args_err_text	# Print command line argument error
	li	$a1, 2                  # message to stderr.
	jal	print_str

	li	$a0, 64			# Program return usage error code.
	j exit

open_error:
	la	$a0, open_err_text	# Print open error message to stderr.
	li	$a1, 2
	jal	print_str
	
	li	$a0, 64			# Program return usage error code.
	j exit


.section .data

args_err_text: .asciz "Please provide the puzzle input file.\n"
open_err_text: .asciz "An error occurred reading the puzzle input file.\n"

