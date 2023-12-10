# Wyatt Geckle
#
# MIPS string functions


.section .text

.global strlen
strlen:
	li	$v0, 0			# Initialize string length as 0.
.len_loop:
	lb	$t0, 0($a0)		# Load current character.

	beq	$t0, $zero, .len_end	# Return when curr char is null char.

	addi	$v0, $v0, 1		# Add 1 to length.
	addi	$a0, $a0, 1		# Point to next character.

	j	.len_loop		# Go to beginning of loop.
.len_end:
	jr	$ra			# Return string length.

