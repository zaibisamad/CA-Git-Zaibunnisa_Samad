.text
.globl main

main:
    li x10, 0x200     #base of x[]
    li x11, 0x300     #base of y[]

    li x5, 'y'
    sb x5, 0(x11)
    li x5, 'o'
    sb x5, 1(x11)
    sb x0, 2(x11)

    jal x1, strcpy
    j end

strcpy:
    addi sp, sp, -16
    sw x19, 0(sp)
    addi x19, x0, 0       #i= 0

loop:
    add x5, x11, x19
    lb x6, 0(x5)          #x6= y[i]
    add x7, x10, x19
    sb x6, 0(x7)          #x[i]= y[i]

    beq x6, x0, done
    addi x19, x19, 1      # i++
    j loop
done:
    lw x19, 0(sp)
    addi sp, sp, 16
    jalr x0, 0(x1)

end:
    j end