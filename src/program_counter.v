module program_counter #(parameter WIDTH = 32)(clk, rst, pc_scr,current_ins_add);//this module compute next instruction address
  input clk;
  input rst;
  input [6:0] pc_scr;
  output reg [WIDTH-1:0] current_ins_add = {WIDTH{1'b0}};
  
  wire [WIDTH-1:0] next_ins_add;

  always @(posedge clk) begin //Here negedge reset is used 
    if(!rst) begin
	    current_ins_add <= {WIDTH{1'b0}};
    end
    else if(pc_scr != 7'b1111111)begin       //to implement halt
      current_ins_add <= next_ins_add;      //next instruction address is assigned to current instruction address
    end
	 else begin
		current_ins_add <= current_ins_add;
	 end
  end

	assign next_ins_add = current_ins_add[WIDTH-1:0] + 1'b1; //increments the pc value by one or used to compute the next instruction

endmodule
