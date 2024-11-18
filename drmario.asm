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
COLOURS:
    .word
    0xf5e137, 0xc51103, 0x0bece1
WIDTH:
    .word
    64
HEIGHT:
    .word
    32
CAPSULE_ONE_X:
    .word
    6
CAPSULE_ONE_Y:
    .word
    7
CAPSULE_TWO_X:
    .word
    7
CAPSULE_TWO_Y:
    .word
    7
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
    PILL_DRAW: 
            beq $t2 2 PILL_DONE
            li $v0 42       # Generating a random number between 0 and 2, stored in $a0
            li $a0 0
            li $a1 3
            syscall
            la $t8 COLOURS            # Store the address of Colours in $t8
            sll $t9 $a0 2             # Multiply $a0 by 4 and store it in $t9, this is the index i in Colours we want
            add $t7 $t8 $t9           # $t7 = addr(COLOURS[i])
            lw $t5 0($t7)             # $t5 = COLOUR[i]
            beq $t2 1 SECOND_HALF
                lw $a0 CAPSULE_ONE_X
                lw $a1 CAPSULE_ONE_Y
                j CAPSULE_DONE
                SECOND_HALF:
                lw $a0 CAPSULE_TWO_X
                lw $a1 CAPSULE_TWO_Y
            CAPSULE_DONE:
            add $a2 $zero $t5   # Set $a2 to be colour
            jal STORE_REGISTERS   # Store contents of registers before calling helper function
            jal DRAW_AT
            jal RESTORE_REGISTERS
            addi $t2 $t2 1
            j PILL_DRAW
    PILL_DONE: 
        li $v0 10
        syscall

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
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