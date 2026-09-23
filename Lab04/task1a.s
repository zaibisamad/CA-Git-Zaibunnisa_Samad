.text
.globl main

main:
    li x10, 5           # n = 5
    jal x1, fact    

    add x11, x10, x0    
    li x10, 1
    ecall  
    j exit 

fact:
    addi sp, sp, -8     
    sw x1, 4(sp)        
    sw x10, 0(sp)      

    addi x5, x10, -1    # x5 = n - 1
    bge x5, x0, L1      

    addi x10, x0, 1     #return 1
    addi sp, sp, 8      
    jalr x0, 0(x1)     

L1:
    addi x10, x10, -1   #n-1
    jal x1, fact        

    addi x6, x10, 0     
    lw x10, 0(sp)      
    lw x1, 4(sp)        
    addi sp, sp, 8      

    mul x10, x10, x6    #n *fact(n-1)
    jalr x0, 0(x1)      #return

exit: 
end:
    j end

