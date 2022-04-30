import sys

matrix = []

odd_win = [0.5, 1.5, 1.5, 0.5]
even_win = [1.5, 0.5, 0.5, 1.5]

choice = int(input("\nPlease enter the 0 for median, 1 for mean\n"))
levels = int(input("\nPlease enter number of levels\n"))

ROW_WIN_SZ = 2
COL_WIN_SZ = 2

row_sz = 0  # change according to input file.
col_sz = 0  # change according to input file.

def get_median(array):
    sz = len(array)
    if sz == 0:
        return -1

    array.sort()
    if sz & 1:
        return array[sz // 2]
    else:
        return (array[sz // 2] + array[sz // 2 - 1]) / 2

def get_mean(array, odd_or_even):
    sz = len(array)

    if sz != len(odd_win):
        return -1

    mean = 0
    for i in range(0, sz):
        if odd_or_even == 1:
            mean += (array[i] * odd_win[i])
        else :
            mean += (array[i] * even_win[i])
    
    return mean / sz

def print_2d(array, col_len):
    for i in range(0, len(array)):
        print("{:.2f}".format(array[i]), end=" ")
        if (i + 1) % col_len == 0:
            print("")
    print("")

if __name__ == "__main__":
    with open('input.txt') as file:
        for line in file:
            inner_list = [float(elt.strip()) for elt in line.split(',')]
            col_sz = len(inner_list)
            matrix = matrix + inner_list
    row_sz = len(matrix) // col_sz

    # print_2d(matrix, 4)

    for level in range(2, levels + 1):
        
        # Check if the level is valid level.
        if row_sz % ROW_WIN_SZ != 0 or col_sz % COL_WIN_SZ != 0:
            print("Result of level" + str(level))
            print("Invalid level!\n")
            sys.exit(1)

        row_sz_of_nxt_lvl = row_sz // ROW_WIN_SZ
        col_sz_of_nxt_lvl = col_sz // COL_WIN_SZ

        i_of_nxt_lvl = 0
        j_of_nxt_lvl = 0

        if level == 2:
            prev_array = [0.0] * (row_sz * col_sz)
        else:
            prev_array = new_array

        new_array = [0.0] * (row_sz_of_nxt_lvl * col_sz_of_nxt_lvl)

        for r in range(0, row_sz, ROW_WIN_SZ):
            j_of_nxt_lvl = 0
            for c in range(0, col_sz, COL_WIN_SZ):
                idx = r * col_sz + c 
                temp_array = [0.0] * (ROW_WIN_SZ * COL_WIN_SZ)
                
                for rw in range(0, ROW_WIN_SZ):
                    for cw in range(0, COL_WIN_SZ):
                        cur_idx = idx + rw * col_sz + cw

                        if level == 2:
                            temp_array[rw * COL_WIN_SZ + cw] = matrix[cur_idx]
                        else:
                            temp_array[rw * COL_WIN_SZ + cw] = prev_array[cur_idx]


                if choice == 0:
                    new_array[i_of_nxt_lvl * col_sz_of_nxt_lvl + j_of_nxt_lvl] = get_median(temp_array)
                else:
                    new_array[i_of_nxt_lvl * col_sz_of_nxt_lvl + j_of_nxt_lvl] = get_mean(temp_array, (level % 2))

                j_of_nxt_lvl += 1
            
            i_of_nxt_lvl += 1

        print("Result of level" + str(level) + " " + str(row_sz_of_nxt_lvl) + "*" + str(col_sz_of_nxt_lvl))
        print_2d(new_array, col_sz_of_nxt_lvl)

        row_sz = row_sz_of_nxt_lvl
        col_sz = col_sz_of_nxt_lvl

