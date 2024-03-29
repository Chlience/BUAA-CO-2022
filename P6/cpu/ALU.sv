`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2022 02:45:49 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
	input   [31:0]  v1,     // value
	input   [31:0]  v2,
	input   [15:0]  imm16,  // immediate number
	input   [3:0]   opt,    // option
	output  [31:0]  res,    // result
	output          overf   // overflow
	);
	
	logic   [32:0]  result;
	logic           overflow;
	
	always@(*) begin
		case(opt)
			4'd0: begin // v1 + v2
				result      = {v1[31], v1} + {v2[31], v2};
				overflow    = (result[32] != result[31]);
			end
			4'd1: begin // v1 - v2
				result      = {v1[31], v1} - {v2[31], v2};
				overflow    = (result[32] != result[31]);
			end
			4'd2: begin // v1 & v2
				result      = {1'b0, v1} & {1'b0, v2};
				overflow    = 1'b0;
			end
			4'd3: begin // v1 | v2
				result      = {1'b0, v1} | {1'b0, v2};
				overflow    = 1'b0;
			end
			4'd4: begin // v1 + sign_extend_imm16
				result      = {v1[31], v1} + {{17{imm16[15]}}, imm16};
				overflow    = (result[32] != result[31]);
			end
			4'd5: begin // v1 - sign_extend_imm16
				result      = {v1[31], v1} - {{17{imm16[15]}}, imm16};
				overflow    = (result[32] != result[31]);
			end
			4'd6: begin // v1 $ imm16
				result      = {1'b0, v1} & {17'b0, imm16};
				overflow    = 1'b0;
			end
			4'd7: begin // v1 | imm16
				result      = {1'b0, v1} | {17'b0, imm16};
				overflow    = 1'b0;
			end
			4'd8: begin // v1 < v2 $signed
				result		= $signed(v1) < $signed(v2);
				overflow	= 1'b0;
			end
			4'd9: begin // v1 < v2
				result		= v1 < v2;
				overflow	= 1'b0;
			end
			default: begin
				result      = {1'b0, imm16, 16'b0};
				overflow    = 1'b0;
			end
		endcase
	end
	assign  res     = result[31:0];
	assign  overf   = overflow;
	
endmodule
