.text
.globl _start

_start:
    addi sp, zero, 240     # Initialize Stack Pointer
    addi s0, zero, 256     # s0 = LED base address
    addi s1, zero, 512     # s1 = Switch base address
    addi s2, zero, 768     # s2 = Reset button base address

reset_state:
    sw zero, 0(s0)         # Clear LEDs
    addi s3, zero, 0       # State tracker = 0 (Waiting)
    addi s4, zero, 0       # Clear captured switch value

fsm_loop:
    lw t0, 0(s2)           # Read reset button status
    bne t0, zero, reset_state # If reset pressed, jump to reset
    beq s3, zero, state_wait  # If in wait state, poll switches
    jal zero, state_count     # Otherwise, execute countdown

state_wait:
    lw s4, 0(s1)           # Read switch input
    beq s4, zero, fsm_loop # If switches are zero, keep waiting
    sw s4, 0(s0)           # Display switch value on LEDs
    addi s3, zero, 1       # Set state to counting
    jal zero, fsm_loop

state_count:
    addi a0, s4, 0         # Pass captured count value as argument
    jal ra, countdown      # Call countdown subroutine
    jal zero, reset_state  # Return to reset/idle state after completion

countdown:
    addi sp, sp, -16       # Allocate stack frame
    sw ra, 12(sp)          # Save return address
    sw s5, 8(sp)           # Save preserved register s5
    addi s5, a0, 0         # s5 = current count value

cd_loop:
    sw s5, 0(s0)           # Update LEDs with current count
    beq s5, zero, cd_done  # If count reaches 0, finish
    jal ra, delay          # Call delay routine to match clock timing
    bne a0, zero, cd_exit  # If reset triggered inside delay, exit early
    addi s5, s5, -1        # Decrement counter
    jal zero, cd_loop

cd_done:
    addi a0, zero, 0       # Normal completion status

cd_exit:
    lw ra, 12(sp)          # Restore return address
    lw s5, 8(sp)           # Restore s5
    addi sp, sp, 16        # Deallocate stack frame
    jalr zero, ra, 0       # Return to caller (Venus compatible)

delay:
    addi sp, sp, -16       # Allocate stack frame for delay
    sw s6, 12(sp)          # Save s6
    sw s7, 8(sp)           # Save s7
    addi s6, zero, 1000    # Outer loop counter

dl_outer:
    addi s7, zero, 1250    # Inner loop counter

dl_inner:
    lw t0, 0(s2)           # Poll reset button during delay
    bne t0, zero, dl_reset # Break delay if reset is pressed
    addi s7, s7, -1
    bne s7, zero, dl_inner
    addi s6, s6, -1
    bne s6, zero, dl_outer
    addi a0, zero, 0       # No reset occurred
    jal zero, dl_exit

dl_reset:
    addi a0, zero, 1       # Reset flag set

dl_exit:
    lw s6, 12(sp)          # Restore s6
    lw s7, 8(sp)           # Restore s7
    addi sp, sp, 16        # Deallocate stack frame
    jalr zero, ra, 0       # Return to caller (Venus compatible)