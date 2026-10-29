`timescale 1ns / 1ps 
 
module control_top( 
    input           clk, 
    input           btnC,         // reset/sample button 
    input   [15:0]  sw,           // sw[6:0] = opcode, sw[9:7] = funct3, sw[10] = funct7_5 
    output  reg [15:0] led,       // Displays control outputs (Now a reg for FSM)
    output  reg [6:0] seg, 
    output          dp, 
    output  reg [3:0] an 
); 
 
    wire btn_db; 
    debouncer db(.clk(clk), .pbin(btnC), .pbout(btn_db)); 
 
    // Map inputs from switches 
    wire [6:0] opcode   = sw[6:0]; 
    wire [2:0] funct3   = sw[9:7]; 
    wire       funct7_5 = sw[10]; 
 
    // Control wires 
    wire RegWrite; 
    wire [1:0] ALUOp; 
    wire MemRead; 
    wire MemWrite; 
    wire ALUSrc; 
    wire MemtoReg; 
    wire Branch; 
    wire [3:0] ALUControl_out; 
 
    // Instantiate Main Control 
    MainControl u_main ( 
        .opcode(opcode), 
        .RegWrite(RegWrite), 
        .ALUOp(ALUOp), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .MemtoReg(MemtoReg), 
        .Branch(Branch) 
    ); 
 
    // Instantiate ALU Control 
    ALUControl u_alu ( 
        .ALUOp(ALUOp), 
        .funct3(funct3), 
        .funct7_5(funct7_5), 
        .ALUControl(ALUControl_out) 
    ); 

    // --- FSM Implementation for Task 3 ---
    localparam IDLE = 2'b00, SAMPLE = 2'b01, DISPLAY = 2'b10;
    reg [1:0] state = IDLE, next_state = IDLE;

    // FSM State Register
    always @(posedge clk) begin
        state <= next_state;
    end

    // FSM Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (btn_db) next_state = SAMPLE;
            SAMPLE: next_state = DISPLAY;
            DISPLAY: if (!btn_db) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM Output Logic: Update LEDs only during SAMPLE state
    always @(posedge clk) begin
        if (state == SAMPLE) begin
            led <= {4'b0, ALUOp, ALUControl_out, Branch, MemtoReg, ALUSrc, MemWrite, MemRead, RegWrite}; 
        end
    end
    // -------------------------------------
 
    // 7-segment display to show opcode value for debugging/verification 
    reg [18:0] rc = 0; 
    always @(posedge clk) rc <= rc + 1; 
    reg [3:0] nib; 
      
    always @(*) begin 
        case (rc[18:17]) 
            2'd0: begin an = 4'b1110; nib = opcode[3:0];     end 
            2'd1: begin an = 4'b1101; nib = {1'b0, opcode[6:4]}; end 
            2'd2: begin an = 4'b1011; nib = ALUControl_out;  end 
            default: begin an = 4'b0111; nib = {2'b0, ALUOp}; end 
        endcase 
 
        case (nib) 
            4'h0: seg = 7'b1000000; 4'h1: seg = 7'b1111001; 
            4'h2: seg = 7'b0100100; 4'h3: seg = 7'b0110000; 
            4'h4: seg = 7'b0011001; 4'h5: seg = 7'b0010010; 
            4'h6: seg = 7'b0000010; 4'h7: seg = 7'b1111000; 
            4'h8: seg = 7'b0000000; 4'h9: seg = 7'b0010000; 
            4'hA: seg = 7'b0001000; 4'hB: seg = 7'b0000011; 
            4'hC: seg = 7'b1000110; 4'hD: seg = 7'b0100001; 
            4'hE: seg = 7'b0000110; default: seg = 7'b0001110; 
        endcase 
    end 
 
    assign dp = 1'b1; 
 
endmodule