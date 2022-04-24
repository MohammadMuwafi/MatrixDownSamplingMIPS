.data
	file: 		.asciiz "input.txt"
	buffer: 	.space 1024
	bufferSize: 	.word 1024
	
	matrix: 	.word '\0'
.text
	main:
	#open file
	li 	$v0, 13		# system call to open file
	la 	$a0, file	# input file name
	li 	$a1, 0		# flags
	syscall
	move 	$t0, $v0	# save file descritor in $t0
	
	# Read to file just opened  
  	li 	$v0, 14       	# system call to read from file
  	la 	$a1, buffer   	# address of buffer 
  	lw	$a2, bufferSize # hardcoded buffer length
  	move 	$a0, $t0    	# put the file descriptor in $a0		
  	syscall          	# write to file

  	# Print input
 	la 	$a0, buffer 	# load the address into $a0
  	li 	$v0, 4		# print the string out
  	syscall 
	
	
	# close file
	li 	$v0, 16		# system call to close file
	move 	$a0, $t0	# restore fd	
	syscall			# close file
	
	
	
	#### convert string to matrix
	addiu 	$t0, $zero, 8 	# column size
	addiu 	$t1, $zero, 8	# row size
	addiu 	$t5, $zero, 0	# processing register
	
	la 	$t2, buffer	# address of string
	lb 	$t3, ($t2)	# $t3 = byte in string
	
	la 	$t4, matrix	# address of matrix
	
	NEXT_BYTE_LOOP1:
		beq 	$t3, ',', SAVE_ELEMENT		# save element if ',' is the character
		beq 	$t3, '\n', INCREMENT_ROWSIZE	# save element and increment row counter if newline
		beq 	$t3, 13, NEXT_CHR		# skip element if feed return
		blt 	$t3, '0', NEXT_BYTE_LOOP1_EXIT		# not expected character --> exit
		bgt 	$t3, '9', NEXT_BYTE_LOOP1_EXIT		# not expected character --> exit
		
		mul 	$t5, $t5, 10			# process the element
		subi	$t3, $t3, 48
		add 	$t5, $t5, $t3
		j 	NEXT_CHR
		
		INCREMENT_ROWSIZE:
			add 	$t1, $t1, 1 		# increment row size
			
		SAVE_ELEMENT:
			sw 	$t5, ($t4)		# store element
			addi 	$t4, $t4, 4		# increment 
			addiu 	$t5, $zero, 0
		
		NEXT_CHR:	
			addi 	$t2, $t2, 1
			lb 	$t3, ($t2)
			j 	NEXT_BYTE_LOOP1
	
	NEXT_BYTE_LOOP1_EXIT:
		la 	$t0, matrix	# get column size
		sub	$t0,$t4,$t0
		div 	$t0,$t0,4	
		div 	$t0,$t0,$t1
		
	
	# exit file
	li 	$v0, 10		# end file
	syscall
	
		
	
	
