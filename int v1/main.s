.data
	.globl newLine
	.globl line
	.globl space
	
	####################### for displaying. ########################
	msg_rows: 	.asciiz "\n Please enter the number of rows: \n"
	msg_cols: 	.asciiz "\n Please enter the number of cols: \n"
	msg_arr: 		.asciiz "\n Please enter the values of 2D-array: \n"
	msg_lvl1: 	.asciiz "\n Please enter the values of levels: \n"
	msg_lvl2: 	.asciiz "\n The is the level number: "
	
	msg3: 		.asciiz "\n The array before sorting: \n"	
	msg4: 		.asciiz "\n The array after sorting: \n"
	newLine: 		.asciiz "\n "
	line: 		.asciiz "==================================\n"
	space: 		.asciiz " "
	################################################################
	
			
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
	median: 		.word 0
	
	# arr is the address of input matrix in memory. 
	arr: 		.word 1, 2, 3, 4, 5, 6, 7, 8 
				.word 9, 10, 11, 12, 13, 14, 15, 16
				.word 17, 18, 19, 20, 21, 22, 23, 24
				.word 25, 26,27, 28, 29, 30, 31, 32
				.word 33, 34, 35, 36, 37, 38, 39, 40
				.word 41, 42, 43, 44, 45, 46, 47, 48
				.word 49, 50, 51, 52, 53, 54, 55, 56
				.word 57, 58, 59, 60, 61, 62, 63, 64
					
	
	# tempArray that will contain the elements of window matrix.
	tempArray: 	.word 0, 0
			 	.word 0, 0
	
	tempSize:		.word 0
	tempRows: 	.word 0
	tempCols: 	.word 0
	
	# window matrix for computing the mean of the even level.
	evenWinLvl: 	.float 1.5, 0.5
				.float 0.5, 1.5
					
	# window matrix for computing the mean of the odd level.
	oddWinLvl:	.float 0.5, 1.5
				.float 1.5, 0.5
				
	levels: 		.word 0
	tempI: 		.word 0
	tempJ: 		.word 0

.text
	.globl main
	
	main:	
		# print msg & read levels.
		la 		$a0, msg_lvl1
		jal 		PRINT_STR				
		jal 		READ_INT
		sw 		$v0, levels
		
		move $s7, $zero
		LOOP_LEVELS:
			lw		$s0, levels
			beq 		$s7, $s0, LOOP_LEVELS_EXIT 			# if (t0 == rows) break;		
			
			la 		$a0, msg_lvl2
			li 		$v0, 4
			syscall
			move 	$a0, $s7
			addi		$a0, $a0, 1			
			jal 		PRINT_INT	
			la		$a0, newLine
			jal 		PRINT_STR	
						
			# here we should check if we can calculate the new level or not (rows % 4 = ?)				
			##############################################################################
			
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
			div		$s0, $s0, $s1
			sw		$s0, tempRows
			
			# tempCols = cols/colsWindow
			lw	 	$s2, cols
			lw	 	$s3, colsWindow
			div		$s2, $s2, $s3
			sw		$s2, tempCols
			
			# create newArray with size ==> tempSize = tempRows * tempCols
			mul		$s0, $s0, $s2
			sw		$s0, tempSize
			mul		$s0, $s0, 4
			move		$a0, $s0  
			li 		$v0, 9		
			syscall	
			
			# 1 sw 		$v0, newArray
			move			$s4, $v0
				
				
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

													
							lw 		$t9, ($t6)		# t9 = array[t6] 
							sw		$t9, ($t8)		# tempArray[t8] = t9		
							
							addi 	$t5, $t5, 1
							j 		LOOP_WIN_COLS
						
						LOOP_WIN_COLS_EXIT:
							addi		$t4, $t4, 1
							j		LOOP_WIN_ROWS 		
							
					
					LOOP_WIN_ROWS_EXIT:
					
						# print array.
						la 		$a0, tempArray
						lw 		$a1, windowSize 
						jal 		SORT_ARRAY
						
						# print median.
						sw		$v0, median
						lw		$a0, median
						jal		PRINT_INT
						

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
						lw		$s2, median
						sw		$s2, 0($s1)
																																																
																					
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
		
		LOOP_LEVELS_EXIT:
				
###################### METHODS ########################
	END_PROGRAM:	# terminate program.
		li 		$v0, 10
		syscall
