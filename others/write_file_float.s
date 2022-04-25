.data
	output_file: 	.asciiz "output.txt"
	row_size: 	.word 3				# test row_size -- changable
	col_size: 	.word 3				# test col_size	-- changable
	matrix: 	.float 12.34, 34.5, 65.7, 23.66, 89.102, 175.235, 876.4, 3.12, 0.56 # test_matrix -- changable
	million: 	.float 1000000.0	# used for getting all digits
	string: 	.space 2096		# maximum space of string = 2096 bytes
	
.text
	WRTITE_TO_FILE:
	addi 	$sp, $sp, -20
	sw 		$s0, 0($sp) 
	sw 		$s1, 4($sp) 
	sw 		$s2, 8($sp) 					
	sw 		$t0, 12($sp) 
	sw 		$t1, 16($sp) 
	# initialization
	lw	$t0, row_size	# get row size
	lw	$t1, col_size	# get column size
	addi	$s0, $zero, 0	# row counter
	addi	$s1, $zero, 0	# column counter
	la	$s3, matrix
	lwc1	$f4, million	# set to million
	cvt.d.s $f4,$f4
	addi 	$t6, $zero, '.'	# set $t6 to '.'
	addi	$t7, $zero, ','	# set $t7 to ','
	addi	$t8, $zero, '\n' # set $t8 to '\n'
	la	$t5, string	# load address of string

	### loop through elements in matrix
	
	LOOP_ROWS:
		beq	$s0, $t0, LOOP_ROWS_EXIT	# exit rows loop
		
		
		LOOP_COLS:
			beq 	$s1, $t1, LOOP_COLS_EXIT	# exit columns loop
			
			
			########## CONVERTING FLOATING POINT TO STRING	##########
			lwc1 	$f6, ($s3)	# get number
			cvt.d.s $f6, $f6	# convert to double precision floating point
	
			mul.d 	$f6, $f6, $f4	# get all digits in front of decimal point
	
			cvt.w.d $f6, $f6	# convert to word
			mfc1.d	$t2, $f6	# move floating point to register $t2
	
			# store digits in ascii format in stack
			addi 	$t4, $zero, 0	# digit counter
			CVT_DIGITS:
				div 	$t2, $t2, 10	# hi = less significant digit 
				mfhi 	$t3		# get remainder
				addi 	$t3, $t3, 48 	# convert to ascii
				sub 	$sp, $sp, 1	
				sb	$t3, ($sp)	# store digit in stack
				addi 	$t4, $t4, 1	# increment digit counter
				beq	$t4, 6, ADD_DOT	# add dot to stack
				bne 	$t2, $zero, CVT_DIGITS	# loop digits
				j	SAVE_DIGITS	# converting is done, save digits in string
	
				ADD_DOT:
					sub 	$sp, $sp, 1	# decrement stack pointer
					sb	$t6, ($sp)	# push dot in stack
					add	$t4, $t4, 1	# increment digit counter
					j	CVT_DIGITS
	
			# save digits in string
			SAVE_DIGITS:
				lb	$t3, ($sp)	# get most significant digit
				add 	$sp, $sp, 1	# delete stack space
				sub 	$t4, $t4, 1	# decrement digit counter
				sb	$t3, ($t5)	# store digit in string
				add 	$t5, $t5, 1	# increment string address
				bne 	$t4, $zero, SAVE_DIGITS		# loop digits in ascii format
			########## CONVERTING FLOATING POINT TO STRING ##########
			
			addi	$s1, $s1, 1	# increment column counter
			addi 	$s3, $s3, 4	# increment matrix address		
			beq	$s1, $t1, LOOP_COLS_EXIT	# exit column loop		
			
			# add coma
			sb	$t7, ($t5)	# store coma
			addi	$t5, $t5, 1	# increment string address

			j 	LOOP_COLS	# loop column elements
		LOOP_COLS_EXIT:
		
		sb 	$t8, ($t5)	# store new line
		addi 	$t5, $t5, 1	# increment string address
		
		addi 	$s1, $zero, 0	# reset column counter
		addi 	$s0, $s0, 1	# increment row counter
		j	LOOP_ROWS	# loop rows
	LOOP_ROWS_EXIT:

	# get string size
	la	$t1, string	# address of string
	sub	$t1, $t5, $t1	# get size of string

	# open output file
	li 	$v0, 13		# system call to open file
	la 	$a0, output_file	# output file name
	li 	$a1, 1		# flags
	li	$a2, 0
	syscall			# file descriptor in $v0

	# write on output file
	move 	$a0, $v0	# move file descriptor to $a0
	li 	$v0, 15      	# system call to write to file
  	la 	$a1, string  	# address of string 
  	move	$a2, $t1	# string length		
  	syscall
  	
  	# close output file
  	li 	$v0, 16		# system call to close file	
	syscall	

	# exit file
	li 	$v0, 10		# end file
	syscall
	lw 		$s0, 0($sp) 
	lw 		$s1, 4($sp) 
	lw 		$s2, 8($sp) 
	lw 		$t0, 12($sp) 
	lw 		$t1, 16($sp) 
	add 		$sp, $sp, 20
		
	# jr	$ra
