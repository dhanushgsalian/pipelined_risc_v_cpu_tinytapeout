module control_unit #(parameter OP_WIDTH = 7) (func3, func7, opcode, reg_wen, data_imm_sel, alu_op); //this module controles operation of cpu by controling the control signals based on opcode, func7 and func3
  input [2:0] func3;
  input [OP_WIDTH-1:0] func7;
  input [OP_WIDTH-1:0] opcode;
  output reg  reg_wen;
  output reg data_imm_sel;
  output reg [2:0] alu_op;

  always @(func3, func7, opcode) begin
    case(opcode)
      7'b0110011 :  begin
      case(func7)
        7'b0000000 : begin
          case(func3)
            3'b000 :  begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 3'b001;
            end
            3'b100 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 3'b101;
            end
            3'b110 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 3'b011;
            end
            3'b111 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 3'b100;
            end
            default : begin
              reg_wen = 1'b0;
              data_imm_sel = 1'b0;
              alu_op = 3'b000;
            end
          endcase
        end
        7'b0100000: begin
          reg_wen = 1'b1;
          data_imm_sel = 1'b0;
          alu_op = 3'b010;
        end
        default: begin
          reg_wen = 1'b0;
          data_imm_sel = 1'b0;
          alu_op = 3'b000;
        end
      endcase
    end
      7'b0010011 : begin
        reg_wen = 1'b1;
        data_imm_sel = 1'b1;
        alu_op = 3'b001;
      end
      default: begin
        reg_wen = 1'b0;
        data_imm_sel = 1'b0;
        alu_op = 3'b000;
      end
    endcase
  end

endmodule
