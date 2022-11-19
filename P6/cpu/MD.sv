`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2022 12:00:00 PM
// Design Name: 
// Module Name: MD
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

module MD(
	input   clk, reset,
	input   [31:0]  v1, v2,
	input   [2:0]   opt,
	input			start,
	output			busy,
	output  [31:0]  hi, lo
	);

	logic   [31:0]  T;
	logic   [64:0]  Ans;
	logic   [31:0]  HI, LO;

	assign  busy	= (T != 32'd0);
	assign  hi		= HI;
	assign  lo		= LO;
	
	always@(posedge clk) begin
		if(reset) begin
			HI  <= 32'b0;
			LO  <= 32'b0;
			Ans <= 32'b0;
			T	<= 32'b0;
		end
		else begin
			if(start) begin
				case(opt)
					3'b000: begin
						Ans <= $signed({{32{v1[31]}}, v1}) * $signed({{32{v2[31]}}, v2});
						T   <= 5;
					end
					3'b001: begin
						Ans <= {32'b0, v1} * {32'b0, v2};
						T   <= 5;
					end
					3'b010: begin
						Ans <= {$signed(v1) % $signed(v2), $signed(v1) / $signed(v2)};
						T   <= 10;
					end
					3'b011: begin
						Ans <= {v1 % v2, v1 / v2};
						T   <= 10;
					end
					3'b100: begin
						Ans[63:32]  <= v1;
						T           <= 1;
					end
					3'b101: begin
						Ans[31:0]   <= v1;
						T           <= 1;
					end
				endcase
			end
			else begin
				if(T == 32'd1) begin
					T   <= T - 1;
					HI  <= Ans[63:32];
					LO  <= Ans[31:0];
				end
				else if(T > 32'd1) begin
					T   <= T - 1;
				end
			end
		end
	end
endmodule