module register_bank #(parameter DEPTH = 15, WIDTH = 32, ADD_WIDTH = 5) (clk, w_en, r_reg1, r_reg2, w_reg, w_data, read_data1, read_data2); //This implements the 16 32-bit registers and read and write to register only seven reigiters are used remaining dedicated to future use
  input clk;
  input w_en;
  input [ADD_WIDTH - 1:0] r_reg1;
  input [ADD_WIDTH - 1:0] r_reg2;
  input [ADD_WIDTH - 1:0] w_reg;
  input [WIDTH-1:0] w_data;
  output [WIDTH-1:0] read_data1;
  output [WIDTH-1:0] read_data2;

	reg [WIDTH - 1 : 0] registers[0 : DEPTH - 1]; //32 bit 32 (32x15) register creation

  always @(posedge clk) begin
    registers[0] <= {WIDTH{1'b0}};
    if(w_en && w_reg != 5'b00000)                                    //based on write enable writing happens synchronously
      registers[w_reg] <= w_data;
  end

  assign read_data1 = registers[r_reg1];        //based on addres data reading from registers asynchronously
  assign read_data2 = registers[r_reg2];        //based on addres data reading from registers asynchronously

endmodule
