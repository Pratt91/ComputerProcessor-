# these are just useful constants set
# to the default parameters of
# the Bitmap Display
# width of screen
.eqv WIDTH 512
# height of screen
.eqv HEIGHT 256
# memory address of pixel (0, 0)
.eqv SCREEN 0x10010000


# draw 3 red pixels in the center of the screen
addiu $a0, $zero, WIDTH    # v0 = addressOfPixel(WIDTH/2, HEIGHT/2)
sra $a0, $a0, 1
addiu $a1, $zero, HEIGHT
sra $a1, $a1, 1
jal addressOfPixel
move $a0, $v0 
addiu $a1, $zero, 0xFF0000  # a1 = red (24-bit RRGGBB)
jal draw3pixels
 
# Draw a green horizontal line of length 144 from (0,0)
addiu $a0, $zero, 0   # x of green horizontal  	
addiu $a1, $zero, 0   # y of green horizontal
addiu $a2, $zero, 144      # length 144
jal addressOfPixel
move $a0, $v0         # set address of x
move $a1, $v0         # set address of y
addiu $a3, $zero, 0x00FF00 #green
jal drawhorizontal
 

# Draw a blue vertical line of length 71 from (40, 40)
addiu $a0, $zero, 40       # x pos  40
addiu $a1, $zero, 40       # y pos  40
addiu $a2, $zero, 71      # length 71
jal addressOfPixel
move $a0, $v0              # set address of x
move $a1, $v0              # set address of y
addiu $a3, $zero, 0x0000FF #blue
jal drawvertical 

# Draw a red square of side length 100 from (80,80)
# Fill in the code to call drawsquare appropriately
# YOUR SOLUTION HERE
addiu $a0, $zero, 80          # start x pos of square
addiu $a1, $zero, 80          # start y pos of square
addiu $a2, $zero, 100         # side length
#jal addressOfPixel
#move $a0, $v0                 # set address of y
#move $a1, $v0                 # set address of x
addiu $a3, $zero, 0xFF0000    # color
jal drawsquare

# do not modify this line; it jumps to the end of the program
j end

# Example procedure to draw some pixels
# 
# void drawpixel(screen_address, color)
draw3pixels:
	# Example code for drawing to the screen
	sw $a1, 0($a0) 
	addiu $a0, $a0, 4
	sw $a1, 0($a0)
	addiu $a0, $a0, 4
	sw $a1, 0($a0)
	jr $ra

# Helper procedure that gives the screen address
# of the given x, y coordinate
#
# int addressOfPixel(x, y)
addressOfPixel:
	addiu $t0, $zero, WIDTH  # v0 = SCREEN + (x + y*WIDTH)*4
	mul $t1, $t0, $a1 
	addu $t2, $a0, $t1
	sll $t2, $t2, 2
	addiu $v0, $t2, SCREEN 
	jr $ra
	
		
# Draws a horizontal line from (x,y) to (x+length, y) in the given color.
# Color is 24-bit RGB value
#
# void drawhorizontal(x, y, length, color) 
drawhorizontal:
	# YOUR SOLUTION HERE
	#------------- save ra, a0, a1, a2, a3 to stack
	addiu $sp, $sp, -16
	sw $ra, 0($sp)   # return address
	sw $a0, 4($sp)   # x pos
	sw $a1, 8($sp)   # y pos
	sw $a2, 12($sp)  # length

	
	
	#------------- body
	sw $a3, 0($a0)
	addiu $a0, $a0, 4
	addi $a2, $a2, -1
	beq $a2, $zero, horizontal_end
	jal drawhorizontal
	
	
	#----------- restore the stack
	horizontal_end:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addiu $sp, $sp, 16
	jr $ra 
	
    	
# Draws a vertical line from (x,y) to (x, y+length) in the given color.
# Color is 24-bit RGB value
#
# void drawvertical(x, y, length, color) 
drawvertical:
	# YOUR SOLUTION HERE
	#----------- save ra, a0, a1, a2, a3 to the stack
	addiu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)    # x pos
	sw $a1, 8($sp)    # y pos
	sw $a2, 12($sp)   # line length

	
	#----------- draw vertical line 

	sw $a3, 0($a1)
	addiu $a1, $a1, 2048
	addiu $a2, $a2, -1                 #addiu s1, s1, 1
	beq $a2, $zero, end_drawvertical    #bge s1, a2, end
	jal drawvertical
	
	
	#------------ restore the stack
	end_drawvertical: 
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addiu $sp, $sp, 16
	jr $ra 



# Draws a square with top left corner at (x,y) and bottom right corner at (x+length, y+length) with the given color
# Color is 24-bit RGB value
#
# void drawsquare(x, y, length, color) 
drawsquare:
	# YOUR SOLUTION HERE
	#--------------- add ra, a0, a1, a2 to the stack
	addiu $sp, $sp, -16
	sw $ra, 0($sp)   # return address
	sw $a0, 4($sp)   # x pos
	sw $a1, 8($sp)   # y pos
	sw $a2, 12($sp)  #length
	
	# save initial x and y we will need to re-use
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	#-----------------Body
	# draw initial lines from input
	jal addressOfPixel
	move $a0, $v0                 # set address
	move $a1, $v0 
	
	jal drawvertical
	jal drawhorizontal
	
	# draw lines from x, y+length
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	add $a0, $a0, $zero 
	add $a1, $a1, $a2
	jal addressOfPixel
	move $a0, $v0                 # set address
	move $a1, $v0
	jal drawhorizontal
	
	# draw line from x+length, y
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	add $a0, $a0, $a2 
	add $a1, $a1, $zero
	jal addressOfPixel
	move $a0, $v0                 # set address
	move $a1, $v0
	jal drawvertical
	
	end_drawsquare:
	#--------------- restore the stack
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp) 
	lw $a2, 12($sp)
	
	jr $ra 
	
# Restores original argument values
#
# restore(x, y, length, color)
restore:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	
	
	jr $ra
	




# do not write code beyond this line; it marks the end of the program
end:	
