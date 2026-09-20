.text 
.globl main

main:
    
    addi x10 x0, 45          #a = 45
    addi x11, x0, 12         #b =12

    jal x1, sum              

    addi x11, x10, 0
    li x10, 1

    ecall
    j end

    sum:
        add x10, x11, x10    #result = 57
        jalr x0, 0(x1)

    exit:
    end:
        j end