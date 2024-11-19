.data
rep1:    .word 4, 9, 10, 15, 10, 2, 3  # Example array elements (depth-first representation)
rep2_len: .word 7                      # Length of rep1 array
rep2:    .space 28                     # Allocate space for rep2 array (7 * 4 bytes) (breadth-first representation)
index:   .word 0                       # Initialize index for rep2

.text
.globl main

main:
    # Load the length of rep1
    la   $t0, rep2_len
    lw   $t1, 0($t0)

    # Check if rep1 is null or empty
    beq  $t1, $zero, end_program

    # Call convertRep1ToRep2Helper to convert rep1 to rep2
    la   $a0, rep1               # rep1 array address
    la   $a1, rep2               # rep2 array address
    li   $a2, 0                  # currentIndex
    li   $a3, 0                  # index
    jal  convertRep1ToRep2Helper

    # Print the result (converted rep2 array)
    la   $a0, rep2               # Address of rep2 array
    li   $t2, 0                  # Initialize index to 0
end_program:
    # Exit the program
    li   $v0, 10
    syscall
    
#linear search function on rep1
linear_search_rep1:
    # Function parameters
    # $a0: rep1 array address
    # $a1: length of rep1 array
    # $a2: value to search for

    # Initialize index to -1 (indicating not found)
    li   $v0, -1

    # Check if rep1 is null or empty
    beq  $a0, $zero, end_search_rep1    # If rep1 is null, exit
    beq  $a1, $zero, end_search_rep1    # If rep1 length is 0, exit

    # Load rep1 length
    move $t1, $a1                       # $t1 = length of rep1

    # Loop through rep1 array
    li   $t0, 0                         # Initialize index to 0
search_loop:
    bge  $t0, $t1, end_search_rep1      # Exit loop if index >= length
    sll  $t2, $t0, 2                    # index * 4 (size of word)
    add  $t3, $a0, $t2                  # Calculate address of rep1[index]
    lw   $t4, 0($t3)                    # Load value from rep1[index]
    bne  $t4, $a2, continue_search      # If value not found, continue loop
    move $v0, $t0                       # If value found, store index in $v0
    j    end_search_rep1                # Exit loop
continue_search:
    addi $t0, $t0, 1                    # Increment index
    j    search_loop                    # Jump back to the start of the loop

end_search_rep1:
    jr   $ra                            # Return

log_base_2:
    beq  $a0, $zero, zero_case  # Check if the input is zero
    li   $v0, -1               # Initialize the counter to -1

count_bits_loop:
    srl  $a0, $a0, 1           # Shift the number right by 1 bit
    addi $v0, $v0, 1           # Increment the counter

    bne  $a0, $zero, count_bits_loop  # Continue looping until the number is zero

    jr   $ra                   # Return

zero_case:
    li $v0, 0                  # Return 0 for log base 2 of 0
    jr $ra

#linear search function on rep2 that uses jump and link to convert to rep1 and then do search on it
linear_search_rep2:
    # Function parameters
    # $a0: rep1 array address
    # $a1: rep2 array address
    # $a2: rep1 length
    # $a3: value to search for

    # Save the return address and arguments
    addi $sp, $sp, -16
    sw   $ra, 0($sp)
    sw   $a0, 4($sp)
    sw   $a1, 8($sp)
    sw   $a2, 12($sp)
    sw   $a3, 16($sp)

    # Convert rep2 to rep1
    la   $a0, rep1               # rep1 array address
    la   $a1, rep2               # rep2 array address
    li   $a2, 0                  # currentIndex
    li   $a3, 0                  # index
    jal  convertRep2ToRep1Helper

    # Restore arguments for linear search
    lw   $a0, 4($sp)             # rep1 array address
    lw   $a1, 12($sp)            # Length of rep1 array
    lw   $a2, 16($sp)            # Value to search for

    # Call linear_search_rep1
    jal  linear_search_rep1

    # Restore return address and return
    lw   $ra, 0($sp)
    addi $sp, $sp, 16
    jr   $ra

convertRep1ToRep2Helper:
    # Function parameters
    # $a0: rep1 array address
    # $a1: rep2 array address
    # $a2: currentIndex
    # $a3: index

    # Save the return address and arguments
    addi $sp, $sp, -20
    sw   $a0, 0($sp)
    sw   $a1, 4($sp)
    sw   $a2, 8($sp)
    sw   $a3, 12($sp)
    sw   $ra, 16($sp)

    # Base case: if currentIndex >= rep1_len
    la   $t0, rep2_len
    lw   $t1, 0($t0)
    bge  $a2, $t1, base_case

    # Visit current node: rep2[index++] = rep1[currentIndex]
    mul  $t2, $a2, 4             # currentIndex * 4
    add  $t3, $a0, $t2           # rep1[currentIndex] address
    lw   $t4, 0($t3)             # rep1[currentIndex]
    mul  $t5, $a3, 4             # index * 4
    add  $t6, $a1, $t5           # rep2[index] address
    sw   $t4, 0($t6)             # rep2[index] = rep1[currentIndex]
    addi $a3, $a3, 1             # index++

    # Visit left child: index = convertRep1ToRep2Helper(rep1, rep2, 2 * currentIndex + 1, index)
    mul  $t7, $a2, 2
    addi $t7, $t7, 1             # 2 * currentIndex + 1
    move $a2, $t7                # Update currentIndex for left child
    jal  convertRep1ToRep2Helper # Recursive call for left child
    move $a3, $v1                # Update index after left child

    # Visit right child: index = convertRep1ToRep2Helper(rep1, rep2, 2 * currentIndex + 2, index)
    lw   $a2, 8($sp)             # Restore currentIndex
    mul  $t7, $a2, 2
    addi $t7, $t7, 2             # 2 * currentIndex + 2
    move $a2, $t7                # Update currentIndex for right child
    jal  convertRep1ToRep2Helper # Recursive call for right child
    move $a3, $v1                # Update index after right child

base_case:
    # Load index to $v0 and return
    move $v0, $a1
    move $v1, $a3
    lw   $ra, 16($sp)            # Restore return address
    lw   $a0, 0($sp)
    lw   $a1, 4($sp)
    lw   $a2, 8($sp)
    lw   $a3, 12($sp)
    addi $sp, $sp, 20
    jr   $ra

convertRep2ToRep1Helper:
    # Function parameters
    # $a0: rep1 array address
    # $a1: rep2 array address
    # $a2: currentIndex
    # $a3: index

    # Save the return address and arguments
    addi $sp, $sp, -20
    sw   $a0, 0($sp)
    sw   $a1, 4($sp)
    sw   $a2, 8($sp)
    sw   $a3, 12($sp)
    sw   $ra, 16($sp)

    # Base case: if currentIndex >= rep2_len
    la   $t0, rep2_len
    lw   $t1, 0($t0)
    bge  $a2, $t1, base_case2

    # Visit current node: rep1[index++] = rep2[currentIndex]
    mul  $t2, $a2, 4             # currentIndex * 4
    add  $t3, $a0, $t2           # rep1[currentIndex] address

    mul  $t5, $a3, 4             # index * 4
    add  $t6, $a1, $t5           # rep2[index] address

    addi $a3, $a3, 1             # index++
    lw   $t4, 0($t6)             # rep2[currentIndex]
    sw   $t4, 0($t3)             # rep1[index] = rep2[currentIndex]

    # Visit left child: index = convertRep1ToRep2Helper(rep1, rep2, 2 * currentIndex + 1, index)
    mul  $t7, $a2, 2
    addi $t7, $t7, 1             # 2 * currentIndex + 1
    move $a2, $t7                # Update currentIndex for left child
    jal  convertRep2ToRep1Helper # Recursive call for left child
    move $a3, $v1                # Update index after left child

    # Visit right child: index = convertRep1ToRep2Helper(rep1, rep2, 2 * currentIndex + 2, index)
    lw   $a2, 8($sp)             # Restore currentIndex
    mul  $t7, $a2, 2
    addi $t7, $t7, 2             # 2 * currentIndex + 2
    move $a2, $t7                # Update currentIndex for right child
    jal  convertRep2ToRep1Helper # Recursive call for right child
    move $a3, $v1                # Update index after right child

base_case2:
    # Load index to $v0 and return
    move $v0, $a0
    move $v1, $a3
    lw   $ra, 16($sp)            # Restore return address
    lw   $a0, 0($sp)
    lw   $a1, 4($sp)
    lw   $a2, 8($sp)
    lw   $a3, 12($sp)
    addi $sp, $sp, 20
    jr   $ra
