
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
    beq $s1, 10, exit # line feed char no more printing
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
    sub $sp, $sp, $t0 # make room on stack
    sw $ra 0($sp)
    jal sub_a
    # ***** dont forget to restore stack *****
    lw $ra, 0($sp)
    add $sp, $sp, $t0
    li $t0, 0 # set t0(length) back to 0
    j while
    # add $t9, $t9, 1 # increment loop address
# if number of substrings = 0 do what we did project 2

sub_a:
    jal sub_b
    jal print

    jr $ra
# t2 will hold length of string
sub_b: # sub b needs to do calculations and return val
    move $s3, $a0
    # jal findLength
    jal charcheck

    # sum is stored in v1
    jr $ra
charcheck:
    lb $s0 0($a0) # we need to know length of string to do calculations also need to account for trailing whitespace
    # add $t2, $t2, 1 # everytime we get charcater add 1 to length of substring
       blt $s0, 48, codetesting
       ble $s0, 57, numCalc # 57 = '9' in ascii. if char <= 57 add it to sum

       blt $s0, 65, codetesting # 65 = 'A' in ascii. if char < 65 print error
       ble $s0, 88, capitalCalc # 88 = 'X' in ascii. if char <= 88 do math

       blt $s0, 97, codetesting # 'a' = 97 in ascii. if char < 97 skip it
       ble $s0, 120, lowerCalc # 'x' in ascii = 120. if char <= 120 add it to sum
       bgt $s0, 120, codetesting


    # jr $ra
 numCalc:
       sub $s0, $s0, 48 # if number found update val of char to be - 48
       j multiplicationloop

 capitalCalc:

    sub $s0, $s0, 55 # if capital letter found subtract val by 55
    j multiplicationloop

lowerCalc:
    sub $s0, $s0, 87
    j multiplicationloop

 multiplicationloop:
    bgt $t2, 3, exponentWrong # max exponent val should be 3. so if there are more than 4 chars do math but 
    beq $t2, 3, exponent3 
    beq $t2, 2, exponent2
    beq $t2, 1, exponent1
    beq $t2, 0, exponent0
exponentWrong: 
    add $v1, $t8, $s0 # exponent 0 just add char value to sum
    sub $t2, $t2, 1 # decrement exponent value by 1
    j increment

exponent3:
      # mul $s7, 33, 33
      # mul $s7, 33, $s7
      # mul $s7, $s7, $a3 # multiply a3 char value by 33 * 33 * 33
      mult $t3, $t3
      mflo $s7
      mult $t3, $s7
      mflo $s7
      mult $s0, $s7 # multipy char val * 33^3
      mflo $s7
      add $t8, $t8, $s7
      li $s7, 0
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent2:
      mult $t3, $t3 # t3 is register with base value
      mflo $s7 # 33^2
      mult $s7, $s0 # have to multiply char value 
      mflo $s7
      add $t8, $t8, $s7 # add into sum var t8
      li $s7, 0 # set s7 back to zero
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent1:
      mult $t3, $s0
      # mul $s7, 33, $a3 # if exponent 1 all i have to do is multiply char value by 33
      mflo $s7
      add $t8, $t8, $s7
      li $s7, 0
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent0:
      add $v1, $t8, $s0 # exponent 0 just add char value to sum
      # li $s7, 0
      jr $ra
      # j print
increment:
      addi $a0, $a0, 1 # increment byte address
      j charcheck

findLength:
      lb $s6 0($s3)
      beq $s6, 10, exponent # if char equals line feed we know how long the string is so we know what exponent we need to use
      beq $s6, 59, exponent # if char equals line feed we know how long the string is so we know what exponent we need to use

      beq $s6, 32, verify # if char is a space character verify if it is apart of input string or trailing white space
      beq $s6, 9, verify
      addi $t4, $t4, 1 # add 1 to t4
      addi $s3, $s3, 1
      j findLength

verify:
    beq $t4, 4, exponent # if space is found and legth is already 4 we know it is a trailing whitespace
    blt $t4, 4, makeSureAllOtherCharsRBlank # if the length of string is less than 4 and i find a space or tab char the char next to it HAS to be another space or it is automatically invalid

makeSureAllOtherCharsRBlank:
    addi $s3, $s3, 1 # going to check character right next to space char
    lb $s5, 0($s3) # s5 is new feed s6 is space
    # sub $a3, $a3, 1 # have to subtract memory address again to keep correct val
    beq $s5, 32, findLength # if character next to it is space then go back to findlength
    beq $s5, 9, findLength # if character next to it is space then go back to findlength
    beq $s5, 10, exponent # if character next to it is space then go back to findlength
    beq $s5, 59, exponent # if character next to it is space then go back to findlength

    j codetesting
exponent:
      # sub $a3, $a3, $t4 # go back to original memory addres now that we know length of string
      sub $t2, $t4, 1 # the first char exponent is length of char - 1 # t2 holds exponent val
      # lb $s6 0($a3) # load  char into $s6
      jr $ra
skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while

print:

    beq $v1, 0, errorMessage
    bgt $v1, 27931, errorMessage
    li $v0, 1
    addi $a0, $v1, 0
    syscall
    jr $ra
    j while

errorMessage:

       # print error message
       li $v0, 4
       la $a0, string
       syscall
       j exit
exit:
      li $v0, 10
      syscall

codetesting:
      li $v0, 4
      la $a0, testing
      syscall
        jr $ra

       j exit
