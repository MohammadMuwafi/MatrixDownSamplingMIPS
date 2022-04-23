.text
	.globl PRINT_2D_ARRAY
	PRINT_2D_ARRAY:
		# $a0: address of array.
		# $a1: size of array.	
		# $a2: cols of array.
					
		move 	$s2, $a0
		move 	$s0, $a1
		
		la 		$a0, newLine
		li 		$v0, 4
		syscall
	
		li 		$s1, 0
		PRINT_ARRAY_LOOP:
			beq 		$s1, $s0, PRINT_ARRAY_OUT
			
			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp)
			# print int.
			lw 		$a0, ($s2)
			jal 		PRINT_INT
			lw 		$ra, 4($sp) # pop ra 
			add 		$sp, $sp,4

			la 		$a0, space
			li 		$v0, 4
			syscall
						
			addi 	$s2, $s2, 4
			addi 	$s1, $s1, 1
			
			move 	$s5, $s1
			div  	$s5, $a2
			mfhi 	$s5
			beq		$s5, $zero, PRINT_ARRAY_PRINT_NEW_LINE
			PRINT_ARRAY_SKIP:
				j 		PRINT_ARRAY_LOOP
			
			PRINT_ARRAY_PRINT_NEW_LINE:
				la 		$a0, newLine
				li 		$v0, 4
				syscall
				j 		PRINT_ARRAY_SKIP
		PRINT_ARRAY_OUT:
			la 		$a0, newLine
			li 		$v0, 4
			syscall	
												 
			jr 		$ra
