module progarm_memory #(parameter DEPTH = 256, WIDTH = 32, ADD_WIDTH = 8) (clk, add, instruction); //This module implements the 4k program memory where instruction are stored
  input clk;
  input [ADD_WIDTH-1:0] add;
  output [WIDTH-1:0] instruction;

  reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1]; //creating 4k memory
  integer i;
  //asynchronous read
  assign instruction = mem[add];               //Reading instruction based on program counter address

  always @(posedge clk) begin //initializing program memory with sum instruction to check operation
    mem[0] <= 32'b000000001000_00000_000_00001_0010011;   // addi R1 = R0 + 8 here immediate value given in RS2 and opcode is 0010011
    mem[1] <= 32'b000000000010_00000_000_00010_0010011;   // addi R2 = R0 + 2 here immediate value given in RS2 and opcode is 0010011
    mem[2] <= 32'b0000000_00010_00001_000_00011_0110011;  // ADD R3=R1+R2;
    mem[3] <= 32'b0100000_00010_00001_000_00100_0110011;  // subtract  R4 = R1 - R2;
    mem[4] <= 32'b0000000_00010_00001_110_00101_0110011;  // AND R5 = R1 & R2
    mem[5] <= 32'b0000000_00010_00001_111_00110_0110011;  // OR R6 = R1 | R2
    mem[6] <= 32'b0000000_00010_00001_100_00111_0110011;  // XOR R7 = R1 ^ R2
    mem[7] <= 32'b0000000_00010_00111_000_01000_0110011;  //ADD R8=R2+R7;
    mem[8] <= 32'b0000000_01000_00001_000_00001_0110011;  //ADD R1=R8+R1;
    mem[9] <= 32'b0000000_00000_00000_000_00000_1111111; //halt
    for(i = 10; i < DEPTH; i = i + 1)
      mem[i] <= 0;
  end

endmodule
