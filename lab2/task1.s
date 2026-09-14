.text 
.globl main 

#Task 1: Listing 3:
# main:
#     li x22, 2
#     li x23, 2 
#     li x20, 6  
#     li x21, 10
    
#     bne x22, x23, Else
#     add x19, x20, x21
#     beq x0, x0, Exit 
#     Else:
#         sub x19, x20, x21
#     Exit:
#         end: 


#Task 1: Listing 4:
main:
    li x22, 0
    li x24, 5
    li x25, 0x100 

    li x10, 5
    sw x10, 0(x25)
    sw x10, 4(x25)
    li x10, 6
    sw x10, 8(x25)
    li x10, 2
    sw x10, 12(x25)
    li x10, 5
    sw x10, 16(x25)
    #save[i] = [5, 5, 6, 2, 5]


    Loop:
        slli x10, x22, 2
        add x10, x10, x25 
        lw x9, 0(x10)
        bne x9, x24, Exit
        addi x22, x22, 1
        beq x0, x0, Loop

    Exit:
        end:

