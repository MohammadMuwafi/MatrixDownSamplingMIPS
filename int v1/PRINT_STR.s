.text
	.globl PRINT_STR
	PRINT_STR:	# print string.
		li 		$v0, 4
		syscall
	
		jr 		$ra
	
