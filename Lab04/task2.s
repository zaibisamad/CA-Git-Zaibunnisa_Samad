.text
    .globl main

main:
    li x10, 6          
    jal x1, tri
    
    add x11, x10, x0 
    li x10, 1
    ecall 
    j exit 

tri:
    addi sp, sp, -8     
    sw x1, 4(sp)       
    sw x10, 0(sp)
    
    li x5, 1            
    ble x10, x5, base   
    
    addi x10, x10, -1
    jal x1, tri
    
    add x6, x10, x0
    lw x10, 0(sp)
    lw x1, 4(sp)
    
    addi sp, sp, 8 
    add x10, x10, x6
    jalr x0, 0(x1)

base:
    li x10, 1
    lw x1, 4(sp)
    addi sp, sp, 8 
    jalr x0, 0(x1)
exit:
end:
j end