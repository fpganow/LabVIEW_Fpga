`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2017 08:16:25 AM
// Design Name: 
// Module Name: halfadder
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

module halfadder(
    input in_x,
    input in_y,
    output out_sum,
    output out_carry
    );
    
    assign out_sum = in_x ^ in_y;
    assign out_carry = in_x & in_y;
endmodule
