.text
	.globl READ_ARRAY	
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