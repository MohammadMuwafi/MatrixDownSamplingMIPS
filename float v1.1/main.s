.data
	.globl	newLine
	.globl	line
	.globl	space
	.globl	levels
	.globl	evenWinLvl
	.globl	oddWinLvl
	.globl	answerOfMedianOrMean
	.globl	forEvenLvl
	.globl	choice
	.globl 	sizeOfOddWin
	
	
	####################### for displaying. ########################
	msg_rows: 	.asciiz "\n Please enter the number of rows: \n"
	msg_cols: 	.asciiz "\n Please enter the number of cols: \n"
	msg_arr: 		.asciiz "\n Please enter the values of 2D-array: \n"
	msg_lvl1: 	.asciiz "\n Please enter the values of levels: \n"
	msg_lvl2: 	.asciiz "\n Level number: "
	invalid_lvl: 	.asciiz "\n Sorry, invalid level!\n"
	
	msg3: 		.asciiz "\n The array before sorting: \n"	
	msg4: 		.asciiz "\n The array after sorting: \n"
	newLine: 		.asciiz "\n "
	line: 		.asciiz "==================================\n"
	space: 		.asciiz " "
	################################################################
	
	# mean or median
	choice: 		.word 1
			
	# properties of input matrix.
	rows: 		.word 8
	cols: 		.word 8
	size: 		.word 64
	sizeInByte: 	.word 256
	
			
	# properties of window matrix.
	rowsWindow: 	.word 2
	colsWindow: 	.word 2
	windowSize: 	.word 4	
	
	# the index of cell in the input matrix after converting it into 1D array.
	index: 		.word 0
	
	# the median value for the elements in the specific window.
	answerOfMedianOrMean: 		.float 0.0
	meanOrMedian:	.word 0

	# arr is the address of input matrix in memory. 
	arr: 		.float 1.1,  2.1,  3.1,  4.1,  5.1,  6.1,  7.1,  8.1
				.float 9.1,  10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1
				.float 17.1, 18.1, 19.1, 20.1, 21.1, 22.1, 23.1, 24.1
				.float 25.1, 26.1, 27.1, 28.1, 29.1, 30.1, 31.1, 32.1
				.float 33.1, 34.1, 35.1, 36.1, 37.1, 38.1, 39.1, 40.1
				.float 41.1, 42.1, 43.1, 44.1, 45.1, 46.1, 47.1, 48.1
				.float 49.1, 50.1, 51.1, 52.1, 53.1, 54.1, 55.1, 56.1
				.float 57.1, 58.1, 59.1, 60.1, 61.1, 62.1, 63.1, 64.1
					
	
	# tempArray that will contain the elements of current window matrix.
	tempArray: 	.float 1.1, 2.1
			 	.float 9.1, 10.1
	
	sizeOfOddWin:	.float 4.0	 	
			 	
	# vars contain information for the new created array for the new level.
	tempSize:		.word 0
	tempRows: 	.word 0
	tempCols: 	.word 0
	
	# window matrix for computing the mean of the even level.
	evenWinLvl: 	.float 1.5, 0.5
				.float 0.5, 1.5
					
	# window matrix for computing the mean of the odd level.
	oddWinLvl:	.float 0.5, 1.5
				.float 1.5, 0.5
	# level of reduction, input user.			
	levels: 		.word 0
	
	# indices for the specific cell in the array of the current level. 
	tempI: 		.word 0
	tempJ: 		.word 0
	
	# var for calculating avg in even len. of array case.
	forEvenLvl:	.float 2.0
	
.text
	.globl main
	
	main:
		
		# print msg & read levels.
		la 		$a0, msg_lvl1
		jal 		PRINT_STR			
		jal 		READ_INT
		sw 		$v0, levels
		
		move 	$s7, $zero
		LOOP_LEVELS:
			lw		$s0, levels
			beq 		$s7, $s0, LOOP_LEVELS_EXIT 			# if (t0 == rows) break;		
			
			la 		$a0, msg_lvl2
			li 		$v0, 4
			syscall
			move 	$a0, $s7
			addi		$a0, $a0, 1			
			li 		$v0, 1
			syscall	
			la		$a0, newLine
			jal 		PRINT_STR	
						
			# create dynamic newArray[row/rowWindow][col/colWindow].
			# s0 contains the size of new array in bytes.

			# push regs to stack.
			addi 	$sp, $sp, -16
			sw 		$s0, 0($sp) 
			sw 		$s1, 4($sp) 
			sw 		$s2, 8($sp) 					
			sw 		$s3, 8($sp) 
			
			# tempRows = rows/rowsWindow
			lw	 	$s0, rows
			lw	 	$s1, rowsWindow
			#div		$s0, $s0, $s1
			div		$s0, $s1
			mflo		$s0
			
			# check if row can be divided by 2.
			mfhi		$s1
			bne 		$s1, $zero, LOOP_LEVELS_ERROR 
									
			sw		$s0, tempRows
			
			# tempCols = cols/colsWindow
			lw	 	$s2, cols
			lw	 	$s3, colsWindow
			#div		$s2, $s2, $s3
			div		$s2, $s3
			mflo		$s2

			# check if col can be divided by 2.
			mfhi		$s1
			bne 		$s1, $zero, LOOP_LEVELS_ERROR
			
			sw		$s2, tempCols
			
			# create newArray with size ==> tempSize = tempRows * tempCols
			mul		$s0, $s0, $s2
			sw		$s0, tempSize
			mul		$s0, $s0, 4
			move		$a0, $s0  
			li 		$v0, 9		
			syscall	
			
			# 1 sw 	$v0, newArray
			move		$s4, $v0
				
				
			# pop regs from stack.														
			lw 		$s0, 0($sp) 
			lw 		$s1, 4($sp) 
			lw 		$s2, 8($sp) 
			lw 		$s3, 12($sp) 
			add 		$sp, $sp, 16		
		
			#########################################################################
			
			move		$t0, $zero # t0 = 0.
			move		$t1, $zero # t1 = 0.		

			# tempI = tempJ = 0;
			move 	$s0, $zero
			sw		$s0, tempI
  			sw		$s0, tempJ 
															
			LOOP_ROWS:
				lw		$s0, rows
				beq 		$t0, $s0, LOOP_ROWS_EXIT 		# if (t0 == rows) break;
				
				move 	$t1, $zero
				
				
				# initiate tempJ with 0
				move 	$s0, $zero
	  			sw		$s0, tempJ  
							
				LOOP_COLS:
					lw		$s0, cols
					beq 		$t1, $s0, LOOP_COLS_EXIT 	# if (t1 == cols) break;
								
					
					################################################################
					move		$t2, $t0 					# t2 = t0
					lw		$s0, cols
					mul		$t2, $t2, $s0 				# t2 *= t0 
					add		$t2, $t2, $t1 				# t2 += t1
					sw		$t2, index 				# index = t2
					
										
					
					move		$t4, $zero 				# iw = 0;
					move		$t5, $zero 				# jw = 0;
					
					LOOP_WIN_ROWS:
						lw		$s0, rowsWindow
						beq		$t4, $s0, LOOP_WIN_ROWS_EXIT
						
						move		$t5, $zero
						LOOP_WIN_COLS:
							lw 		$s0, colsWindow
							beq		$t5, $s0, LOOP_WIN_COLS_EXIT
							
							# logic.
							###
							move		$t6, $t4			# t6 = curr_indx
							lw		$s0, cols
							mul		$t6, $t6, $s0		# t6 = iw*cols
							lw		$t7, index		# t7 = idx
							add		$t6, $t6, $t7		# t6 = iw*cols + idx
							add		$t6, $t6, $t5		# t6 = iw*cols + idx + jw
							mul		$t6, $t6, 4		# t6 = curr_index in bytes.
							
							#******************#
							beq 		$s7, $zero, MAIN_CON						
							
							move		$s0, $s4
														
							j		MAIN_SKIP
							
							
							MAIN_CON:
								la		$s0, arr
							
							
							MAIN_SKIP:
							
							add		$t6, $t6, $s0		# t6 = address of array + curr_index in bytes
							
							
							#$$
							####
							# here we should check if the prev level > 1 or not.
							bge 		$s7, 1, MAIN_ADD_SIZE_OF_PREV_ARRAY
							
							j  		MAIN_ADD_SIZE_OF_PREV_ARRAY_SKIP
							
							MAIN_ADD_SIZE_OF_PREV_ARRAY:
							lw		$s0, sizeInByte
							sub		$t6, $t6,	$s0						
							MAIN_ADD_SIZE_OF_PREV_ARRAY_SKIP:
							
							####
							
							# t8 = iw*cs + jw
							move 	$t8, $t4
							lw		$s0, colsWindow
							mul		$t8, $t8, $s0
							add		$t8, $t8, $t5
							mul		$t8, $t8, 4 
							la		$s0, tempArray
							add		$t8, $t8, $s0		# t6 = address of array + curr_index in bytes

						
							lwc1 	$f4, ($t6)
							swc1 	$f4, ($t8)
							#lw 		$t9, ($t6)		# t9 = array[t6] 
							#sw		$t9, ($t8)		# tempArray[t8] = t9		
							
							addi 	$t5, $t5, 1
							j 		LOOP_WIN_COLS
						
						LOOP_WIN_COLS_EXIT:
							addi		$t4, $t4, 1
							j		LOOP_WIN_ROWS 		
							
					
					LOOP_WIN_ROWS_EXIT:
						
						lw		$s5, choice
						la 		$a0, tempArray
						
						beq 		$s5, $zero, WORK_WITH_MEDIAN
						
						li		$s5, 2
						move		$s6, $s7
						add		$s6,	$s6, 1
						div		$s6, $s5
						mfhi 	$s6
						beq		$s6,	$zero, SET_EVEN_LEVEL 
						li		$a1, 1
						j		SET_EVEN_LEVEL_SKIP
						
						SET_EVEN_LEVEL:
							li		$a1, 0
						SET_EVEN_LEVEL_SKIP:
							
						jal		MEAN_ALGORITHM
						j		WORK_WITH_MEDIAN_SKIP
						
						WORK_WITH_MEDIAN:
						# sort array.
							lw 		$a1, windowSize 
							jal 		MEDIAN_ALGORITHM
						
						WORK_WITH_MEDIAN_SKIP:
						
						# print median.
						lwc1 	$f12, answerOfMedianOrMean
						li		$v0, 2
						syscall
						
						la 		$a0, newLine
						li 		$v0, 4
						syscall	

						#sw		$v0, median
						#lw		$a0, median
						#jal		PRINT_INT
						

						addi 	$sp, $sp, -12
						sw 		$s0, 0($sp) 
						sw 		$s1, 4($sp) 
						sw 		$s2, 8($sp) 
						
						
						lw		$s0, tempCols
						lw	 	$s1, tempI
						lw		$s2, tempJ
						
						mul		$s0, $s0, $s1
						add		$s0, $s0, $s2
						mul		$s0, $s0, 4
						# 2 -- la		$s1,	newArray
						move		$s1, $s4
						
						add		$s1, $s1, $s0
						#lw		$s2, median
						#sw		$s2, 0($s1)
						
						lwc1 	$f6, answerOfMedianOrMean
						swc1 	$f6, 0($s1)
																																																
																					
						lw 		$s0, 0($sp) 
						lw 		$s1, 4($sp) 
						lw 		$s2, 8($sp) 
						add 		$sp, $sp, 12
						
						# printing.
						la 		$a0, tempArray
						lw 		$a1, windowSize 
						lw		$a2, colsWindow
						jal 		PRINT_2D_ARRAY
							
					################################################################
						lw 		$s0, colsWindow
						add	 	$t1, $t1, $s0 # t1 += colsWindow
						
						# tempJ++
						lw	 	$s0, tempJ
						addi 	$s0, $s0, 1
						sw		$s0, tempJ 
						
						
						j		LOOP_COLS	
					
				LOOP_COLS_EXIT:
					# t0 += rowsWindow
					lw		$s0, rowsWindow
					add	 	$t0, $t0, $s0 
					
					# tmepI++
					lw	 	$s0, tempI
					addi 	$s0, $s0, 1
					sw		$s0, tempI 
					
					j		LOOP_ROWS	 
							 
			LOOP_ROWS_EXIT:
				add		$s7, $s7, 1
				
				# printing.
				# 3 -- la 		$a0, newArray
				move		$a0, $s4
				lw 		$a1, tempSize
				lw		$a2, tempCols
				jal 		PRINT_2D_ARRAY
				la 		$a0, newLine
				jal 		PRINT_STR
				
				# update rows and cols. 
				lw		$a0, tempRows
				sw		$a0, rows
				lw		$a0, tempCols
				sw		$a0, cols
						
				sw		$s0, tempSize
				mul		$s0, $s0, 4
				sw		$s0, sizeInByte
				
				j 		LOOP_LEVELS
		LOOP_LEVELS_ERROR:
			la		$a0, invalid_lvl
			jal 		PRINT_STR	
		LOOP_LEVELS_EXIT:
			jal END_PROGRAM
				
###################### METHODS ########################
	
	END_PROGRAM:	# terminate program.
		li 		$v0, 10
		syscall
	
#######################################################

	READ_INT:		# read integer.
		li 		$v0, 5
		syscall
		jr 		$ra	

#######################################################

	PRINT_STR:	# print string.
		li 		$v0, 4
		syscall
	
		jr 		$ra
				
#######################################################

	READ_ARRAY:	# read 2d array.
		# $a0: address of array.
		# $a1: size of array.
		move		$a2, $a0
		move		$t0, $a1
		li 		$t1, 0
		
		READ_ARRAY_LOOP:
			beq 		$t1, $t0, READ_ARRAY_OUT
			
			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp) 

			jal 		READ_INT
			sw 		$v0, ($a2)
			
			addi 	$a2, $a2, 4
			addi 	$t1, $t1, 1
			
			lw 		$ra, 4($sp) # pop ra 
			add 		$sp, $sp,4 
			
			j 		READ_ARRAY_LOOP
		READ_ARRAY_OUT:
			jr 		$ra

#######################################################
	
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

#######################################################			

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
		PRINT_2D_ARRAY_LOOP:
			beq 		$s1, $s0, PRINT_2D_ARRAY_OUT
			
			sub 		$sp, $sp, 4 # push ra 
			sw 		$ra, 4($sp)
			# print int.
			lwc1 	$f12, ($s2)
			li 		$v0, 2
			syscall	
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
			beq		$s5, $zero, PRINT_2D_ARRAY_PRINT_NEW_LINE
			PRINT_2D_ARRAY_SKIP:
				j 		PRINT_2D_ARRAY_LOOP
			
			PRINT_2D_ARRAY_PRINT_NEW_LINE:
				la 		$a0, newLine
				li 		$v0, 4
				syscall
				j 		PRINT_2D_ARRAY_SKIP
		PRINT_2D_ARRAY_OUT:
			la 		$a0, newLine
			li 		$v0, 4
			syscall	
												 
			jr 		$ra
		
						
#######################################################
	
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

#######################################################

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