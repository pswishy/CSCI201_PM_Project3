.data

user_input: .space 1001
error:  .asciiz "-"

.text
main: 
      #-----------------------
      li $v0, 8  # gets user input from keyboard
      la $a0, user_input # stores user in put in $a0
      li $a1, 1000 # max lengeth of user input string
      syscall

      # first step count how many chars are in userinput while ignoring blank and space tabs
      li $t0, 0 # t0 = length of user input string
      li $t1, 0 # iterator variable
      li $t3, 30 # base for my program
      li $t4, 0 # length counter
      li $t5, 0 # leading white space counter
      li $t7, 0 # substring var
      li $t8, 0 # sum variable
      la $t9, userInput

# start of program. we have to find starting memory address
while:  
       lb $s1, 0($t9)
       # beq $t1, 6, calculateMemoryAdress # finished processing all 1000 chars and if after 4 chars all are whitespace we can do check
       beq $t1, 1000, calculateMemoryAdress # finished processing all 1000 chars and if after 4 chars all are whitespace we can do check
       bgt $t0, 4, trailingWhiteSpaceCheck # after we get first four chars the only other other valid char is a white space char
       beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration
       beq $s1, 32, tabOrSpaceCharFound # 32 = space char, 9 = tab char
       # beq $s1, 59, calculateMemoryAdress # if we reach semi colon go to calculate memory addres??
      # if we get here we are at a char and no more leading whitespace
      # ------------------------
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
      beq $t0, 0, skip # if t0 equals 0 leading whitespace dont update length of userinput string

trailingWhiteSpaceCheck:
      beq $s1, 9, trailingWhiteSpaceCounter # if the char is a tab we have to give special consideration
      beq $s1, 32, trailingWhiteSpaceCounter # 32 = space char, 9 = tab char
      beq $s1, 0, skip # 0 = null char
      beq $s1, 59, calculateMemoryAdress
      # if after first 4 chars there is any other char go to error and end
      j errorMessage

trailingWhiteSpaceCounter:

    add $t6, $t6, 1
    j skip

calculateMemoryAdress:

     # sub $t5, $t5, 1
      # we need to pass memory address of string to function
      # memory address stored in $a2
      # --------------------
      # move
      # sub $a3, $a2, 4 # memory address of 4 char str - 5 is now stored in s3 <- correct memory address if no trailing white space
      bgt $t6, 0, trailingWhiteSpaceMemoryAddress

      sub $a3, $a2, 5
      move $a0, $a3
      # a3 holds memory address argument
      j sub_a
trailingWhiteSpaceMemoryAddress:
    sub $a2, $a2, $t6 # if there is trailing whitespace ned to find correct memory address
    sub $a3, $a2, 5
    move $a0 $a3
    j sub_a

sub_a:
    # a3 has original memory address & t4 has length of string
    # semi colon memory address = a3 + t4
    # if semicolon address > a3 + t4 then we need to jal
    # find memory address of substrings and pass it to sub_b
    jal sub_b


    
sub_b:
    # sub b is supposed to have memory address of substring
    # do cal culations and return decimal/error message
    j findLength

findLength:
      lb $s6 0($s4)
      beq $s6, 10, exponent # if char equals line feed we know how long the string is so we know what exponent we need to use
      beq $s6, 59, exponent # if char equals ; we know how long the string is and do calculations
      beq $s6, 32, verify # if char is a space character verify if it is apart of input string or trailing white space
      beq $s6, 9, verify
      addi $t4, $t4, 1 # add 1 to t4
      addi $s4, $s4, 1
      j findLength

verify:
    beq $t4, 4, exponent # if space is found and legth is already 4 we know it is a trailing whitespace
    blt $t4, 4, makeSureAllOtherCharsRBlank # if the length of string is less than 4 and i find a space or tab char the char next to it HAS to be another space or it is automatically invalid

makeSureAllOtherCharsRBlank:
    addi $s4, $s4, 1 # going to check character right next to space char
    lb $s5, 0($s4) # s5 is new feed s6 is space
    # sub $a3, $a3, 1 # have to subtract memory address again to keep correct val
    beq $s5, 32, findLength # if character next to it is space then go back to findlength
    beq $s5, 9, findLength # if character next to it is space then go back to findlength
    beq $s5, 10, exponent # if character next to it is space then go back to findlength
    j errorMessage


skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while
exit:
      li $v0, 10
      syscall