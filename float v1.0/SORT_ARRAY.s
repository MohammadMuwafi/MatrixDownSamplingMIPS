.text
	.globl MEDIAN_ALGORITHM	
	MEDIAN_ALGORITHM:	
		# $a0: address of array.
		# $a1: size of array.
		
		addi 	$sp, $sp, -32 
		sw 		$t0, 0($sp) 
		sw 		$t1, 4($sp) 
		sw 		$t2, 8($sp) 
		sw 		$t3, 12($sp) 
		sw 		$t4, 16($sp) 
		sw 		$t5, 20($sp) 
		sw 		$t6, 24($sp) 
		sw 		$t7, 28($sp) 
		
		
		move 	$t0, $zero							# from i=0 to i=size-1
		move		$t6, $zero							# t6 has the address of arr[i]
		move		$t7, $zero							# t7 has the address of arr[j]
	
		
		MEDIAN_ALGORITHM_LOOP1: 
			beq		$t0, $a1, MEDIAN_ALGORITHM_OUT1
			addi 	$t1, $t0, 1					# j = i+1
			MEDIAN_ALGORITHM_LOOP2:
				beq 		$t1, $a1, MEDIAN_ALGORITHM_OUT2
				
				mul		$t6, $t0, 4				# t6 = t0*size = i*4
				mul		$t7, $t1, 4				# t7 = t1*size = j*4
				
				add 		$t2, $a0, $t6				# t2 = a0 + t6
				add 		$t3, $a0, $t7 				# t3 = a0 + t7
				
				lwc1		$f6, ($t2)
				lwc1		$f8, ($t3)
				
				c.lt.s 	$f6, $f8
				bc1t 	MEDIAN_ALGORITHM_SKIP_SWAP
				
				# swap operation.
				swc1 	$f6, ($t3)
				swc1 	$f8, ($t2)
				
				MEDIAN_ALGORITHM_SKIP_SWAP:
					add 		$t1, $t1, 1			# j++
					j 		MEDIAN_ALGORITHM_LOOP2
			MEDIAN_ALGORITHM_OUT2:
				add 		$t0, $t0, 1				# i++
				j 		MEDIAN_ALGORITHM_LOOP1
			MEDIAN_ALGORITHM_OUT1:
				div		$s0, $a1, 2
				mul		$s0, $s0, 4
				add		$s0, $s0, $a0
				

				lwc1		$f6, ($s0)
				  
				addi		$t0, $zero, 2
				div		$a2, $t0
				mfhi		$t0
				bne		$t0, $zero, MEDIAN_ALGORITHM_ODD
				
				sub		$s0, $s0, 4
				lwc1		$f8, ($s0)
				add.s  	$f6, $f6, $f8
				lwc1		$f8, forEvenLvl
				div.s 	$f6, $f6, $f8
				swc1 	$f6, answerOfMedianOrMean
				
				MEDIAN_ALGORITHM_ODD:
					lw 		$t0, 0($sp)
					lw 		$t1, 4($sp) 
					lw 		$t2, 8($sp) 
					lw 		$t3, 12($sp) 
					lw 		$t4, 16($sp) 
					lw 		$t5, 20($sp) 
					lw 		$t6, 24($sp) 
					lw 		$t7, 28($sp) 
					add 		$sp, $sp, 32
					jr 		$ra
					
