################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Oscar Heath, 1009962373
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
# Store our 3 colours in an array
COLOURS:
    .word
    0xf5e137, 0xc51103, 0x0bece1
# Screen Width
WIDTH:
    .word
    64
# Screen Height
HEIGHT:
    .word
    32
# X Coord of first half of capsule
CAPSULE_ONE:
    .word
    0, 0, 0xffffff
# X Coord of second half of capsule
CAPSULE_TWO:
    .word
    0, 0, 0xffffff
# Big array of board
GRID:
    .word
    0xffffff:128

TEST_GRID:
    .word
    -1, -1, -1, -1, -1, -1, -1, -1, 2
##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # TESTS
    # la $a0 TEST_GRID
    # li $a1 0
    # li $a2 1
    # jal GET_ITEM_IN_2D
    
    # add $a0 $zero $v0
    # li $v0 1
    # syscall
    
    # la $a0 TEST_GRID
    # li $a1 0
    # li $a2 1
    # li $a3 69
    # jal SET_ITEM_IN_2D
    
    # la $a0 TEST_GRID
    # li $a1 0
    # li $a2 1
    # jal GET_ITEM_IN_2D
    
    # add $a0 $zero $v0
    # li $v0 1
    # syscall
    
    # Initialize the game
    # DRAW_LINE Boilerplate to draw left side of bottle neck
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 0
    jal PUSH_TO_STACK
    li $a0 4
    jal PUSH_TO_STACK
    li $a0 2
    jal PUSH_TO_STACK
    li $a0 5
    jal PUSH_TO_STACK
    jal DRAW_LINE
    
    # DRAW_LINE Boilerplate to draw right side of bottle neck
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 0
    jal PUSH_TO_STACK
    li $a0 4
    jal PUSH_TO_STACK
    li $a0 2
    jal PUSH_TO_STACK
    li $a0 8
    jal PUSH_TO_STACK
    jal DRAW_LINE
    
    # DRAW_LINE Boilerplate to draw left side of bottle body
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 0
    jal PUSH_TO_STACK
    li $a0 16
    jal PUSH_TO_STACK
    li $a0 6
    jal PUSH_TO_STACK
    li $a0 2
    jal PUSH_TO_STACK
    jal DRAW_LINE

    # DRAW_LINE Boilerplate to draw right side of bottle body
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 0
    jal PUSH_TO_STACK
    li $a0 16
    jal PUSH_TO_STACK
    li $a0 6
    jal PUSH_TO_STACK
    li $a0 11
    jal PUSH_TO_STACK
    jal DRAW_LINE

    # DRAW_LINE Boilerplate to draw bottom of bottle
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 1
    jal PUSH_TO_STACK
    li $a0 10
    jal PUSH_TO_STACK
    li $a0 22
    jal PUSH_TO_STACK
    li $a0 2
    jal PUSH_TO_STACK
    jal DRAW_LINE

    # DRAW_LINE Boilerplate to draw left side connecting neck
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 1
    jal PUSH_TO_STACK
    li $a0 3
    jal PUSH_TO_STACK
    li $a0 6
    jal PUSH_TO_STACK
    li $a0 3
    jal PUSH_TO_STACK
    jal DRAW_LINE

    # DRAW_LINE Boilerplate to draw right side connecting neck
    li $a0 0xffffff
    jal PUSH_TO_STACK
    li $a0 1
    jal PUSH_TO_STACK
    li $a0 3
    jal PUSH_TO_STACK
    li $a0 6
    jal PUSH_TO_STACK
    li $a0 8
    jal PUSH_TO_STACK
    jal DRAW_LINE

    li $t2 0
game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    # jal PILL_DRAW_FUNC
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, RESPOND_TO_INPUT      # If first word 1, key is pressed
    
    
    # This loop draws all of the contens of GRID onto the Bitmap
    li $t0 0        # Set loop counter to 0
    LOOP: beq $t0 128 DRAW_DONE
    
    # COL_LOOP: beq $t0 16 DRAW_DONE
        # li $t1 0        # Set loop counter 2 to 0
        # ROW_LOOP: beq $t1 8 ROW_DONE
            
            # la $a0 GRID
            # add $a1 $zero $t1
            # add $a2 $zero $t0
            # jal STORE_REGISTERS
            # jal GET_ITEM_IN_2D
            # jal RESTORE_REGISTERS

            # add $t2 $zero $v0
            # bgtz $t2 POSITIVE
            # sub $t2 $zero $t2
        # POSITIVE:
            # add $a1 $zero $t1
            # add $a2 $zero $t0
            # add $a3 $t2 $zero

            # jal STORE_REGISTERS
            # jal DRAW_IN_GRID
            # jal RESTORE_REGISTERS
            # add $t1 $t1 1
            # j ROW_LOOP
        # ROW_DONE:
            # addi $t0 $t0 1
        
        
        
    DRAW_DONE:
    j game_loop


DRAW_AT:            
    # $a0 = x coord of position to draw at
    # $a1 = y coord of position to draw at
    # $a2 = rgb colour to draw
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    lw $t1, WIDTH           # $t1 = Width of the screen
    mult $t1 $a1            # hi = Width * y coord
    mflo $t1                # $t1 = hi
    sll $t1 $t1 2           # Multiple $t1 by 4
    sll $t2 $a0 2           # t2 = $a0 * 4
    add $t1 $t1 $t2         # $t1 = coordinate of x, y relative to ADDR_DSPL
    add $t1 $t1 $t0         # $t1 = explicit coordinate of x, y
    sw $a2 0($t1)           # Draw $a3 at $t1
    jr $ra

DRAW_IN_GRID:
    # $a0 = x coord of position to draw at IN GRID
    # $a1 = y coord of position to draw at IN GRID
    # $a2 = rgb colour to draw
    addi $a0 $a0 3
    addi $a1 $a1 7
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    lw $t1, WIDTH           # $t1 = Width of the screen
    mult $t1 $a1            # hi = Width * y coord
    mflo $t1                # $t1 = hi
    sll $t1 $t1 2           # Multiple $t1 by 4
    sll $t2 $a0 2           # t2 = $a0 * 4
    add $t1 $t1 $t2         # $t1 = coordinate of x, y relative to ADDR_DSPL
    add $t1 $t1 $t0         # $t1 = explicit coordinate of x, y
    sw $a2 0($t1)           # Draw $a3 at $t1
    jr $ra

DRAW_LINE:
    # stack[1] = x coord of line start
    # stack[2] = y coord of line start
    # stack[3] = line length
    # stack[4] = line direction (0 for vertical, 1 for horizontal)
    # stack[5] = colour
    # BOILERPLATE:
        # jal STORE_REGISTERS
        # li $a0 COLOUR
        # jal PUSH_TO_STACK
        # li $a0 DIRECTION
        # jal PUSH_TO_STACK
        # li $a0 LENGTH
        # jal PUSH_TO_STACK
        # li $a0 YCOORD
        # jal PUSH_TO_STACK
        # li $a0 XCOORD
        # jal PUSH_TO_STACK
        # jal DRAW_LINE
        # jal RESTORE_REGISTERS
    lw $t1 0($sp)           # Load the top of the stack so $t1 = x coord
    addi $sp $sp 4          # Increment stack pointer
    lw $t2 0($sp)           # Load the next value of the stack so $t2 = y coord
    addi $sp $sp 4          # Increment stack pointer
    lw $t3 0($sp)           # Load the next value of the stack so $t3 = length
    addi $sp $sp 4          # Increment stack pointer
    lw $t4 0($sp)           # Load the next value of the stack so $t4 = direction
    addi $sp $sp 4          # Increment stack pointer
    lw $t5 0($sp)           # Load the next value of the stack so $t5 = colour
    addi $sp $sp 4          # Increment stack pointer
    
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    li $t0 0                # Initialize $t0, our loop counter, at 0
    
    LINE_DRAWING: beq $t0 $t3 LINE_DONE
        add $a0 $zero $t1   # Set $a0 to be x coord
        add $a1 $zero $t2   # Set $a1 to be y coord
        add $a2 $zero $t5   # Set $a2 to be colour
        jal STORE_REGISTERS   # Store contents of registers before calling helper function
        jal DRAW_AT
        jal RESTORE_REGISTERS
        beq $t4 0 IF_VERTICAL
            IF_HORIZONTAL:
                addi $t1 $t1 1
                j INCREMENT_DONE
            IF_VERTICAL:
                addi $t2 $t2 1
        INCREMENT_DONE:
        addi $t0 $t0 1
        j LINE_DRAWING
    LINE_DONE:
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra

STORE_REGISTERS:          # Push the content of all t registers onto the stack, called before all subroutines
    addi $sp $sp -4
    sw $t0 0($sp)
    addi $sp $sp -4
    sw $t1 0($sp)
    addi $sp $sp -4
    sw $t2 0($sp)
    addi $sp $sp -4
    sw $t3 0($sp)
    addi $sp $sp -4
    sw $t4 0($sp)
    addi $sp $sp -4
    sw $t5 0($sp)
    addi $sp $sp -4
    sw $t6 0($sp)
    addi $sp $sp -4
    sw $t7 0($sp)
    addi $sp $sp -4
    sw $t8 0($sp)
    addi $sp $sp -4
    sw $t9 0($sp)
    jr $ra

RESTORE_REGISTERS:     # Restores all of the t registers to their value BEFORE PUSH_TO_STACK was called !important
    lw $t9 0($sp)
    addi $sp $sp 4
    lw $t8 0($sp)
    addi $sp $sp 4
    lw $t7 0($sp)
    addi $sp $sp 4
    lw $t6 0($sp)
    addi $sp $sp 4
    lw $t5 0($sp)
    addi $sp $sp 4
    lw $t4 0($sp)
    addi $sp $sp 4
    lw $t3 0($sp)
    addi $sp $sp 4
    lw $t2 0($sp)
    addi $sp $sp 4
    lw $t1 0($sp)
    addi $sp $sp 4
    lw $t0 0($sp)
    addi $sp $sp 4
    jr $ra

PUSH_TO_STACK:
    # $a0 = elt to push
    addi $sp $sp -4
    sw $a0 0($sp)
    jr $ra

POP_FROM_STACK:
    lw $s0 0($sp)
    addi $sp $sp 4
    
GET_ITEM_AT:
    # $a0 = address of Array to index
    # $a1 = index to get value of
    sll $t0 $a1 2       # Multiply $a1 by 4 and store it in $t0
    add $t1 $a0 $t0     # $t1 = addr(Array) + 4 * i = addr(Array[i]) 
    lw $v0 0($t1)
    jr $ra

SET_ITEM_AT:
    # $a0 = address of Array to index
    # $a1 = index to set value of
    # $a2 = value to set
    sll $t0 $a1 2       # Multiply $a1 by 4 and store it in $t0
    add $t1 $a0 $t0     # $t1 = addr(Array) + 4 * i = addr(Array[i]) 
    sw $a2 0($t1)
    jr $ra


GET_ITEM_IN_2D:
    # $a0 = Array Label
    # $a1 = x coord
    # $a2 = y coord
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    sll $t0 $a2 3       # Multiply the y coord by 8, since that is the width of our 2d array
    add $t0 $t0 $a1     # Add $a0 to $t0
    
    add $a1 $zero $t0
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra
    
SET_ITEM_IN_2D:
    # $a0 = Array Label
    # $a1 = x coord
    # $a2 = y coord
    # $a3 = value to set
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    sll $t0 $a2 3       # Multiply the y coord by 8, since that is the width of our 2d array
    add $t0 $t0 $a1     # Add $a0 to $t0
    
    add $a1 $zero $t0
    add $a2 $zero $a3
    jal STORE_REGISTERS
    jal SET_ITEM_AT
    jal RESTORE_REGISTERS
    
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra

PILL_DRAW_FUNC:
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    la $t0 CAPSULE_ONE      # Store address to Capsule 1 in $t0
    la $t1 CAPSULE_TWO      # Store address to Capsule 2 in $t0
    add $a0 $zero $t0       # Set a0 to be address of Capsule 1
    li $a1 0
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t2 $zero $v0       # Store CAP1[x] in $t2
    bne $t2 -1 ALREADY_PILL
        # If the coordinate of the pill is -1, it means there is no pill, so make a new one by generating random colours
        li $v0 42       # Generating a random number i between 0 and 2, stored in $a0
        li $a0 0
        li $a1 3
        syscall
        add $a1 $zero $a0         # Set $a1 = i
        la $a0 COLOURS            # Store the address of Colours in $t8
        jal STORE_REGISTERS
        jal GET_ITEM_AT           # Set $v0 to be COLOURS[i]
        jal RESTORE_REGISTERS
        add $t6 $v0 $zero# $t6 = COLOURS[i]
        
        # Set CAP2[2] to be the randomly generated colour, and add pill to grid
        add $a0 $zero $t0
        li $a1 2
        add $a2 $t6 $zero
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
        # Set CAP2[0] to be 3, the starter x coord
        li $a1 0
        li $a2 3
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
        # Set CAP2[0] to be 0, the starter y coord
        li $a1 1
        li $a2 0
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
        
        
        la $a0 GRID
        li $a1 3
        li $a2 0
        sub $a3 $zero $t6
        jal STORE_REGISTERS
        jal SET_ITEM_IN_2D
        jal RESTORE_REGISTERS
        
        li $v0 42       # Generating a random number i between 0 and 2, stored in $a0
        li $a0 0
        li $a1 3
        syscall
        add $a1 $zero $a0         # Set $a1 = i
        la $a0 COLOURS            # Store the address of Colours in $t8
        jal STORE_REGISTERS
        jal GET_ITEM_AT           # Set $v0 to be COLOURS[i]
        jal RESTORE_REGISTERS
        add $t6 $v0 $zero# $t6 = COLOURS[i]
        
        # Set CAP2[2] to be the randomly generated colour
        add $t0, $zero $t1      # Set $t0 to be the address of Capsule 2 and repeat
        add $a0 $zero $t0
        li $a1 2
        add $a2 $t6 $zero
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
        # Set CAP2[0] to be 4, the starter x coord
        li $a1 0
        li $a2 4
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
        # Set CAP2[0] to be 0, the starter y coord
        li $a1 1
        li $a2 0
        jal STORE_REGISTERS
        jal SET_ITEM_AT
        jal RESTORE_REGISTERS
    
        la $a0 GRID
        li $a1 4
        li $a2 0
        sub $a3 $zero $t6
        jal STORE_REGISTERS
        jal SET_ITEM_IN_2D
        jal RESTORE_REGISTERS

    ALREADY_PILL:
        la $t0 CAPSULE_ONE      # Store address to Capsule 1 in $t0
        la $t1 CAPSULE_TWO      # Store address to Capsule 2 in $t0
        add $a0 $zero $t0       # Set a0 to be address of Capsule 1
        li $a1 0
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t2 $zero $v0       # Store CAP1[x] in $t2
        li $a1 1
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t3 $zero $v0       # Store CAP1[y] in $t3
        
        li $a1 2
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t6 $zero $v0       # Store CAP1[Colour] in $t6
        
        add $a0 $zero $t1       # Set a0 to be address of Capsule 2
        li $a1 0
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t4 $zero $v0       # Store CAP2[x] in $t4
        li $a1 1
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t5 $zero $v0       # Store CAP2[y] in $t5
        
        li $a1 2
        jal STORE_REGISTERS
        jal GET_ITEM_AT
        jal RESTORE_REGISTERS
        add $t7 $zero $v0       # Store CAP1[Colour] in $t7
        
        add $a0 $t2 $zero
        add $a1 $t3 $zero
        add $a2 $t6 $zero
        jal STORE_REGISTERS
        jal DRAW_IN_GRID
        jal RESTORE_REGISTERS

        add $a0 $t4 $zero
        add $a1 $t5 $zero
        add $a2 $t7 $zero
        jal STORE_REGISTERS
        jal DRAW_IN_GRID
        jal RESTORE_REGISTERS
    
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra

MOVE_DOWN:
    # $a0 = x coord to move
    # $a1 = y coord to move
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    
    
    
    
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra

RESPOND_TO_INPUT:
    lw $a0, 4($t0)                  # Load second word from keyboard
    # li $v0, 1                       # ask system to print $a0
    # syscall
    
    beq $a0 97 RESPOND_TO_A     # Check if A pressed
    beq $a0 100 RESPOND_TO_D    # Check if D pressed
    beq $a0 115 RESPOND_TO_S    # Check if S pressed
    beq $a0 119 RESPOND_TO_W    # Check if W pressed
    j game_loop


RESPOND_TO_A:
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    
    # START BY GETTING ALL NECESSARY DATA
    la $t0 CAPSULE_ONE      # Store address to Capsule 1 in $t0
    la $t1 CAPSULE_TWO      # Store address to Capsule 2 in $t0
    add $a0 $zero $t0       # Set a0 to be address of Capsule 1
    li $a1 0
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t2 $zero $v0       # Store CAP1[x] in $t2
    li $a1 1
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t3 $zero $v0       # Store CAP1[y] in $t3
    
    li $a1 2
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t6 $zero $v0       # Store CAP1[Colour] in $t6
    
    add $a0 $zero $t1       # Set a0 to be address of Capsule 2
    li $a1 0
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t4 $zero $v0       # Store CAP2[x] in $t4
    li $a1 1
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t5 $zero $v0       # Store CAP2[y] in $t5
    
    li $a1 2
    jal STORE_REGISTERS
    jal GET_ITEM_AT
    jal RESTORE_REGISTERS
    add $t7 $zero $v0       # Store CAP2[Colour] in $t7
    
    addi $t8 $t2 -1         # Potential new coordinate of CAP1 stored in $t8
    addi $t9 $t4 -1         # Potential new coordinate of CAP2 stored in $t9


    bltz $t8 NOT_VALID      # If $t8 is less than 0, it is not a valid position, immediately return
    bltz $t9 NOT_VALID      # If $t9 is less than 0, it is not a valid position, immediately return

    # Fetch new position from GRID
    la $a0 GRID
    add $a1 $zero $t8
    add $a2 $zero $t3
    jal STORE_REGISTERS
    jal GET_ITEM_IN_2D      # Get the potential new position of CAP1 in grid
    jal RESTORE_REGISTERS
    add $s0 $zero $v0       # Store value at the new position in $s0
    bgtz $s0 NOT_VALID     # If $s0 is greater than 0, it means this position is occupied, so this is not a valid move, immediately return
    
    
    #Repeat for CAP2
    la $a0 GRID
    add $a1 $zero $t9
    add $a2 $zero $t5
    jal STORE_REGISTERS
    jal GET_ITEM_IN_2D      # Get the potential new position of CAP2 in grid
    jal RESTORE_REGISTERS
    add $s1 $zero $v0       # Store value at the new position in $s1
    bgtz $s1 NOT_VALID     # If $s1 is greater than 0, it means this position is occupied, so this is not a valid move, immediately return
    
    # If program reaches here, this is a valid move! So, move the capsule over, updating the position and the grid
    # Remember, old position if CAP1 is ($t2, $t3) and old position of CAP2 is ($t4, $t5)
    la $a0 GRID
    
    add $a1 $zero $t2
    add $a2 $zero $t3
    jal STORE_REGISTERS
    jal GET_ITEM_IN_2D      # Save the old colour of CAP1 to $s2
    jal RESTORE_REGISTERS
    add $s2 $zero $v0
    
    la $a0 GRID
    add $a1 $zero $t2
    add $a2 $zero $t3
    li $a3 0
    jal STORE_REGISTERS
    jal SET_ITEM_IN_2D      #Set the old position of CAP1 to black
    jal RESTORE_REGISTERS

    la $a0 GRID
    add $a1 $zero $t4
    add $a2 $zero $t5
    jal STORE_REGISTERS
    jal GET_ITEM_IN_2D      # Save the old colour of CAP2 to $s3
    jal RESTORE_REGISTERS
    add $s3 $zero $v0
    
    la $a0 GRID
    add $a1 $zero $t4
    add $a2 $zero $t5
    li $a3 0
    jal STORE_REGISTERS
    jal SET_ITEM_IN_2D      #Set the old position of CAP2 to black
    jal RESTORE_REGISTERS
    
    # We've set the old position of CAP1 and CAP2 to black and stored their old values in $s2 and $s3
    # The new position of CAP1 is ($t8, $t3), and the new position of CAP2 is ($t9, $t5). 
    
    la $a0 GRID
    add $a1 $zero $t8
    add $a2 $zero $t3
    add $a3 $zero $s2
    jal STORE_REGISTERS
    jal SET_ITEM_IN_2D      #Set the new position of CAP1 to the correct colour
    jal RESTORE_REGISTERS

    la $a0 GRID
    add $a1 $zero $t9
    add $a2 $zero $t5
    add $a3 $zero $s3
    jal STORE_REGISTERS
    jal SET_ITEM_IN_2D      #Set the old position of CAP2 to the correct colour
    jal RESTORE_REGISTERS
    
    #Finally, update the coordinates of CAPSULE_ONE and CAPSULE_TWO themselves
    # $a0 = address of Array to index
    # $a1 = index to set value of
    # $a2 = value to set
    la $a0 CAPSULE_ONE
    li $a1 0
    add $a2 $zero $t8
    jal STORE_REGISTERS
    jal SET_ITEM_AT      #Set the new position of CAP1
    jal RESTORE_REGISTERS
    
    la $a0 CAPSULE_TWO
    li $a1 0
    add $a2 $zero $t9
    jal STORE_REGISTERS
    jal SET_ITEM_AT      #Set the new position of CAP2
    jal RESTORE_REGISTERS
    
    #TESTING
    # la $a0 GRID
    # li $a1 0
    # li $a2 0
    # jal STORE_REGISTERS
    # jal GET_ITEM_IN_2D
    # jal RESTORE_REGISTERS
    # add $s3 $zero $v0
    
    # add $a0 $zero $s3
    # li $v0 1
    # syscall

    # la $a0 GRID
    # li $a1 1
    # li $a2 0
    # jal STORE_REGISTERS
    # jal GET_ITEM_IN_2D
    # jal RESTORE_REGISTERS
    # add $s3 $zero $v0
    
    # add $a0 $zero $s3
    # li $v0 1
    # syscall
    
    # la $a0 GRID
    # li $a1 2
    # li $a2 0
    # jal STORE_REGISTERS
    # jal GET_ITEM_IN_2D
    # jal RESTORE_REGISTERS
    # add $s3 $zero $v0
    
    # add $a0 $zero $s3
    # li $v0 1
    # syscall
    
    # la $a0 GRID
    # li $a1 3
    # li $a2 0
    # jal STORE_REGISTERS
    # jal GET_ITEM_IN_2D
    # jal RESTORE_REGISTERS
    # add $s3 $zero $v0
    
    # add $a0 $zero $s3
    # li $v0 1
    # syscall
    
    # la $a0 GRID
    # li $a1 4
    # li $a2 0
    # jal STORE_REGISTERS
    # jal GET_ITEM_IN_2D
    # jal RESTORE_REGISTERS
    # add $s3 $zero $v0
    
    # add $a0 $zero $s3
    # li $v0 1
    # syscall
    
    
    # TESTING DONE
    
    NOT_VALID:
        lw $ra 0($sp)           # Get $ra back so we can exit function
        addi $sp $sp 4
        jr $ra

    
    
RESPOND_TO_D:



RESPOND_TO_S:

RESPOND_TO_W: