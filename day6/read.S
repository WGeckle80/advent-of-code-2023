# Wyatt Geckle
#
# MIPS file read functions
#
# MIPS Linux syscalls found at https://syscalls.w3challs.com/?arch=mips_o32
# Linux man pages found at https://www.man7.org/linux/man-pages/index.html
# Getting started guide at https://youtu.be/5AN4Fo0GiBI


.section .text

.global read_to_char
read_to_char:
	addi	$sp, $sp, -4		# Initialize stack frame.

	li	$t0, 0			# Initialize buffer chars to 0.
	beq	$a1, $t0, read_ret	# Return immediately if max count is 0.

	move	$t1, $a1		# Copy max count.
	addi	$t1, $t1, -1		# Limit chars read to max count - 1.

	move	$t2, $a3		# Copy target character.

	move	$a1, $a0		# Set output buffer of syscall.
	move	$a0, $a2		# Set file descriptor of syscall.
	li	$a2, 1			# Set read size to 1.

	beq	$a1, $zero, read_null	# Do null path if pointer is null.

	beq	$t1, $zero, read_end	# Put null in buf if max count is 1.
read_loop:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, read_panic	# Return immediately upon error.

	lb	$t3, 0($a1)		# Load character from string buffer.

	seq	$t4, $v0, $zero		# End loop if no characters were read
	seq	$t5, $t3, $t2		# or if character read was target char.
	or	$t4, $t5, $t4
	bne	$t5, $zero, read_end

	addi	$t0, $t0, 1		# Increment buffer chars.
	addi	$a1, $a1, 1		# Increment string buffer pointer.

	blt	$t0, $t1, read_loop	# Continue loop if chars read less than
					# max count - 1.
read_end:
	sw	$zero, 0($a1)		# Store string null terminator.
	j	read_ret		# Go to return.
read_null:
	move	$a1, $sp		# Chars write to stack if ptr is null.
null_loop:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, read_panic	# Return immediately upon error.

	lb	$t3, 0($sp)		# Load character from stack buffer.

	seq	$t4, $v0, $zero		# End loop if no characters were read
	seq	$t5, $t3, $t2		# or if character read was target char.
	or	$t4, $t5, $t4
	bne	$t5, $zero, read_ret

	addi	$t0, $t0, 1		# Increment non-target chars read.

	blt	$t0, $t1, null_loop	# Continue loop if chars read less than
					# max count - 1.
read_ret:
	move	$v0, $t0		# Return num characters in buffer.
read_panic:
	addi	$sp, $sp, 4		# Destroy stack frame.
	jr	$ra

