.text
.globl main

main:
    # a -> x18
    # b -> x19
    # d -> x20
    # e -> x21

    addi x18, x0, 5        # a = 5
    add  x19, x0, x0       # b = 0
    addi x18, x19, 32      # a = b + 32

    add  x5, x18, x19      # x5 = a + b
    addi x20, x5, -5       # d = (a + b) - 5

    sub  x5, x18, x20      # x5 = a - d
    sub  x6, x19, x18      # x6 = b - a
    add  x7, x5, x6        # x7 = (a - d) + (b - a)
    add  x21, x7, x20      # e = x7 + d

    # e = a + b + d + e;
    add  x5, x18, x19      # x5 = a + b
    add  x6, x20, x21      # x6 = d + e
    add  x21, x5, x6       # e = (a + b) + (d + e)

end:
    j end                  # Halt program execution