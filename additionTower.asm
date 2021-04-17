# Bushra Hameed
# CS 3340.502

.data
answerList: 	.word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
questionList: 	.word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
map:		.word 0xffff7C20, 0xffff7C60, 0xffff7CA0, 0xffff7CE0, 0xffff7D20, 0xffff7D60, 0xffff7DA0, 0xffff6C40, 0xffff6C80, 0xffff6CC0, 0xffff6D00, 0xffff6D40, 0xffff6D80, 0xffff5C60, 0xffff5CA0, 0xffff5CE0, 0xffff5D20, 0xffff5D60, 0xffff4C80, 0xffff4CC0, 0xffff4D00, 0xffff4D40, 0xffff3CA0, 0xffff3CE0, 0xffff3D20, 0xffff2CC0, 0xffff2D00, 0xffff1CE0
rows:		.word 5
list:		.word 100,0,70,10,20,0,2,0,12,38,0,1,7,0,3
numColor:	.word 0xD991FF #blue
charColor:	.word 0x000000 #black	      
prompt: 	.asciiz "\nend"
newlineChar: 	.asciiz "\n"
space:		.asciiz " "
instructPrompt: .asciiz "\nChoose a character: "
answerPrompt: 	.asciiz "\nEnter the value for this slot: "
incorrectMsg: 	.asciiz "\nThe answer is incorrect. Try again." 
incorrectChar: 	.asciiz "\nPlease select a valid character."
winMsg:		.asciiz "\nYOU WIN!" 
Letter:		.word   'A','B','C','D','E','F','G','H','I','J'
validChar:	.word 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0

duration100:	.word 0x100
duration50:	.word 0x80
duration150:	.word 0x180 
duration300:	.word 0x300
instrument1: 	.byte 01
instrument2: 	.byte 58

volume25:	.byte 32
volume100: 	.byte 127

pitchF: 	.byte 53
pitchG: 	.byte 55
pitchAb: 	.byte 56
pitchBb: 	.byte 58
pitchE: 	.byte 52
pitchD: 	.byte 50
pitchFLow: 	.byte 53
pitchCLow: 	.byte 48
pitchFHigh: 	.byte 65 
pitchEbHigh:	.byte 63
pitchC: 	.byte 60
pitchDb: 	.byte 61
pitchCLowLow:	.byte 24
pitchGLow: 	.byte 43
pitchEHigh: 	.byte 64

.text
Main:

jal DisplayBox
jal LoopRNG

Exit0: 
	addi $s0,$zero,1 # set $s0 to 1
	addi $t7, $zero, 7
	addi $t8, $zero, 6
	jal LoopL2_L7

Exit2:
	addi $s0,$zero,0 
	add $t2, $zero, $zero # set $t2 to 0
	addi $s1, $zero, 0
	jal Question
	
ExitQ:
li $v0,33
lbu $a0, pitchF
lw $a1, duration100
lbu $a2, instrument1
lbu $a3, volume100
syscall
lbu $a0, pitchG
syscall
lbu $a0, pitchAb
syscall
#1-2
lbu $a0, pitchBb
syscall
lbu $a0, pitchAb
syscall
lbu $a0, pitchG
syscall
lbu $a0, pitchF
syscall
lbu $a0, pitchF
syscall
lbu $a0, pitchE
syscall
lbu $a0, pitchF
syscall
lbu $a0, pitchG
syscall
# 1-3
lbu $a0, pitchF
syscall
lw $a1, duration300
lbu $a0, pitchE
syscall

StartGame:
	addi $t3, $zero, 0
	addi $t7, $zero, 28
	addi $s0, $zero, 27
	addi $t6, $zero, 3
	addi $t8, $zero, 1

	jal LoopLines

Exit3:

	beq $s7, 10, EndGame
		li $v0,  4
		la $a0,  instructPrompt
	syscall    # display the prompt         
	li $v0,  12

	syscall    # read in a character
	add $a0, $v0, $zero

	jal GetChar
ExitChar:
	li $v0,  4
	la $a0,  answerPrompt
	syscall             # display the prompt
	li $v0,  5
	syscall             # read in an integer
	add $a0, $v0, $zero # move to $a0
	jal CheckAnswer
    
InCorrectA:
	li $v0,33
lw $a1, duration50
lbu $a3, volume100
lbu $a2, instrument2
lbu $a0, pitchFLow
syscall
lbu $a3, volume25
lbu $a0, pitchCLow
syscall
lbu $a3, volume100
lbu $a0, pitchFLow
syscall
lbu $a3, volume25
lbu $a0, pitchCLow
syscall
    	li $v0,  4
	la $a0,  incorrectMsg
	syscall             # display error message
	j StartGame
	
EndGame:	
	li $v0,  4
	la $a0,  winMsg
	syscall  
	
		
	#else exit
	li $v0, 10       #set $v0 for exit system call
	syscall	
	
LoopRNG:

	beq $s0, 7, Exit0 # i<= 5 while loop
	Reroll:
		beq $t0, 5, Exit1
		addi $v0, $zero, 42        # Syscall 42: Random int range
		add $a0, $zero, $zero   # Set RNG ID to 0
		addi $a1, $zero, 10     # Set upper bound to 10 (exclusive)
		syscall                  # Generate a random number and put it in $a0
		add $s1, $zero, $a0     # Copy the random number to $s1
		addi $t0, $t0, 1 
		j Reroll
Exit1:
	add $t2, $zero, $zero
	
	addi $t0, $zero, 0
	la $s3, answerList         # put address of questionList into $t3
   	add $t2, $t2, $s0           # put the index into $t2
   	sll $t2, $t2, 2
   	add $t1, $t2, $s3    # combine the two components of the address
   	sw $s1, 0($t1)       # store to array from the array cell
	la $s4, questionList 	
	add $t1, $t2, $s4    # combine the two components of the address
	sw $s1, 0($t1)       # store to array from the array cell	
	
	add $s0, $s0, 1 # i++
	add $t2, $zero, $zero # reset $t2
	
	j LoopRNG #loop to top
	
LoopL2_L7: # make remaining lines t=s+(s-1)
	
	
	beq $s0, 28, Exit2 # i<= 5 while loop
	bne $s0, $t7, Else
	add $t7, $t7, $t8	
	addi $t8, $t8, -1
	j Skip 
	


Else:	
    add $t2, $t2, $s0           # put the index into $t2
    sll $t2, $t2, 2
    add $t1, $t2, $s3    # combine the two components of the address
    lw $t4, 0($t1)       # store to array from the array cell
    add $t2, $zero, $zero # reset $t2
	add $t5, $s0, -1 # $t5 = ($s0 -1)
	add $t2, $t2, $t5           # put the index into $t2
    sll $t2, $t2, 2
    add $t1, $t2, $s3    
    lw $t6, 0($t1)       
    add $t2, $zero, $zero # reset $t2
    add $t5, $s0, $t8 	#set up for next line 6_9
    add $s1, $t4, $t6 
    
    #load to answerList 
    add $t2, $t2, $t5   # put the index into $t2
    mul $t2, $t2, 4
    
    add $t1, $t2, $s3   
    sw $s1, 0($t1)    
      
   #load to questionList
  	 # reset $t2
   	add $t2, $zero, $zero 
   	
   	# put the index into $t2
	add $t2, $t2, $t5     
	mul $t2, $t2, 4 
	  
	add $t1, $t2, $s4    
	sw $s1, 0($t1)  
	
	        
Skip:
	add $s0, $s0, 1 	# i++
	add $t2, $zero, $zero   # reset $t2
	j LoopL2_L7	        #loop to top	

LoopLines:
addi $t4, $zero, 7
beq $t3, $t4, Exit3
li $v0, 4 
la $a0, newlineChar # load address of prompt into $a0
syscall
sub $t4, $t4, $t3
Space:  ble $t4,0 ,LoopL6
li $v0, 4 
la $a0, space # load address of prompt into $a0
syscall
subi $t4, $t4 , 1
j Space


LoopL6:
	jal PrintIntegers
	jal DrawGrid


	beq $s0, $t7, ExitL6 # i<= 5 while loop

	jal Spacing
	PSpacing:
	j QType
	
	

	ValidAnsw:
		add $t2, $zero, $zero # reset $t2
    		add $t2, $t2, $s0     # put the index into $t2
		sll $t2, $t2, 2
    		add $t1, $t2, $s4     
    		lw $t4, 0($t1)        # load from array from the array cell
		li $v0, 1 	      
		move $a0, $t4 	      # move value to be printed to $a0
		syscall	
		
BadQ:
	li $v0, 4 
	la $a0, space 
	syscall
	
	add $s0, $s0, 1 # i++
	add $t2, $zero, $zero # reset $t2
	
	j LoopL6 #loop to top
	
ExitL6: #exit
	sub $t7, $t7, $t8
	sub $s0, $s0, $t6
	addi $t8, $t8, 1
	addi $t6, $t6, 2

addi $t3,$t3,1 #j++

j LoopLines

Question: #set Char to questionList
	la $s4, questionList 
	la $s2, Letter

	beq $s0, 30, ExitQ 
		add $t2, $t2, $s1     # put the index into $t2
		sll $t2, $t2, 2  	
		add $t1, $t2, $s2     
		lw $t4, 0($t1)        
	add $t2, $zero, $zero 	      # reset $t2	
		add $t2, $t2, $s0     # put the index into $t2
		sll $t2, $t2, 2  	
		add $t1, $t2, $s4     
	add $t3, $t4, $zero
		sw $t3, 0($t1)        
		add $s0, $s0, 3       # i++
		addi $s1, $s1, 1      # i++
		add $t2, $zero, $zero # reset $t2
j Question


QType: 

	
	# determine whether to print an integer or character 
	add $t2, $zero, $zero # reset $t2
	
	#load to answerList 
	# put the index into $t2
   	add $t2, $t2, $s0          
    	sll $t2, $t2, 2
    	
    	add $t1, $t2, $s3  
    	# store to array from the array cell     
    	lw $t5, 0($t1)  
    	     
  	# load to questionList	
	add $t1, $t2, $s4   
	
	# store to array from the array cell
	lw $t0, 0($t1)    
	   
		add $t2, $zero, $zero # reset $t2
	
beq $t5,$t0, ValidAnsw

   	add $t2, $t2, $s0           
	sll $t2, $t2, 2
   	add $t1, $t2, $s4    
   	lw $t4, 0($t1)  
    	li $v0, 11 
    	move $a0, $t4 
    	
	syscall
	
	j BadQ



GetChar: 
	bne $a0, 'A',C1
		C0:addi $s0, $zero, 0 #k=A 
	j ExitChar
		C1:bne $a0, 'B',C2
		addi $s0, $zero, 3 #k=B 
	j ExitChar
		C2:bne $a0, 'C',C3
		addi $s0, $zero, 6 #k=C 
	j ExitChar
		C3:bne $a0, 'D',C4
		addi $s0, $zero, 9 #k=D 
	j ExitChar
		C4:bne $a0, 'E',C5
		addi $s0, $zero, 12 #k=E 
	j ExitChar
		C5:bne $a0, 'F',C6
		addi $s0, $zero, 15 #k=F 
	j ExitChar
		C6:bne $a0, 'G',C7
		addi $s0, $zero, 18 #k=G
	j ExitChar
		C7:bne $a0, 'H',C8
		addi $s0, $zero, 21 #k=H 
	j ExitChar
		C8:bne $a0, 'I',C9
		addi $s0, $zero, 24 #k=I 
	j ExitChar
		C9:bne $a0, 'J',WrongChar
		addi $s0, $zero, 27 #k=J 
	j ExitChar
	
WrongChar: 
li $v0,33
lbu $a3, volume100
lbu $a2, instrument2
lw $a1, duration50
lbu $a0, pitchCLowLow
syscall
lbu $a3, volume25
lbu $a0, pitchCLow
syscall
lbu $a3, volume100
lbu $a0, pitchGLow
syscall
lbu $a3, volume25
lbu $a0, pitchCLow
syscall
	li $v0,  4
	la $a0,  incorrectChar
	syscall  
	 
	j Exit3
	
CheckAnswer:
	add $t2, $t2, $s0    	# value is put into $t2
	sll $t2, $t2, 2
	add $t1, $t2, $s3   	 # add into a single address
	lw $t4, 0($t1) 
	
	bne $a0, $t4, InCorrectA
    		add $t1, $t2, $s4    # add into a single address
    		sw $t4, 0($t1)
    		addi $s7, $s7, 1
    		
    		la $t1, validChar
    		add $t1, $t1, $t2
    		
    		li $t2, 1
    		sw $t2, 0($t1)
    		
    		
    		
    		li $v0,33
lbu $a3, volume100
lbu $a2, instrument1
lw $a1, duration50
lbu $a0, pitchAb
syscall
lw $a1, duration150
lbu $a0, pitchC
syscall
    	
    	#ctrlf here
 	j StartGame   
 	
	.text

		
PrintIntegers:
	addi $sp, $sp -40
	sw $ra 0($sp)
	sw $t0 4($sp)
	sw $t1 8($sp)
	sw $t7 12($sp)
	sw $t8 16($sp)
	sw $t9 20($sp)
	sw $a0 24($sp)
	sw $a1 28($sp)
	sw $t6,32($sp)
	sw $t2,36($sp)
	
	# load the array 
	la $t9, questionList
	la $t8, map
	la $t2, validChar
	li $t7, 0
	


	# traverse through the array
	loop:
		li $t6, 10
		li $t5, 100
		beq $t7, 28, endLabel
		lw $a1, 0($t9)
		lw $a0, 0($t8)
		lw $a2, 0($t2)
		addi $t9, $t9, 4
		addi $t8, $t8, 4
		addi $t2, $t2, 4
		addi $t7, $t7, 1
			

			beq $a2, 0, exitMini
			bge $a1, $t5, doThree
			bge $a1, $t6, doTwo
			blt $a1, $t6, doOne
			
			j exitMini
			
			doThree:
			jal threeDigits
			j exitMini
			
			doOne: 
			jal printOneNum
			j exitMini
			
			doTwo:
			jal printTwoNums
			j exitMini
			
		
		exitMini:
		
		j loop
		
	
		
	endLabel:
		
		lw $ra 0($sp)
		lw $t0 4($sp)
		lw $t1 8($sp)
		lw $t7 12($sp)
		lw $t8 16($sp)
		lw $t9 20($sp)
		lw $a0 24($sp)
		lw $a1 28($sp)
		lw $t6,32($sp)
		lw $t2,36($sp)
		addi $sp, $sp 40
		jr $ra
	
		
	
printOneNum:

	add $s5, $a1, $zero
	
	subi $a0, $a0, 3052
	bne $s5, 0,B1	
	j ZERO
	
	B1:bne $s5, 1, B2
	j ONE
	
	B2: bne $s5, 2, B3	
	j TWO
	
	B3: bne $s5, 3, B4	
	j THREE
	
	B4: bne $s5, 4, B5
	j FOUR
	
	B5: bne $s5, 5, B6
	j FIVE
	
	B6: bne $s5, 6, B7
	j SIX
	
	B7: bne $s5, 7, B8	
	j SEVEN
	
	B8: bne $s5, 8, B9	
	j EIGHT
	
	B9: bne $s5, 9, exitLoop
	j NINE
	
	exitLoop: 
	jr $ra	
	
printTwoNums:
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $s6, 4($sp)
sw $s5, 8($sp)


	add $s5, $a1, $zero
	li $t5, 100
	div $s5, $t5
	mfhi $s6
	mflo $t0
	
	li $t5, 10
	div $s6, $t5
	mfhi $t0
	mflo $s5

		
	#For the seconds place
	subi $a0, $a0, 3060
	bne $s5, 0,B1.2		
	jal ZERO
	j exitLoop.3b
	
	B1.2:bne $s5, 1, B2.2
	jal ONE
	
	j exitLoop.3b
	
	B2.2: bne $s5, 2, B3.2
	jal TWO
	
	j exitLoop.3b
	
	B3.2: bne $s5, 3, B4.2
	jal THREE
	
	j exitLoop.3b
	
	B4.2: bne $s5, 4, B5.2
	jal FOUR
	
	j exitLoop.2
	
	B5.2: bne $s5, 5, B6.2
	jal FIVE
	
	j exitLoop.2
	
	B6.2: bne $s5, 6, B7.2
	jal SIX
	
	j exitLoop.2
	
	B7.2: bne $s5, 7, B8.2
	jal SEVEN
	
	j exitLoop.2
	
	B8.2: bne $s5, 8, B9.2	
	jal EIGHT
	
	j exitLoop.2
	
	B9.2: bne $s5, 9, exitLoop.2
	jal NINE
	
	j exitLoop.2
	
	exitLoop.2:
	
	
	
	li $t5, 10
	div $s6, $t5
	mfhi $s5
	mflo $t0


	
	addi $a0, $a0, 3060
	#For the second place
	subi $a0, $a0, 3040
	bne $s5, 0,B1.3c		
	jal ZERO
	j exitLoop.3c
	
	B1.2b:bne $s5, 1, B2.2b
	jal ONE
	
	j exitLoop.2b
	
	B2.2b: bne $s5, 2, B3.2b
	jal TWO
	
	j exitLoop.2b
	
	B3.2b: bne $s5, 3, B4.2b
	jal THREE
	
	j exitLoop.2b
	
	B4.2b: bne $s5, 4, B5.2b
	jal FOUR
	
	j exitLoop.2b
	
	B5.2b: bne $s5, 5, B6.2b
	jal FIVE
	
	j exitLoop.2b
	
	B6.2b: bne $s5, 6, B7.2b
	jal SIX
	
	j exitLoop.2b
	
	B7.2b: bne $s5, 7, B8.2b
	jal SEVEN
	
	j exitLoop.2b
	
	B8.2b: bne $s5, 8, B9.2b	
	jal EIGHT
	
	j exitLoop.2b
	
	B9.2b: bne $s5, 9, exitLoop.2b
	jal NINE
	
	j exitLoop.2b
	
	exitLoop.2b:

lw $ra, 0($sp)
lw $s6, 4($sp)
lw $s5, 8($sp)
addi $sp, $sp, 12
jr $ra	

# print three digit numbers
threeDigits:
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $s6, 4($sp)
sw $s5, 8($sp)

li $t5, 100
li $t6, 10


	add $s5, $a1, $zero 
	div $a1, $t5	# a1/100
	
	
	mfhi $s6 
	mflo $t0	# quotient value

	
	
	# first digit					
	subi $a0, $a0, 3072
	bne $t0, 0,B1.3	
	jal ZERO	
	j exitLoop.3
	
	B1.3:bne $t0, 1, B2.3
	jal ONE
	
	j exitLoop.3
	
	B2.3: bne $t0, 2, B3.3	
	jal TWO
	
	j exitLoop.3
	
	B3.3: bne $t0, 3, B4.3	
	jal THREE
	
	j exitLoop.3
	
	B4.3: bne $t0, 4, B5.3
	jal FOUR
	
	j exitLoop.3
	
	B5.3: bne $t0, 5, B6.3
	jal FIVE
	
	j exitLoop.3
	
	B6.3: bne $t0, 6, B7.3
	jal SIX
	
	j exitLoop.3
	
	B7.3: bne $t0, 7, B8.3
	jal SEVEN
	
	j exitLoop.3
	
	B8.3: bne $t0, 8, B9.3	
	jal EIGHT
	
	j exitLoop.3
	
	B9.3: bne $t0, 9, exitLoop.3
	jal NINE
	
	j exitLoop.3
	exitLoop.3:


	li $t5, 100
	div $s5, $t5
	mfhi $s6
	mflo $t0
	
	li $t5, 10
	div $s6, $t5
	mfhi $t0
	mflo $s5

	
	addi $a0, $a0, 3072	
	# second digit
	subi $a0, $a0, 3052
	bne $s5, 0,B1.3b		
	jal ZERO
	j exitLoop.3b
	
	B1.3b:bne $s5, 1, B2.3b
	jal ONE
	
	j exitLoop.3b
	
	B2.3b: bne $s5, 2, B3.3b
	jal TWO
	
	j exitLoop.3b
	
	B3.3b: bne $s5, 3, B4.3b
	jal THREE
	
	j exitLoop.3b
	
	B4.3b: bne $s5, 4, B5.3b
	jal FOUR
	
	j exitLoop.3b
	
	B5.3b: bne $s5, 5, B6.3b
	jal FIVE
	
	j exitLoop.3b
	
	B6.3b: bne $s5, 6, B7.3b
	jal SIX
	
	j exitLoop.3b
	
	B7.3b: bne $s5, 7, B8.3b
	jal SEVEN
	
	j exitLoop.3b
	
	B8.3b: bne $s5, 8, B9.3b	
	jal EIGHT
	
	j exitLoop.3b
	
	B9.3b: bne $s5, 9, exitLoop.3b
	jal NINE
	
	j exitLoop.3b
	
	exitLoop.3b:
	
	
	# third digit
	li $t5, 10
	div $s6, $t5
	mfhi $s5
	mflo $t0


	
	addi $a0, $a0, 3052
	# second digit
	subi $a0, $a0, 3032
	bne $s5, 0,B1.3c		
	jal ZERO
	j exitLoop.3c
	
	B1.3c:bne $s5, 1, B2.3c
	jal ONE
	
	j exitLoop.3c
	
	B2.3c: bne $s5, 2, B3.3c
	jal TWO
	
	j exitLoop.3c
	
	B3.3c: bne $s5, 3, B4.3c
	jal THREE
	
	j exitLoop.3c
	
	B4.3c: bne $s5, 4, B5.3c
	jal FOUR
	
	j exitLoop.3c
	
	B5.3c: bne $s5, 5, B6.3c
	jal FIVE
	
	j exitLoop.3c
	
	B6.3c: bne $s5, 6, B7.3c
	jal SIX
	
	j exitLoop.3c
	
	B7.3c: bne $s5, 7, B8.3c
	jal SEVEN
	
	j exitLoop.3c
	
	B8.3c: bne $s5, 8, B9.3c	
	jal EIGHT
	
	j exitLoop.3c
	
	B9.3c: bne $s5, 9, exitLoop.3c
	jal NINE
	
	j exitLoop.3c
	
	exitLoop.3c:

lw $ra, 0($sp)
lw $s6, 4($sp)
lw $s5, 8($sp)
addi $sp, $sp, 12
jr $ra	





										
DrawGrid:
	
	move $s1, $ra
	#ROW 7 FROM THE TOP
	#Row 7 box 1
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31776 #offset (128 * 4 * 62(rows)) + (4*8 columns) 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31776
	jal	vertical
	jal	horizontal
	
	#Row 7 box 2
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31840 # add 64 to 'Row 7 box 1'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31840
	jal	vertical
	jal	horizontal
	
	#Row 7 box 3
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31904 # add 64 to 'Row 7 box 2'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31904
	jal	vertical
	jal	horizontal
	
	#Row 7 box 4
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31968 # add 64 to 'Row 7 box 3'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 31968
	jal	vertical
	jal	horizontal
	
	#Row 7 box 5
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32032 # add 64 to 'Row 7 box 4'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32032
	jal	vertical
	jal	horizontal
	
	#Row 7 box 6
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32096 # add 64 to 'Row 7 box 5'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32096
	jal	vertical
	jal	horizontal
	
	#Row 7 box 7
	li	$a2, 0x00F0F0
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32160 # add 64 to 'Row 7 box 6'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 32160
	jal	vertical
	jal	horizontal
	
	
	#ROW 6 FROM THE TOP
	#Row 6 box 1
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27712 # offset (128 * 4 * 54(rows)) + (4*16 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27712
	jal	vertical
	jal	horizontal
	
	#Row 6 box 2
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27776 # add 64 to 'Row 6 box 1'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27776
	jal	vertical
	jal	horizontal
	
	#Row 6 box 3
	li	$a2, 0x00F0F0
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27840 # add 64 to 'Row 6 box 2'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27840
	jal	vertical
	jal	horizontal
	
	#Row 6 box 4
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27904 # add 64 to 'Row 6 box 3'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27904
	jal	vertical
	jal	horizontal
	
	#Row 6 box 5
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27968 # add 64 to 'Row 6 box 4'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 27968
	jal	vertical
	jal	horizontal
	
	#Row 6 box 6
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 28032 # add 64 from 'Row 6 box 5'
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 28032
	jal	vertical
	jal	horizontal
	
	#ROW 5 FROM THE TOP
	#Row 5 box 1
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23648 #offset (128 * 4 * 46(rows)) + (4*18 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23648
	jal	vertical
	jal	horizontal
	
	#Row 5 box 2
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23712 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23712
	jal	vertical
	jal	horizontal
	
	#Row 5 box 3
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23776 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23776
	jal	vertical
	jal	horizontal
	
	#Row 5 box 4
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23840 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23840
	jal	vertical
	jal	horizontal
	
	#Row 5 box 5
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23904 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 23904
	jal	vertical
	jal	horizontal
	
	#ROW 4 FROM TOP
	#Row 4 box 1
	li	$a2, 0x00F0F0
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19584 #offset (128 * 4 * 31(rows)) + (4*23 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19584
	jal	vertical
	jal	horizontal
	
	#Row 4 box 2
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19648 #offset (128 * 4 * 31(rows)) + (4*23 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19648
	jal	vertical
	jal	horizontal
	
	#Row 4 box 3
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19712 #offset (128 * 4 * 31(rows)) + (4*23 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19712
	jal	vertical
	jal	horizontal
	
	#Row 4 box 4
	li	$a2, 0x00F0F0	
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19776 #offset (128 * 4 * 31(rows)) + (4*23 columns) for box1
	li	$a1, 8		
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 19776
	jal	vertical
	jal	horizontal
	
	#ROW 3 FROM TOP
	#Row 3 box 1
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15520 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15520
	jal	vertical
	jal	horizontal
	
	#Row 3 box 2
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15584 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15584
	jal	vertical
	jal	horizontal
	
	#Row 3 box 3
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15648 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 15648
	jal	vertical
	jal	horizontal
	
	#ROW 2 FROM TOP		
	#Row 2 box 1
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 11456 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 11456
	jal	vertical
	jal	horizontal

	#Row 2 box 2
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 11520 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 11520
	jal	vertical
	jal	horizontal
	
	#ROW 1 FROM TOP
	#Row 1 box 1
	li	$a2, 0x00F0F0	# color
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 7392 
	li	$a1, 8		#vertical height
	jal	horizontal
	jal	vertical
	li	$a3, 0xFFFF0000
	addi	$a3, $a3, 7392
	jal	vertical
	jal	horizontal
	move 	$ra, $s1
	jr	$ra
	


# $a3: start position
# $a1: length of the line
# $a2 - color
horizontal:
	li	$t0, 0
	li $t1, 16 #horizontal length
horizontalLoop:
	sw	$a3, 0($a3)
	addi	$a3, $a3, 4 #increment
	addi	$t0, $t0, 1
	bne	$t0, $t1, horizontalLoop
	jr	$ra

# $a3: starting point
# $a1: height
# $a2: color
vertical:
	li	$t0, 0
	move	$t1, $a1
verticalLoop:
	sw	$a3, 0($a3)
	subi	$a3, $a3, 512
	addi	$t0, $t0, 1
	bne	$t0, $t1, verticalLoop
	jr	$ra
	
#Main
		la $s0, list #load the address of list
		lw $s1, rows #load the content of rows
		li $a0, 0xffff0810
		jal ONE
		li $a0, 0xffff0824 # +20 -> 0x14
		jal TWO
		li $a0, 0xffff0838 
		jal THREE
		li $a0, 0xffff084C 
		jal FOUR
		li $a0, 0xffff0860 
		jal FIVE
		li $a0, 0xffff0874 
		jal SIX
		li $a0, 0xffff0888 
		jal SEVEN
		li $a0, 0xffff089C 
		jal EIGHT
		li $a0, 0xffff08B0 
		jal NINE
		li $a0, 0xffff08C4 
		jal ZERO
		li $a0, 0xffff1610 # +3584 -> 0xE00
		
		
	
#One:
# ---0-
# --00-
# ---0-
# ---0-
# ---0-
# --000
ONE:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 12   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #2
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #3
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #4
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #5
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #6
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
				
		jr $ra
#Two:
# --00-
# -0--0
# ----0
# ---0-
# --0--
# -0000
TWO:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 8   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 504  #2
		sw $t1, 0($t0)
		addi $t0, $t0, 12
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #3
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #4
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #5
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #6
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		
		jr $ra
#Three:
# -0000
# ---0-
# --0--
# ---0-
# ----0
# -000-
THREE:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 4   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #2
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #3
		sw $t1, 0($t0)
		addi $t0, $t0, 516  #4
		sw $t1, 0($t0)
		addi $t0, $t0, 516  #5
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #6
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		
		jr $ra
#Four:
# ----0
# ---00
# --0-0
# -0000
# ----0
# ----0
FOUR:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 16    #1
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #2
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 504  #3
		sw $t1, 0($t0)
		addi $t0, $t0, 8
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #5
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #6
		sw $t1, 0($t0)
		
		jr $ra
#Five:  
# -0000
# -0---
# -000-
# ----0
# ----0
# -000-
FIVE:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 4   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #2   
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #3   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 516  #4 
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #5   
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #6   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		
		jr $ra
#Six: 
# --000
# -0---
# -000-
# -0--0
# -0--0
# --00-
SIX:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 8   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #2  
		sw $t1, 0($t0) 
		addi $t0, $t0, 512  #3   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 504  #4
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 500  #5
		sw $t1, 0($t0)
		addi $t0, $t0, 12  
		sw $t1, 0($t0)
		addi $t0, $t0, 504  #6  
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		
		jr $ra
#Seven:
# -0000
# ----0
# ---0-
# --0--
# --0--
# --0--
SEVEN:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 4   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #2   
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #3   
		sw $t1, 0($t0)
		addi $t0, $t0, 508  #4   
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #5   
		sw $t1, 0($t0)
		addi $t0, $t0, 512  #6   
		sw $t1, 0($t0)
		
		jr $ra
#Eight:
# --00-
# -0--0
# --00-
# -0--0
# -0--0
# --00-
EIGHT:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 8   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #2   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #3   
		sw $t1, 0($t0)
		addi $t0, $t0, 4  
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #4   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 500 #5   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #6   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		
		jr $ra
#Nine:
# --00-
# -0--0
# -0--0
# --000
# ----0
# ----0
NINE:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 8   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #2   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 500 #3   
		sw $t1, 0($t0)
		addi $t0, $t0, 12  
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #4  
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 512 #5   
		sw $t1, 0($t0)
		addi $t0, $t0, 512 #6   
		sw $t1, 0($t0)
		
		jr $ra
#Zero:
# --00-
# -0--0
# -0-00
# -00-0
# -0--0
# --00-
ZERO:		move $t0, $a0
		lw $t1, numColor
		addi $t0, $t0, 8   #1
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #2   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 500 #3  
		sw $t1, 0($t0)
		addi $t0, $t0, 8   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 500 #4   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		addi $t0, $t0, 8   
		sw $t1, 0($t0)
		addi $t0, $t0, 500 #5   
		sw $t1, 0($t0)
		addi $t0, $t0, 12   
		sw $t1, 0($t0)
		addi $t0, $t0, 504 #6   
		sw $t1, 0($t0)
		addi $t0, $t0, 4   
		sw $t1, 0($t0)
		
		jr $ra
DisplayBox:
	move $s1, $ra
	
	
	#Row 7 box 1- 
	li $a0, 0xffff7038
	jal BOX
		
	#Row 7 box 4- Cell 'B'
	li $a0, 0xffff70F4
	jal BOX
	
	#Row 7 box 7- Cell 'C'
	li $a0, 0xffff71B4
	jal BOX
	
	#Row 6 box 3- Cell 'D'
	li $a0, 0xffff60D4
	jal BOX
	
	#Row 6 box 6- Cell 'E'
	li $a0, 0xffff6194
	jal BOX
	
	#Row 5 box 3- Cell 'F'
	li $a0, 0xffff50F4
	jal BOX
	
	#Row 4 box 1- Cell 'G'
	li $a0, 0xffff4094
	jal BOX
	
	#Row 4 box 4- Cell 'H'
	li $a0, 0xffff4154
	jal BOX

	#Row 3 box 3- Cell 'I'
	li $a0, 0xffff3134
	jal BOX

	#Row 1 box 1- Cell 'J'
	li $a0, 0xffff10F4
	jal BOX

	move $ra, $s1
	jr $ra 
	

exit:
# 5 wide 6 tall

BOX:	
move $t0, $a0
		lw $t1, charColor
	
		#15
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		#Next Row 2
		addi $t0, $t0, 456
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		#Next Row 3
		addi $t0, $t0, 456
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		#Next Row 4
		addi $t0, $t0, 456
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		#Next Row 5
		addi $t0, $t0, 456
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		#Next Row 6
		addi $t0, $t0, 456
		sw $t1, 0($t0) #1
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #5
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #10
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0)
		addi $t0, $t0, 4
		sw $t1, 0($t0) #15
		
		jr $ra

 Spacing:	# if # is <10 add space
add $t2, $zero, $zero # reset $t2
add $t2, $t2, $s0     # put the index into $t2
sll $t2, $t2, 2
add $t1, $t2, $s4    
lw $t4, 0($t1) 
bge  $t4, 10, PSpacing    #PSpacing: pyramid spacing
li $v0, 4 
la $a0, space 
syscall
 j PSpacing 	

end:
