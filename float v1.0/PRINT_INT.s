.text
	.globl PRINT_INT
	PRINT_INT:	# print integer.
		li 		$v0, 2
		syscall		
		
		jr 		$ra
