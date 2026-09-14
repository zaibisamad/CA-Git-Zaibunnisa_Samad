.text 
.globl main 

main:
    li x25, 0x200     #base address 

    li x22, 0         #i = 0
    loop1:
        li x9, 10
        bge x22, x9, end1
        slli x10, x22, 2
        add x11, x25, x10
        sw x22, 0(x11)
        addi x22, x22, 1
        beq x0, x0, loop1
    
    end1:

    li x22, 0
    li x23, 0

    loop2:
        li x24, 10
        bge x22, x24, end2
        slli x10, x22, 2
        add x11, x25, x10
        lw x28, 0(x11)
        add x23, x23, x28
        addi x22, x22, 1
        beq x0, x0, loop2
    end2:
end:
    j end
