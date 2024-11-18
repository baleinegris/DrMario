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
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    li $t1, 0xffffff        # $t1 = bottle colour
    li $t2, 1               # $loop counter, also the row we're painting
    lw $t3, ADDR_DSPL       # $t3 = start position at the row
    NECK_LOOP:                   # This loop draws the neck of the bottle
        beq $t2 6 NECK_LOOP_END
        sw $t1, 36($t3)          # paint the left side of the neck
        sw $t1, 60($t3)          # paint the right side of the neck
        addi $t2 $t2 1           # increment loop counter
        addi $t3 $t3 256         # Increment row count
        j NECK_LOOP              # reset loop
    NECK_LOOP_END: 
        li $t2, 1                # $t2 = new loop counter
    BOTTLE_LOOP:
        beq $t2 16 CONNECT_LINES        # This loop draws the body of the bottle
        sw $t1, 28($t3)          # paint the left side of the neck
        sw $t1, 68($t3)          # paint the right side of the neck
        addi $t2 $t2 1           # increment loop counter
        addi $t3 $t3 256         # Increment row count
        j BOTTLE_LOOP              # reset loop
    CONNECT_LINES:
        sw $t1 1312($t0)
        sw $t1 1316($t0)
        sw $t1 1344($t0)
        sw $t1 1340($t0)
        li $t2 1
        CONNECT_LOOP:
            beq $t2 12 CONNECT_DONE     # Loop over bottom of bottle
            sw $t1 28($t3)
            addi $t3 $t3 4
            addi $t2 $t2 1
            j CONNECT_LOOP
        CONNECT_DONE:
    li $t2 0        # Initialize loop counter at 0
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
            sll $t1 $t2 8             # $t1 = 258 * row to draw pill
            add $t1 $t1 $t0           # $t1 = location to draw pill
            sw $t5 44($t1)             # Paint the first spot with COLOUR[i]
            addi $t2 $t2 1
            j PILL_DRAW
    PILL_DONE: 
        



game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
