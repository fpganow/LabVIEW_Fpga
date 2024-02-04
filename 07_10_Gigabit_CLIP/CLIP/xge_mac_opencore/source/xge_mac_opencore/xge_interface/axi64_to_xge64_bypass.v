//
// Copyright 2013 Ettus Research LLC
//


//
// Place an SOP indication in bit[3] of the output tuser.
//



module axi64_to_xge64_bypass (/*AUTOARG*/
   // Outputs
   pkt_tx_data, pkt_tx_mod, pkt_tx_sop, pkt_tx_val, pkt_tx_eop,
   tx_axis_tready,
   // Inputs
   xgmii_clk, xgmii_reset, tx_axis_tdata, tx_axis_tuser,
   tx_axis_tlast, tx_axis_tvalid, pause_tx, pkt_tx_full
   );
   input xgmii_clk;
   input xgmii_reset;
   input [63:0] tx_axis_tdata;
   input [3:0] 	tx_axis_tuser;
   input 	tx_axis_tlast;
   input 	tx_axis_tvalid;
   input 	pause_tx;
   input 	pkt_tx_full;

   output [63:0] pkt_tx_data;
   output [2:0]  pkt_tx_mod;
   output 	 pkt_tx_sop;
   output        pkt_tx_val;
   output 	 pkt_tx_eop;
   output 	 tx_axis_tready;
   

   reg state;

   always @(posedge xgmii_clk) begin
      if(xgmii_reset) begin
         state <= 0;
      end
      else begin

         case(state)

           0: begin
              if (tx_axis_tvalid && tx_axis_tready) begin
                 state <= 1;
              end
           end
	   
           1: begin
              if (tx_axis_tvalid && tx_axis_tready && tx_axis_tlast) begin
                 state <= 0;
              end
           end

         endcase //state
      end
   end
   
   // allow packets through so long as the fifo isn't full
   assign pkt_tx_val     = tx_axis_tvalid && ~pkt_tx_full;
   // allow new data as long as fifo isn't full and we are not pausing
   // even if pause requested, we finish the frame we are on
   assign tx_axis_tready = ~pkt_tx_full && (~pause_tx || state);
   // Indicate sop only on valid data
   assign pkt_tx_sop     = ~state && tx_axis_tvalid && tx_axis_tready;
   // Indicate eop only on valid data
   assign pkt_tx_eop     = (tx_axis_tvalid && tx_axis_tready && tx_axis_tlast);
   
   // BYPASS EVERYTHING ELSE
   assign pkt_tx_data    = tx_axis_tdata[63:0];
   assign pkt_tx_mod     = tx_axis_tuser[2:0];
endmodule // axi64_to_xge64_bypass



// Local Variables:
// verilog-library-directories:("../xge/rtl/verilog" ".")
// verilog-library-extensions:(".v" ".h")
// End:
