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

# Coord of first half of capsule
CAPSULE_ONE:
    .word
    -1

# Coord of second half 
CAPSULE_TWO:
    .word
    -1

ROTATE:
    .word
    -260

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
    # Initialize the game
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
    li $a0 17
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
    li $a0 17
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
    li $a0 23
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
    
    jal MAKE_NEW_PILL



game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, RESPOND_TO_INPUT      # If first word 1, key is pressed
    
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
    
MAKE_NEW_PILL:
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !important
    # Reset position of pill to top
    lw $t0 CAPSULE_ONE
    li $t2 1816
    lw $t9 ADDR_DSPL
    add $t2 $t2 $t9
    sw $t2 CAPSULE_ONE
    
    lw $t0 CAPSULE_TWO
    li $t2 1820
    lw $t9 ADDR_DSPL
    add $t2 $t2 $t9
    sw $t2 CAPSULE_TWO
    
    
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
    
    # Draw the new random colour at CAPSULE_ONE's location
    lw $t1 CAPSULE_ONE
    sw $t6 0($t1)
    
    # Repeat for CAPSULE 2
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
    
    # Draw the new random colour at CAPSULE_TWO's location
    lw $t1 CAPSULE_TWO
    sw $t6 0($t1)
    
    li $t1 -260
    sw $t1 ROTATE
    
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra
    

GET_ITEM_AT:
    # $a0 = address of Array to index
    # $a1 = index to get value of
    sll $t0 $a1 2       # Multiply $a1 by 4 and store it in $t0
    add $t1 $a0 $t0     # $t1 = addr(Array) + 4 * i = addr(Array[i]) 
    lw $v0 0($t1)
    jr $ra
    
RESPOND_TO_INPUT:
    addi $sp $sp -4
    sw $ra 0($sp)           # Store $ra in the stack since it will get overriden by helper functions !
    lw $a0, 4($t0)                  # Load second word from keyboard
    
    beq $a0 97 RESPOND_TO_A     # Check if A pressed
    beq $a0 0x64 RESPOND_TO_D    # Check if D pressed
    beq $a0 115 RESPOND_TO_S    # Check if S pressed
    beq $a0 119 RESPOND_TO_W    # Check if W pressed
    
    j game_loop

RESPOND_TO_A:
    lw $t1 CAPSULE_ONE
    add $t7 $t1 $zero            # $t7 = old position of CAPSULE ONE
    lw $t8 0($t1)           # $t8 = old colour of CAPSULE ONE

    lw $t1 CAPSULE_TWO
    add $t6 $t1 $zero            # $t6 = old position of CAPSULE TWO
    lw $t9 0($t1)           # $t9 = old colour of CAPSULE TWO
    
    jal STORE_REGISTERS
    jal ERASE_CAPSULE
    jal RESTORE_REGISTERS
    
    #Check for collisions

    addi $t1 $t7 -4      # $t1 is the new potential position of Capsule 1
    
    lw $t5 0($t1)
    bne $t5 0 INVALID   # IF the new position is not black, invalid move
    
    addi $t2 $t6 -4      # $t2 is the new potential position of Capsule 2
    
    lw $t5 0($t2)
    bne $t5 0 INVALID   # IF the new position is not black, invalid move
    
    #IF THE CODE REACHES HERE, valid move!
    # Draw into bitmap
    sw $t8 0($t1)
    sw $t9 0($t2)
    sw $t1 CAPSULE_ONE
    sw $t2 CAPSULE_TWO
    j END
    
    INVALID:
        sw $t8 0($t7)
        sw $t9 0($t6)
        sw $t7 CAPSULE_ONE
        sw $t6 CAPSULE_TWO
        j END
    # 1804 is the left edge
    END:
    lw $ra 0($sp)           # Get $ra back so we can exit function
    addi $sp $sp 4
    jr $ra

RESPOND_TO_D:
    lw $t1 CAPSULE_ONE
    add $t7 $t1 $zero            # $t7 = old position of CAPSULE ONE
    lw $t8 0($t1)           # $t8 = old colour of CAPSULE ONE

    lw $t1 CAPSULE_TWO
    add $t6 $t1 $zero            # $t6 = old position of CAPSULE TWO
    lw $t9 0($t1)           # $t9 = old colour of CAPSULE TWO
    
    jal STORE_REGISTERS
    jal ERASE_CAPSULE
    jal RESTORE_REGISTERS
    
    #Check for collisions

    addi $t1 $t7 4      # $t1 is the new potential position of Capsule 1
    
    lw $t5 0($t1)
    bne $t5 0 INVALID   # IF the new position is not black, invalid move
    
    addi $t2 $t6 4      # $t2 is the new potential position of Capsule 2
    
    lw $t5 0($t2)
    bne $t5 0 INVALID   # IF the new position is not black, invalid move
    
    #IF THE CODE REACHES HERE, valid move!
    # Draw into bitmap
    sw $t8 0($t1)
    sw $t9 0($t2)
    sw $t1 CAPSULE_ONE
    sw $t2 CAPSULE_TWO
    j END

RESPOND_TO_S:
    lw $t1 CAPSULE_ONE
    add $t7 $t1 $zero            # $t7 = old position of CAPSULE ONE
    lw $t8 0($t1)           # $t8 = old colour of CAPSULE ONE

    lw $t1 CAPSULE_TWO
    add $t6 $t1 $zero            # $t6 = old position of CAPSULE TWO
    lw $t9 0($t1)           # $t9 = old colour of CAPSULE TWO
    
    jal STORE_REGISTERS
    jal ERASE_CAPSULE
    jal RESTORE_REGISTERS
    
    #Check for collisions

    addi $t1 $t7 256      # $t1 is the new potential position of Capsule 1
    
    lw $t5 0($t1)
    bne $t5 0 GROUND_HIT   # IF the new position is not black, invalid move
    
    addi $t2 $t6 256      # $t2 is the new potential position of Capsule 2
    
    lw $t5 0($t2)
    bne $t5 0 GROUND_HIT   # IF the new position is not black, invalid move
    
    #IF THE CODE REACHES HERE, valid move!
    # Draw into bitmap
    sw $t8 0($t1)
    sw $t9 0($t2)
    sw $t1 CAPSULE_ONE
    sw $t2 CAPSULE_TWO
    j END

RESPOND_TO_W:
    lw $t1 CAPSULE_TWO
    add $t6 $t1 $zero            # $t6 = old position of CAPSULE TWO
    lw $t9 0($t1)           # $t9 = old colour of CAPSULE TWO

    # Erase Capsule Two from bitmap
    lw $t0 CAPSULE_TWO
    li $t1 0
    sw $t1 0($t0)
    
    lw $t0 ROTATE
    add $t5 $t0 $t6     #$ t5 is the new potential position of CAPSULE 2
    
    lw $t3 0($t5)
    bne $t3 0 INVALID_ROTATE

    sw $t9 0($t5)
    sw $t5 CAPSULE_TWO
    # Set ROTATE to its new value
    beq $t0 -260 ROTATE_LEFT_DOWN
    beq $t0 252 ROTATE_RIGHT_DOWN
    beq $t0 260 ROTATE_RIGHT_UP
    beq $t0 -252 ROTATE_LEFT_UP
    j END
    ROTATE_LEFT_DOWN:
        li $t1 252
        sw $t1 ROTATE
        j END
    ROTATE_RIGHT_DOWN:
        li $t1 260
        sw $t1 ROTATE
        j END
    ROTATE_RIGHT_UP:
        li $t1 -252
        sw $t1 ROTATE
        j END
    ROTATE_LEFT_UP:
        li $t1 -260
        sw $t1 ROTATE
        j END
    
    INVALID_ROTATE:
        li $a0 69 
        li $v0 1
        syscall
        
        sw $t9 0($t6)
        sw $t6 CAPSULE_TWO
        j END
    
    

ERASE_CAPSULE:
    # Erase Capsule One from bitmap
    lw $t0 CAPSULE_ONE
    li $t1 0
    sw $t1 0($t0)
    
    # Erase Capsule Two from bitmap
    lw $t0 CAPSULE_TWO
    li $t1 0
    sw $t1 0($t0)
    
    jr $ra

GROUND_HIT:
    sw $t8 0($t7)
    sw $t9 0($t6)
    sw $t7 CAPSULE_ONE
    sw $t6 CAPSULE_TWO
    jal STORE_REGISTERS
    jal MAKE_NEW_PILL
    jal RESTORE_REGISTERS
    j END