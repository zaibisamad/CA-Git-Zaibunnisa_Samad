.text 
.globl main 

main:
    li x20, 3    #x
    li x22, 6    #b
    li x23, 3    #c

    li x9, 1    
    li x10, 2
    li x11, 3
    li x12, 4


    beq x20, x9, Case1
    beq x20, x10, Case2
    beq x20, x11, Case3
    beq x20, x12, Case4
    beq x20, x20, Default  
    

    Case1:
    add x21, x22, x23     #a = b+c 
    beq x0, x0, Exit 

    Case2:
    sub x21, x22, x23     #a = b-c 
    beq x0, x0, Exit 

    Case3:
    slli x21, x22, 1      #a = b*2 
    # sw x12, x21
    beq x0, x0, Exit 

    Case4:
    srai x21, x22, 1
    # sw x12, x21
    beq x0, x0, Exit 

    Default:
    li x21, 0

    Exit:
        end:
        j end 




    