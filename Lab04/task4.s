#sum of squares 

.text
.globl main

main:
    li x10, 4               #calculate 1^2 + 2^2 + 3^2 + 4^2
    jal x1, sum_squares      

    add x11, x10, x0 
    li x10, 1
    ecall 
    j exit 
sum_squares:
    
    addi sp, sp, -16        
    sw x1, 12(sp)           
    sw x18, 8(sp)           
    sw x19, 4(sp)            
    sw x20, 0(sp)            
   
    add x20, x10, x0         
    li x18, 1                # i = 1
    li x19, 0                # sum = 0

loop:
    bgt x18, x20, end_loop   

    add x10, x18, x0         
    jal x1, square           

    add x19, x19, x10        # sum = sum + square(i)
    addi x18, x18, 1         # i++
    j loop

end_loop:
    add x10, x19, x0         
    lw x1, 12(sp)            
    lw x18, 8(sp)
    lw x19, 4(sp)
    lw x20, 0(sp)
    addi sp, sp, 16 
    jalr x0, 0(x1) 

square:
 
    mul x10, x10, x10       
    jalr x0, 0(x1)

exit :
end:
j end