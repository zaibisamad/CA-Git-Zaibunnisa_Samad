.text
.globl main

main:
    li x10, 0x200
    li x11, 2      #k =3

    li x9, 11 
    sw x9, 0(x10)
    li x9, 22
    sw x9, 4(x10)
    li x9, 33
    sw x9, 8(x10)
    li x9, 44
    sw x9, 12(x10)

    jal x1, swap
    j end

swap:
    slli x9, x11, 2   #k*4
    add x9, x9, x10   #base +offset

    lw x6, 0(x9)
    lw x7, 4(x9)
    
    sw x7, 0(x9)        # v[k] = v[k+1]
    sw x6, 4(x9)    # v[k+1] = temp

    jalr x0, 0(x1)


end:
    j end