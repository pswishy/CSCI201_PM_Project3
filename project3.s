

.text

# t0 has num of subtrings
while:
# find how many substrings and the length of each one
    lb $s1 0($t9)

    # abcd; abcd;   abcd;
    beq $t1, 1000, finshedcountingnumofsubstrings
    beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration
    beq $s1, 32, tabOrSpaceCharFound # 32 = space char, 9 = tab char
      # if we get here we are at a char and no more leading whitespace
    beq $s1, 59, subStringCounter
    addi $t0,$t0, 1 # increment length of user string by 1
    addi $t1, $t1, 1 # increment loop
    addi $t9, $t9, 1 # increment loop address for loop
    move $a2, $t9 # will hold memory address of 4th char 
    j while

subStringCounter:

    add $t0, $t0, 1 # increment number of substrings
    add $t9, $t9, 1 # increment loop address
    