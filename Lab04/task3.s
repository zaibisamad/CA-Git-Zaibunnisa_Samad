.text
.globl main

main:
    li x8, 5    #size  
    li x25, 0x100

    li x9, 23 
    sw x9, 0(x25)
    li x9, 12
    sw x9, 4(x25)
    li x9, 5
    sw x9, 8(x25)
    li x9, 44
    sw x9, 12(x25)
    li x9, 98
    sw x9, 16(x25)
    li x9, 53

    DO:
        li x10, 0   #swapped = false 
        li x11, 1   #i = 1
        forLoop:
           bgeu x11, x8, WHILE
           slli x12, x11, 2
           add x12, x12, x25

           lw x9, 0(x12)     #load c[i]
           lw x13, -4(x12)   #loading c[i-1]
           bltu x9, x13, swap 
           addi x11, x11, 1
           beq x0, x0, forLoop
           swap:
            sw x13, 0(x12)
            sw x9, -4(x12)
            li x10, 1
            addi x11, x11, 1
            beq x0, x0, forLoop
    WHILE: 
        addi x8, x8, -1
        bne x10, x0, DO
        beq x10, x0, EXIT

EXIT:
    end:
        j end
