.text
.globl main

main:
    li x20, 0x100       # a
    li x21, 0x200       # b
    li x22, 0x300       # c

    li x9, 1
    sb x9, 0(x20)       # a[0] = 1
    li x9, 2
    sb x9, 1(x20)       # a[1] = 2
    li x9, 3
    sb x9, 2(x20)       # a[2] = 3
    li x9, 4
    sb x9, 3(x20)       # a[3] = 4

    li x9, 10
    sh x9, 0(x21)       # b[0] = 10
    li x9, 20
    sh x9, 2(x21)       # b[1] = 20
    li x9, 30
    sh x9, 4(x21)       # b[2] = 30
    li x9, 40
    sh x9, 6(x21)       # b[3] = 40
   
    lb  x5, 0(x20)      
    lh  x6, 0(x21)      
    add x7, x5, x6      # x7 = a[0] + b[0]
    sw  x7, 0(x22)      # c[0] = a[0] + b[0] = x7

    lb  x5, 1(x20)      
    lh  x6, 2(x21)      
    add x7, x5, x6      # x7 = a[1] + b[1]
    sw  x7, 4(x22)      # c[1] = a[1] + b[1] = x7

    lb  x5, 2(x20)      
    lh  x6, 4(x21)      
    add x7, x5, x6      # x7 = a[2] + b[2]
    sw  x7, 8(x22)      # c[2] = a[2] + b[2] = x7

    
    lb  x5, 3(x20)     
    lh  x6, 6(x21)      
    add x7, x5, x6      # x7 = a[3] + b[3]
    sw  x7, 12(x22)     # c[3] = a[3] + b[3] = x7

end:
    j end