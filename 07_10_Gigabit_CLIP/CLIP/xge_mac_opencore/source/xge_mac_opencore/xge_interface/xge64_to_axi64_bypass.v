//
// Copyright 2013 Ettus Research LLC
//


//
// This design will break if downstream can not be guarenteed to be ready to accept data.
// XGE MAC expects to be able to stream whole packet with no handshaking.
// We force downstream packet gate to discard packet by signalling error with tlast and
// resynchronizing with upstream.
//

module xge64_to_axi64_bypass
  #(parameter LABEL=0)
   (/*AUTOARG*/
   // Outputs
   rx_axis_tdata, rx_axis_tuser, rx_axis_tlast, rx_axis_tvalid,
   // Inputs
   xgmii_clk, xgmii_reset, pkt_rx_data, pkt_rx_mod, pkt_rx_sop,
   pkt_rx_eop, pkt_rx_err, pkt_rx_val, rx_axis_tready
   );
	
   input xgmii_clk; 
   input xgmii_reset; 
   input [63:0] pkt_rx_data;
   input [2:0] 	pkt_rx_mod;
   input 	pkt_rx_sop;
   input 	pkt_rx_eop;
   input 	pkt_rx_err;
   input 	pkt_rx_val; 
   output wire [63:0] rx_axis_tdata;
   output wire [3:0]  rx_axis_tuser;
   output wire 	      rx_axis_tlast;
   output wire 	      rx_axis_tvalid;   // Signal data avilable to downstream
   input 	      rx_axis_tready;
   
	  
   localparam EMPTY  = 0;
   localparam IN_USE = 1;
   localparam ERROR1 = 2;

   reg [1:0] state;
   
   always @(posedge xgmii_clk)
     if(xgmii_reset) begin
	state <= EMPTY;
     end else begin

	case(state)
	  EMPTY: begin
	     if (pkt_rx_val & rx_axis_tready & pkt_rx_sop) begin
		// Start of packet should always be received in this state.
		// It should NEVER be possible to get a packet from the MAC with EOP also set in 
		// the first 64 bits so not designed for.
		// Add pad. Store last 6 octets into holding, change state to show data in holding.	
		state <= IN_USE;
	     end
	     else if (pkt_rx_val & ~rx_axis_tready)
	       // Assert on this condition, add H/W to deal with overflow later.
	       $display("ERROR: xge64_to_axi64, pkt_rx_val & ~rx_axis_tready");	     
	  end
	  
	  IN_USE: begin
	     if (pkt_rx_val & rx_axis_tready & (pkt_rx_eop | pkt_rx_err)) begin
		// End of packet should always be received in this state.
		// If Error is asserted from MAC, immediate EOP is forced,
		// and the error flag set in tuser. State machine will return to WAIT
		// state and search for new SOP thereby discarding anything left of error packet.
		state <= EMPTY;
	     end // if (pkt_rx_val & rx_axis_tready & eop)
	     else if (pkt_rx_val & rx_axis_tready) begin
		// No EOP indication so in packet payload somewhere still.
		state <= IN_USE;
	     end
	     else if (pkt_rx_val & ~rx_axis_tready) begin
		// Assert on this condition
		$display("ERROR: xge64_to_axi64, pkt_rx_val & ~rx_axis_tready");
		// Keep error state asserted ready for downstream to accept
		state <= ERROR1;
	     end else if (~pkt_rx_val) begin
		// Assert on this condition, don't expect the MAC to ever throtle dataflow intra-packet.
		$display("ERROR: xge64_to_axi64, ~pkt_rx_val ");
		state <= ERROR1;
	     end
	  end // case: IN_USE

	  ERROR1: begin
	     // We were already actively receiving a packet from the upstream MAC and the downstream
	     // signaled not ready by de-asserting tready. Since we can't back pressure the MAC we have to
	     // abandon the current packet, discarding any data already sent down stream by sending an asserted error
	     // with a tlast when ever tready becomes asserted again. Meanwhile we start dropping arriving MAC
	     // data on the floor since there is nothing useful we can do with it currently.
	     if (rx_axis_tready)
	       begin
		  // OK tready is asserted again so tlast is geting accepted this cycle along with an asserted error.
		  state <= EMPTY;
	       end
	  end // case: ERROR1

	endcase // case(state)
     end // else: !if(xgmii_reset)

   assign error              = (state==ERROR1);
   assign rx_axis_tlast      = pkt_rx_eop | error;
   assign rx_axis_tvalid     = pkt_rx_val | error;
   assign rx_axis_tuser[3]   = error | pkt_rx_err;
   assign rx_axis_tuser[2:0] = pkt_rx_mod[2:0];
   assign rx_axis_tdata      = pkt_rx_data;
endmodule
