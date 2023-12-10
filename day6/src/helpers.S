# Wyatt Geckle
#
# MIPS problem helper functions


.section .text

.global ways_to_break_record
ways_to_break_record:
	li	$t0, 0			# Initialize velocity.
.rec_loop:
	addiu	$t0, $t0, 1		# Add 1 to velocity on each iteration.

	subu	$t1, $a0, $t0		# Get time of motion.
	mult	$t0, $t1		# Get distance = velocity * time.
	mflo	$t2
	mfhi	$t1

	sltu	$t3, $t1, $a2		# Continue if distance < record loop.
	seq	$t4, $t1, $a2
	sltu	$t5, $t2, $a3
	and	$t4, $t4, $t5
	or	$t3, $t3, $t4
	bne	$t3, $zero, .rec_loop

	addu	$t3, $t0, $t0		# Get -2 * min velocity + 1, which
	sltu	$t2, $t3, $t0		# is equivalent to
	not	$t3, $t3		# ~(2 * min velocity) + 2.
	not	$t2, $t2
	addiu	$t5, $t3, 2
	sltu	$t4, $t5, $t3
	addu	$t4, $t2, $t4

	addu	$v1, $t5, $a0		# Number of ways to break reacord is
	sltu	$t0, $v1, $t5		# race time + (-2 * min velocity + 1).
	addu	$v0, $t0, $t4

	jr	$ra

