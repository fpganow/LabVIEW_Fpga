//////////////////////////////////////////////////////////////////////
////                                                              ////
////  File name "xge_mac.v"                                       ////
////                                                              ////
////  This file is part of the "10GE MAC" project                 ////
////  http://www.opencores.org/cores/xge_mac/                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - A. Tanguay (antanguay@opencores.org)                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 AUTHORS. All rights reserved.             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
 
 
`include "defines.v"
 
module rx_pause_counter(clk, reset_n, pause_req, pause_val, tx_pause);
	input clk, reset_n, pause_req;
	input [15:0] pause_val;
	output wire tx_pause;
	
	reg [18:0] count;
	reg counting;
	
	assign tx_pause = counting;
	
	always@ (posedge clk or negedge reset_n) begin
		if(~reset_n) begin
			count <= 19'h0;
			counting <= 1'b0;
		end
		else
		begin
			if(count == 19'h0) begin
				counting <= 1'b0;
			end
			if(pause_req) begin
				counting <= 1'b1;
				count <= pause_val << 3;
			end
			if(counting) begin
				count <= count - 1;
			end
		end
	end
	
endmodule
