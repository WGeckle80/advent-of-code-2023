# Wyatt Geckle
#
# MIPS print functions
#
# MIPS Linux syscalls found at https://syscalls.w3challs.com/?arch=mips_o32
# Linux man pages found at https://www.man7.org/linux/man-pages/index.html
# Getting started guide at https://youtu.be/5AN4Fo0GiBI


.section .text

.global print_i32
print_i32:
	move	$t0, $a0		# Copy parameter to different register.

	lui	$t1, 0x8000		# Load minimum integer into $t1.

	beq	$t0, $t1, print_min_i32	# Print minimum int if parameter equal.

	and	$t1, $t0, $t1		# If the msb of the parameter is 0,
	beq	$t1, $zero, pos_i32	# print the integer as normal.

	li	$t1, '-'		# Load minus sign at bottom of stack.
	sb	$t1, 0($sp)

	li	$v0, 4004		# Print minus sign to stdout.
	li	$a0, 1
	move	$a1, $sp
	li	$a2, 1
	syscall

	sub	$t0, $zero, $t0		# Negate the parameter.

	j	pos_i32			# Go to u32 print procedure.


.global print_u32
print_u32:
	move $t0, $a0

pos_i32:
	addi	$sp, $sp, -12		# Grow stack for up to 10 digits.

	li	$t1, 10			# Keep 10 in register for division.

	move	$t3, $sp		# Set array pointer to top of stack.
	addi	$t3, 12

	li	$a2, 0			# Initialize num length as 0.
stack_i32:
	divu	$t0, $t1		# Divide integer by 10, reassign
	mflo	$t0			# integer from lo register, and get
	mfhi	$t4			# remainder from hi register.
	
	addi	$t3, $t3, -1		# Point to next position in stack.

	addi	$t4, $t4, '0'		# Store corresponding digit character
	sb	$t4, 0($t3)		# in stack at the current pointer.

	addi	$a2, $a2, 1		# Increment length.

	bne	$t0, $zero, stack_i32	# Continue printing digits if not zero.

	li	$v0, 4004		# Print number to stdout.
	li	$a0, 1
	move	$a1, $t3
	syscall

	addi	$sp, $sp, 12		# Destroy stack frame.

	jr	$ra
print_min_i32:
	li	$v0, 4004		# Print -2147483648 to stdout.
	li	$a0, 1
	la	$a1, min_i32
	li	$a2, 11
	syscall

	jr	$ra


.global print_str
print_str:
	addi	$sp, $sp, -12		# Push return address, char pointer
	sw	$ra, 8($sp)		# and file descriptor onto stack.
	sw	$a0, 4($sp)
	sw	$a1, 0($sp)

	jal	strlen			# Get $a0 string length.

	lw	$a0, 0($sp)		# Pop file descriptor, char pointer,
	lw	$a1, 4($sp)		# and return address from stack.
	lw	$ra, 8($sp)		# Set char pointer as write buffer
	addi	$sp, $sp, 12		# pointer.

	move	$a2, $v0		# Set print length to string length.

	li	$v0, 4004		# Print string to file descriptor.
	syscall

	jr	$ra


.global putchar
putchar:
	addi	$sp, $sp, -4		# Push character onto stack.
	sb	$a0, 0($sp)

	li	$v0, 4004		# Print character to stdout.
	li	$a0, 1
	move	$a1, $sp
	li	$a2, 1
	syscall

	addi	$sp, $sp, 4		# Destroy stack frame.

	jr	$ra


.section .data

min_i32: .asciz "-2147483648"

