.text
	.globl READ_INT
	READ_INT:		# read integer.
		li 		$v0, 5
		syscall
		jr 		$ra	
	
