.text
	.globl PRINT_INT
	PRINT_INT:	# print integer.
		li 		$v0, 1
		syscall		
		
		jr 		$ra
