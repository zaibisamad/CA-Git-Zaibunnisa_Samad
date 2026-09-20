.text
.globl main

main:
    li x10, 10       #g = 10
    li x11, 5        #h = 5
    li x12, 6       #i = 6
    li x13, 2       #j = 2

    jal x1, leafexamp

    addi x11, x10, 0
    li x10, 1
    ecall
    j exit

leafexamp:
    addi sp, sp, -16

    sw x18, 0(sp)
    sw x19, 4(sp)
    sw x20, 8(sp)

    add x18, x10, x11
    add x19, x12, x13
    sub x20, x18, x19
    add x10, x20, x0

    lw x18, 0(sp)
    lw x19, 4(sp)
    lw x20, 8(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)

    #f = (10+5)-(6+2)
    #15-8 = 7

exit:
end:
    j end 