.text
	.globl PRINT_ARRAY
	PRINT_ARRAY:
		# $a0: address of array.
		# $a1: size of array.		
		move 		$a2, $a0
		move 		$t0, $a1
		
		sub 		$sp, $sp, 4 # push ra 
		sw 		$ra, 4($sp)			
		# print space.
		la 		$a0, newLine
		jal 		PRINT_STR
		lw 		$ra, 4($sp) # pop ra 
		add 		$sp, $sp,4

	
		li 		$t1, 0
		PRINT_ARRAY_LOOP:
			beq 		$t1, $t0, PRINT_ARRAY_OUT
			
			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp)
			# print int.
			#lw 		$a0, ($a2)
			lwc1 	$f12, ($a2)
			li 		$v0, 2
			syscall	
			
			lw 		$ra, 4($sp) # pop ra 
			add 		$sp, $sp,4

			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp)			
			# print space.
			la 		$a0, space
			jal 		PRINT_STR
			lw 		$ra, 4($sp) # pop ra 
			add 		$sp, $sp,4
						
			addi 		$a2, $a2, 4
			addi 		$t1, $t1, 1
			
			j 		PRINT_ARRAY_LOOP
		PRINT_ARRAY_OUT:
			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp)			
			# print space.
			la 		$a0, newLine
			jal 		PRINT_STR
			lw 		$ra, 4($sp) # pop ra 
			add 		$sp, $sp,4						 
			jr 		$ra
