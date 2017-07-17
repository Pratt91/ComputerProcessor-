add $s0, $zero, 8
add $s1, $zero, 8
beq $s0, $s1, true


false:
add $s2, $zero, 2
add $s0, $zero, 4
add $s1, $s1, $s0

beq $s0, $s2, false
add $s2, $s2, $s2


true: