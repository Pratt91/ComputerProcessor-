.eqv length 256
.eqv stride 4

# num bytes
li $a0, length
ori $s0, $a0, 0
# allocate array of N bytes
li $v0, 9
syscall 

# first loop
addu $s1, $0, $0
loop:
bge $s1, $s0, loop_end
# load and do nothing with result
addu $t0, $v0, $s1 
lb $t1, 0($t0)
# increment
addiu $s1, $s1, stride

loop_end:

# second loop
addiu $s1, $0, 1
loop2:
bge $s1, $s0, loop_end2
# load and do nothing with result
addu $t0, $v0, $s1 
lb $t1, 0($t0)
# increment
addiu $s1, $s1, stride
j loop
j loop2
loop_end2:
