.text
.globl main

main:
    li x10, 3           #n = 3
    jal x1, fact   
    add x11, x10, x0

//exit:
    li x10, 1
    ecall    
    j exit            

fact:
    li x6, 1

    loop:
        ble x10, x0, do
        mul x6, x6, x10   #acc= acc * n
        addi x10, x10, -1   #n =n - 1
        beq x0, x0, loop 

do:
    add x10, x6, x0        
    jalr x0, 0(x1)

exit:
end:
    j end
