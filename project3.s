
.data
userInput:  .space 1001 # allow user to input string of 1000 characters
string: .asciiz "Not recognized"
testing: .asciiz "testing"
.text
main: 
      #-----------------------
      li $v0, 8  # gets user input from keyboard
      la $a0, userInput # stores user in put in $a0
      li $a1, 1000 # max lengeth of user input string
      syscall

      la $t9, userInput


# t0 has num of subtrings
while:
# find how many substrings and the length of each one
    lb $s1 0($t9)

    # abcd; abcd;   abcd;
    beq $t1, 1000, exit
    beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration
    beq $s1, 32, tabOrSpaceCharFound # 32 = space char, 9 = tab char
      # if we get here we are at a char and no more leading whitespace
    beq $s1, 59, subStringFound
    addi $t0,$t0, 1 # increment length of user string by 1
    addi $t1, $t1, 1 # increment loop
    addi $t9, $t9, 1 # increment loop address for loop
    move $a2, $t9 # will hold memory address of 4th char 
    j while
LeadingWhiteSpaceCounter:
     addi $t5, $t5, 1 # add 1 to leading whitespace counter
     j skip
tabOrSpaceCharFound:
      # if it is a tab or space char and len $t0 is 0 then we want to ignore because it is a leading whitespace 
      beq $t0, 0 LeadingWhiteSpaceCounter
      # bgt $t0, 0,  # if t0 equals 0 leading whitespace dont update length of userinput string
      
subStringFound:

    # sub $a0, $t9, $t2,
    # sub $a0, $a2, $t0 # find address of substring we need to substract length of string - number of substraings
    # sub $sp, $sp, $t0 # make room on stack
    # sw $ra 0($sp)
    jal sub_a
    # ***** dont forget to restore stack *****
    li $t0, 0 # set t0(length) back to 0
    # lw $ra, 0($sp)
    # add $sp, $sp, $t0
    j exit
    # add $t9, $t9, 1 # increment loop address
# if number of substrings = 0 do what we did project 2

sub_a:
    jal sub_b
    j exit
# t2 will hold length of string
sub_b: # sub b needs to do calculations and return val
    # bgt $t0, 4, codetesting
    lb $s0 0($a0) # we need to know length of string to do calculations also need to account for trailing whitespace
    # add $t2, $t2, 1 # everytime we get charcater add 1 to length of substring 
    jr $ra

# substringToLong:

#    li $v0,0
#     jr $ra

skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while

print:

    # beq $v1, 0, errorMessage
 
      li $v0, 1
      addi $a0, $v1, 0
      syscall
      j exit

exit:
      li $v0, 10
      syscall

codetesting:
    jr $ra
      li $v0, 4
      la $a0, testing
      syscall
       j exit
