# MatrixDownSamplingMIPS
there are three files as following:
- "others" contains the problem statement as well as the pseudocode to solve the problem.
- "int v1" contains some modules that deal with integers but not floating point number.
- "float v1.1" contains the tool to write asm code, the program both in MIPS assembly and in python, generator of test cases and sample of test cases and their answer.

* to generate n*m matrix, you can run 'generate_input_matrix.py' on terminal as following:
  'python generate_input_matrix.py n m' where n and m are args of type integer and of course the generated matrix will be in 'input.txt'.

* to see the result of downsampling of generated matrix in 'input.txt' you can run 'main.py' on terminal as following:
  'python main.py' and the result will be printed on terminal.
