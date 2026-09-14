.text 
.globl main 

main:
    li x05, 3        #a 
    li x06, 2        #b 
    li x10, 0x300    #base address of array D

    li x07, 0        #i = 0
    outerloop:
        bge x07, x05, outerend 
        li x29, 0    #j = 0

        innerloop:
            bge x29, x06, innerend
            slli x28, x29, 4     #(4*j) *4      
            add x28, x28, x10   # D + 16*j
            add x26, x7, x29      # i+ j 
            sw x26, 0(x28)       #D[4*j] = i+j
            addi x29, x29, 1    #j ++
            beq x0, x0, innerloop
        innerend:
            addi x07, x07, 1    #i ++
            beq x0, x0, outerloop
    outerend:

end:
    j end
