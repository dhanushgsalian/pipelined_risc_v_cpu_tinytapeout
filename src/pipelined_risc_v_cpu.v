module pipelined_risc_v_cpu #(parameter WIDTH = 15) (clk, rst, out);
  input clk;
  input rst;
  output [WIDTH:0] out;

  //program counter
	wire [3:0] current_ins_add_w;
  //program memory
	wire [31:0] instruction_w;
  //fetch stage
	wire [31:0] next_ins_w;
  //control unit
  wire reg_wen_w;
  wire data_imm_sel_w;
  wire [2:0] alu_op_w;
  //register bank
  wire [WIDTH-1:0] read_data1_w;
  wire [WIDTH-1:0] read_data2_w;
  //decode stage
  //wire reg_wen_dec_w;
  wire [2:0] func3_out;
  wire [4:0] r_reg1_out;
  wire [4:0] r_reg2_out;
  wire [4:0] wr_reg_dec_w;
  wire [6:0] func7_out;
  wire [6:0] opcode_out;
  wire [WIDTH-1:0] immediate_data_dec_w;
  //wire [WIDTH-1:0] op1_out_w;
 // wire [WIDTH-1:0] op2_out_w;
  //alu
	wire [15:0] alu_result_w;
  //writeback stage
  wire reg_wen_wb_w;
  //wire data_wb_sel_wb_w;
  wire [4:0] wr_reg_wb_w;
  //wire [WIDTH-1:0] immediate_data_wb_w;
	wire [15:0] alu_result_wb_w;
  //immediate data select mux
  wire [WIDTH-1:0] mux_out_w;
  //data forward
  wire op1_select;
  wire op2_select;
  //data forward mux
  wire [WIDTH-1:0] mux_out_op1;
  wire [WIDTH-1:0] mux_out_op2;

  //top module output
	assign out = alu_result_wb_w;

	program_counter #(.WIDTH(4)) program_counter_inst(.clk(clk),
    .rst(rst),
	  .pc_scr(instruction_w[6:0]),
    .current_ins_add(current_ins_add_w)
  );

	progarm_memory #(.DEPTH(16), .WIDTH(32), .ADD_WIDTH(4)) progarm_memory_inst(.clk(clk), .add(current_ins_add_w),
    .instruction(instruction_w)
  );

  fetch_stage #(.WIDTH(32)) fetch_stage_inst(.clk(clk), 
    .current_ins(instruction_w),
    .next_ins(next_ins_w)
  );
	decode_stage #(.WIDTH(15)) decode_stage_inst(.clk(clk), 
    .r_reg1(next_ins_w[19:15]), 
    .r_reg2(next_ins_w[24:20]), 
    .wr_reg(next_ins_w[11:7]), 
    .func3(next_ins_w[14:12]), 
    .func7(next_ins_w[31:25]), 
    .opcode(next_ins_w[6:0]), 
    .immediate_data({{3{1'b0}},instruction_w[31:20]}), 
    .r_reg1_out(r_reg1_out), 
    .r_reg2_out(r_reg2_out), 
    .wr_reg_out(wr_reg_dec_w), 
    .immediate_data_out(immediate_data_dec_w), 
    .func3_out(func3_out), 
    .func7_out(func7_out), 
    .opcode_out(opcode_out)
    );

  control_unit #(.OP_WIDTH(7)) control_unit_inst(.func3(func3_out), 
    .func7(func7_out),
    .opcode(opcode_out),
    .reg_wen(reg_wen_w),
    .data_imm_sel(data_imm_sel_w),
    .alu_op(alu_op_w)
  );

register_bank #(.DEPTH(32), .WIDTH(15), .ADD_WIDTH(5)) reg_bank_inst(.clk(clk), 
    .w_en(reg_wen_wb_w),
    .r_reg1(r_reg1_out),
    .r_reg2(r_reg2_out),
    .w_reg(wr_reg_wb_w),
									.w_data(alu_result_wb_w[14:0]),
    .read_data1(read_data1_w),
    .read_data2(read_data2_w)
  );
  
  data_forward #(.ADDR_WIDTH(5)) data_forward_inst(.r_reg1(r_reg1_out), 
    .r_reg2(r_reg2_out), 
    .w_reg(wr_reg_wb_w), 
    .op1_select(op1_select), 
    .op2_select(op2_select)
  );

	mux_2_1 #(.WIDTH(15)) op1_select_inst(.i0(read_data1_w), 
					      .i1(alu_result_wb_w[14:0]),
    .sel(op1_select), 
    .mux_out(mux_out_op1)
  );
	 
	mux_2_1 #(.WIDTH(15)) op2_select_inst (.i0(read_data2_w), 
    .i1(alu_result_wb_w[14:0]),
    .sel(op2_select),
    .mux_out(mux_out_op2)
  );
	 
	mux_2_1 #(.WIDTH(15)) data_store_sel_mux(.i0(mux_out_op2),
    .i1(immediate_data_dec_w),
    .sel(data_imm_sel_w),
    .mux_out(mux_out_w)
  );

  alu_unit #(.WIDTH(15), .OP_WIDTH(3)) alu_inst(.alu_op(alu_op_w),
    .op1(mux_out_op1),
    .op2(mux_out_w),
    .out(alu_result_w)
  );

 writeback_stage #(.WIDTH(16)) writeback_stage_inst(.clk(clk),
    .reg_wen(reg_wen_w),
	  .wr_reg(wr_reg_dec_w),
    .alu_result(alu_result_w),
    .reg_wen_out(reg_wen_wb_w),
	  .wr_reg_out(wr_reg_wb_w),
    .alu_result_out(alu_result_wb_w)
  );

endmodule
