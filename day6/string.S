# Wyatt Geckle
#
# MIPS string functions
#
# MIPS Linux syscalls found at https://syscalls.w3challs.com/?arch=mips_o32
# Linux man pages found at https://www.man7.org/linux/man-pages/index.html
# Getting started guide at https://youtu.be/5AN4Fo0GiBI


.section .text

.global strlen
strlen:
	li	$v0, 0			# Initialize string length as 0.
len_loop:
	lb	$t0, 0($a0)		# Load current character.

	beq	$t0, $zero, len_end	# Return when curr char is null char.

	addi	$v0, $v0, 1		# Add 1 to length.
	addi	$a0, $a0, 1		# Point to next character.

	j	len_loop		# Go to beginning of loop.
len_end:
	jr	$ra			# Return string length.


.global str_to_u32
str_to_u32:
	# Assumes that input represents a valid unsigned 32-bit integer.

	li	$t0, 1			# Initialize multiplier as 1.

	lb	$t0, 0($a0)		# Load current character.

	beq	$t0, $zero, len_end	# Return when curr char is null char.

