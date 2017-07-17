addi $s0, $zero, 8
addi $s1,$zero, 0x7f00
countdown:
addi $s0, $s0, -1
addi $s1, $s1, 1
bne $s0, 0, countdown
