.text
	.globl MEAN_ALGORITHM		
	 MEAN_ALGORITHM:	
		# $a0: address of array.
		# $a1: (current level) % 2.				
		addi 	$sp, $sp, -12
		sw 		$t1, 0($sp) 
		sw 		$t2, 4($sp) 
		sw 		$t3, 8($sp) 
		
		li 		$t1, 4
		li		$t2, 0
		li		$t3, 0
		
		MEAN_ALGORITHM_LOOP1:
				beq 		$t1, $zero, MEAN_ALGORITHM_LOOP1_OUT1
				
				add		$a1, $a0, $t3
				lwc1 	$f4, ($a1)
				
				beq		$a1, $zero, MUL_WITH_EVEN_ARR
				
				la		$t2, oddWinLvl	
				
				j		MUL_WITH_EVEN_ARR_SKIP				
				
				MUL_WITH_EVEN_ARR:
					la		$t2, evenWinLvl	
				
				MUL_WITH_EVEN_ARR_SKIP:
				add		$t2, $t2, $t3
				
				lwc1		$f6, ($t2) 
				mul.s 	$f4, $f4, $f6
				lwc1 	$f6, answerOfMedianOrMean
				add.s	$f4, $f4, $f6
				swc1 	$f4, answerOfMedianOrMean
					

				add 		$t1, $t1, -1				
				add 		$t3, $t3, 4				
				
				j 		MEAN_ALGORITHM_LOOP1
		MEAN_ALGORITHM_LOOP1_OUT1:
				lwc1		$f4, sizeOfOddWin
				lwc1 	$f6, answerOfMedianOrMean
				div.s 	$f6, $f6, $f4
				swc1 	$f6, answerOfMedianOrMean
				
		
				lw 		$t1, 0($sp) 
				lw 		$t2, 4($sp) 
				lw 		$t3, 8($sp) 
				add 		$sp, $sp, 12
				jr 		$ra

		
