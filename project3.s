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
      li $t3, 33 # base for my program
      li $t4, 0 # length counter
      li $t5, 0 # leading white space counter
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

