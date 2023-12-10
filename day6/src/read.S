# Wyatt Geckle
#
# MIPS file read functions


.section .text

.global read_line_u64
read_line_u64:
	addi	$sp, $sp, -4		# Initialize stack frame.

	move	$t0, $a0		# Copy destination pointer.

	li	$t4, '0'		# Load characters '0' and '9'
	li	$t5, '9'		# for comparisons.
	li	$t6, 10			# Load 10 for multiplication.

	move	$a0, $a1		# Set file descriptor of syscall.
	move	$a1, $sp		# Set output of syscall to stack.
	li	$a2, 1			# Set read size to 1.

	li	$t1, 0			# Initial return is 0.
	li	$t2, 0
.build_int:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, .panic_line	# Return upon error.

	lb	$t3, 0($a1)		# Load character from stack buffer.

	seq	$t7, $v0, $zero		# If reached EOF or the current
	seq	$t8, $t3, $t6		# character is a newline,
	or	$t7, $t7, $t8		# end the loop.
	bne	$t7, $zero, .store_line

	slt	$t7, $t3, $t4		# If the current character is not
	sgt	$t8, $t3, $t5		# a digit, continue.
	or	$t7, $t7, $t8
	bne	$t7, $zero, .build_int

	mul	$t2, $t6		# Multiply result low 32 bits by 10.
	mflo	$t2			# Set low 32 bits to that of product.
	mfhi	$t7			# Save high 32 bits of product.
	mul	$t1, $t1, $t6		# Multiply result high 32 bits by 10.
	add	$t1, $t1, $t7		# Add high 32 bits of low 32 bits
					# product to result high 32 bits.
	sub	$t3, $t3, $t4		# Add integer value of next character
	addu	$t2, $t2, $t3		# to result low 32 bits.

	j	.build_int
.store_line:
	beq	$t0, $zero, .panic_line	# Return if input buffer is null.

	sw	$t2, 4($t0)		# Store low 32 bits higher on stack.
	sw	$t1, 0($t0)		# Store high 32 bits lower on stack.
.panic_line:
	addi	$sp, $sp, 4		# Destroy stack frame.
	jr	$ra


.global read_next_u32
read_next_u32:
	addi	$sp, $sp, -4		# Initialize stack frame.

	move	$t0, $a0		# Copy destination pointer.

	li	$t3, '0'		# Load characters '0' and '9'
	li	$t4, '9'		# for comparisons.
	li	$t5, 10			# Load 10 for multiplication.

	move	$a0, $a1		# Set file descriptor of syscall.
	move	$a1, $sp		# Set output of syscall to stack.
	li	$a2, 1			# Set read size to 1.
.first_dig:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	ble	$v0, $zero, .panic_u32	# Return upon error or EOF.

	lb	$t2, 0($a1)		# Load character from stack buffer.

	sle	$t6, $t3, $t2		# If the read character is not a
	sle	$t7, $t2, $t4		# digit, continue the loop.
	and	$t6, $t6, $t7
	beq	$t6, $zero, .first_dig

	sub	$t1, $t2, $t3		# Initial return is int of first digit.
.get_num:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, .panic_u32	# Return upon error.

	lb	$t2, 0($a1)		# Load character from stack buffer.

	seq	$t6, $v0, $zero		# If reached EOF or the current
	slt	$t7, $t2, $t3		# character is not a digit,
	sgt	$t8, $t2, $t4		# end the loop.
	or	$t6, $t6, $t7
	or	$t6, $t6, $t8
	bne	$t6, $zero, .store_u32

	mul	$t1, $t1, $t5		# Multiply result by 10 and add
	sub	$t2, $t2, $t3		# integer value of next character.
	addu	$t1, $t1, $t2

	j	.get_num
.store_u32:
	beq	$t0, $zero, .panic_u32	# Return if input buffer is null.

	sw	$t1, 0($t0)		# Store read int into input buffer.
.panic_u32:
	addi	$sp, $sp, 4		# Destroy stack frame.
	jr	$ra


.global read_to_char
read_to_char:
	addi	$sp, $sp, -4		# Initialize stack frame.

	li	$t0, 0			# Initialize buffer chars to 0.
	beq	$a1, $t0, .ret_char	# Return immediately if max count is 0.

	move	$t1, $a1		# Copy max count.
	addi	$t1, $t1, -1		# Limit chars read to max count - 1.

	move	$t2, $a3		# Copy target character.

	move	$a1, $a0		# Set output buffer of syscall.
	move	$a0, $a2		# Set file descriptor of syscall.
	li	$a2, 1			# Set read size to 1.

	beq	$a1, $zero, .read_null	# Do null path if pointer is null.

	beq	$t1, $zero, .read_end	# Put null in buf if max count is 1.
.read_loop:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, .panic_char	# Return immediately upon error.

	lb	$t3, 0($a1)		# Load character from string buffer.

	seq	$t4, $v0, $zero		# End loop if no characters were read
	seq	$t5, $t3, $t2		# or if character read was target char.
	or	$t4, $t5, $t4
	bne	$t5, $zero, .read_end

	addi	$t0, $t0, 1		# Increment buffer chars.
	addi	$a1, $a1, 1		# Increment string buffer pointer.

	blt	$t0, $t1, .read_loop	# Continue loop if chars read less than
					# max count - 1.
.read_end:
	sw	$zero, 0($a1)		# Store string null terminator.
	j	.ret_char		# Go to return.
.read_null:
	move	$a1, $sp		# Chars write to stack if ptr is null.
.null_loop:
	li	$v0, 4003		# Get character from file buffer.
	syscall

	blt	$v0, $zero, .panic_char	# Return immediately upon error.

	lb	$t3, 0($sp)		# Load character from stack buffer.

	seq	$t4, $v0, $zero		# End loop if no characters were read
	seq	$t5, $t3, $t2		# or if character read was target char.
	or	$t4, $t5, $t4
	bne	$t5, $zero, .ret_char

	addi	$t0, $t0, 1		# Increment non-target chars read.

	blt	$t0, $t1, .null_loop	# Continue loop if chars read less than
					# max count - 1.
.ret_char:
	move	$v0, $t0		# Return num characters in buffer.
.panic_char:
	addi	$sp, $sp, 4		# Destroy stack frame.
	jr	$ra

