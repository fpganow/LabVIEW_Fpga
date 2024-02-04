//
// Copyright 2013 Ettus Research LLC
//


//
// Wrap XGE MAC to meet AXI4-S interface
//

module xge_mac_wrapper
  #(parameter PORTNUM=8'd0)
   (
    // XGMII
    output [63:0] xgmii_txd,
    output [7:0]  xgmii_txc,
    input [63:0]  xgmii_rxd,
    input [7:0]   xgmii_rxc,
    // MDIO
    output        mdc,
    output        mdio_in,
    input         mdio_out,
    // Client FIFO Interfaces
    input         sys_clk,
    input         reset, // From sys_clk domain.
    output [63:0] rx_axis_tdata,
    output [3:0]  rx_axis_tuser,
    output        rx_axis_tlast,
    output        rx_axis_tvalid,
    input         rx_axis_tready,
    input [63:0]  tx_axis_tdata,
    input [3:0]   tx_axis_tuser, // Bit[3] (error) is ignored for now.
    input         tx_axis_tlast,
    input         tx_axis_tvalid,
    output        tx_axis_tready);

   (* ASYNC_REG = "TRUE" *)
   reg            xgmii_reset_r1;
   reg            xgmii_reset;

   wire           xgmii_clk;
   assign xgmii_clk = sys_clk;

   //
   // Generate 156MHz synchronized reset localy
   //
   always @(posedge xgmii_clk or posedge reset)
     begin
	if (reset) begin
	   xgmii_reset_r1 <= 1'b1;
	   xgmii_reset    <= 1'b1;
	end
	else begin
	   xgmii_reset_r1 <= 1'b0; // IJB. Was PLL lock here.
	   xgmii_reset    <= xgmii_reset_r1;
	end
     end // always @ (posedge xgmii_clk or posedge reset)

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 pkt_rx_avail;           // From xge_mac of xge_mac.v
   wire [63:0]          pkt_rx_data;            // From xge_mac of xge_mac.v
   wire                 pkt_rx_eop;             // From xge_mac of xge_mac.v
   wire                 pkt_rx_err;             // From xge_mac of xge_mac.v
   wire [2:0]           pkt_rx_mod;             // From xge_mac of xge_mac.v
   wire                 pkt_rx_ren;             // From xge_handshake of xge_handshake.v
   wire                 pkt_rx_sop;             // From xge_mac of xge_mac.v
   wire                 pkt_rx_val;             // From xge_mac of xge_mac.v
   wire [63:0]          pkt_tx_data;            // From axi64_to_xge64_i of axi64_to_xge64_bypass.v
   wire                 pkt_tx_eop;             // From axi64_to_xge64_i of axi64_to_xge64_bypass.v
   wire                 pkt_tx_full;            // From xge_mac of xge_mac.v
   wire [2:0]           pkt_tx_mod;             // From axi64_to_xge64_i of axi64_to_xge64_bypass.v
   wire                 pkt_tx_sop;             // From axi64_to_xge64_i of axi64_to_xge64_bypass.v
   wire                 pkt_tx_val;             // From axi64_to_xge64_i of axi64_to_xge64_bypass.v
   // End of automatics
   wire        pkt_rx_pause_req;
   wire [15:0] pkt_rx_pause_val;

   
   ////////////////////////////////////////////////////////////////////////
   // 10G MAC
   ////////////////////////////////////////////////////////////////////////
   xge_mac xge_mac
     (
      .pkt_rx_pause_req       (pkt_rx_pause_req),
      .pkt_rx_pause_val       (pkt_rx_pause_val),
      // Outputs
      .wb_ack_o               ( ), // all intentionally open
      .wb_dat_o               ( ),
      .wb_int_o               ( ),
      .mdio_tri               ( ),
      .xge_gpo                ( ),
      .mdio_out               (mdio_in),// Switch sense of in and out here for master and slave.
      // Inputs
      .clk_156m25             (xgmii_clk),
      .clk_xgmii_rx           (xgmii_clk),
      .clk_xgmii_tx           (xgmii_clk),
      .reset_156m25_n         (~xgmii_reset),
      .reset_xgmii_rx_n       (~xgmii_reset),
      .reset_xgmii_tx_n       (~xgmii_reset),
      .wb_adr_i               (8'b0),
      .wb_clk_i               (1'b0),
      .wb_cyc_i               (1'b0),
      .wb_dat_i               (32'b0),
      .wb_rst_i               (1'b1),
      .wb_stb_i               (1'b0),
      .wb_we_i                (1'b0),
      .mdio_in                (mdio_out), // Switch sense of in and out here for master and slave.
      .xge_gpi                (/*{2'b00,align_status,mgt_tx_ready,sync_status[3:0]}*/0),
      /*AUTOINST*/
      // Outputs
      .pkt_rx_avail           (pkt_rx_avail),
      .pkt_rx_data            (pkt_rx_data[63:0]),
      .pkt_rx_eop             (pkt_rx_eop),
      .pkt_rx_err             (pkt_rx_err),
      .pkt_rx_mod             (pkt_rx_mod[2:0]),
      .pkt_rx_sop             (pkt_rx_sop),
      .pkt_rx_val             (pkt_rx_val),
      .pkt_tx_full            (pkt_tx_full),
      .xgmii_txc              (xgmii_txc[7:0]),
      .xgmii_txd              (xgmii_txd[63:0]),
      .mdc                    (mdc),
      // Inputs
      .pkt_rx_ren             (pkt_rx_ren),
      .pkt_tx_data            (pkt_tx_data[63:0]),
      .pkt_tx_eop             (pkt_tx_eop),
      .pkt_tx_mod             (pkt_tx_mod[2:0]),
      .pkt_tx_sop             (pkt_tx_sop),
      .pkt_tx_val             (pkt_tx_val),
      .xgmii_rxc              (xgmii_rxc[7:0]),
      .xgmii_rxd              (xgmii_rxd[63:0]));


   ////////////////////////////////////////////////////////////////////////
   // Logic to drive pkt_rx_ren on XGE MAC
   ////////////////////////////////////////////////////////////////////////
   xge_handshake xge_handshake
     (
      // Inputs
      .clk                    (xgmii_clk),
      .reset                  (xgmii_reset),
      /*AUTOINST*/
      // Outputs
      .pkt_rx_ren             (pkt_rx_ren),
      // Inputs
      .pkt_rx_avail           (pkt_rx_avail),
      .pkt_rx_eop             (pkt_rx_eop));
   
   ////////////////////////////////////////////////////////////////////////
   // adjust the xge RX interface to AXI4
   ///////////////////////////////////////////////////////////////////////
   xge64_to_axi64_bypass  #(.LABEL(PORTNUM)) xge64_to_axi64
     (
      /*AUTOINST*/
      // Outputs
      .rx_axis_tdata          (rx_axis_tdata[63:0]),
      .rx_axis_tuser          (rx_axis_tuser[3:0]),
      .rx_axis_tlast          (rx_axis_tlast),
      .rx_axis_tvalid         (rx_axis_tvalid),
      // Inputs
      .xgmii_clk              (xgmii_clk),
      .xgmii_reset            (xgmii_reset),
      .pkt_rx_data            (pkt_rx_data[63:0]),
      .pkt_rx_mod             (pkt_rx_mod[2:0]),
      .pkt_rx_sop             (pkt_rx_sop),
      .pkt_rx_eop             (pkt_rx_eop),
      .pkt_rx_err             (pkt_rx_err),
      .pkt_rx_val             (pkt_rx_val),
      .rx_axis_tready         (rx_axis_tready));

   ////////////////////////////////////////////////////////////////////////
   // adjust the xge TX interface to AXI4
   ///////////////////////////////////////////////////////////////////////
   wire        pause_tx;

   axi64_to_xge64_bypass axi64_to_xge64_i
     (
      /*AUTOINST*/
      // Outputs
      .pkt_tx_data            (pkt_tx_data[63:0]),
      .pkt_tx_mod             (pkt_tx_mod[2:0]),
      .pkt_tx_sop             (pkt_tx_sop),
      .pkt_tx_val             (pkt_tx_val),
      .pkt_tx_eop             (pkt_tx_eop),
      .tx_axis_tready         (tx_axis_tready),
      // Inputs
      .xgmii_clk              (xgmii_clk),
      .xgmii_reset            (xgmii_reset),
      .tx_axis_tdata          (tx_axis_tdata[63:0]),
      .tx_axis_tuser          (tx_axis_tuser[3:0]),
      .tx_axis_tlast          (tx_axis_tlast),
      .tx_axis_tvalid         (tx_axis_tvalid),
      .pause_tx               (pause_tx),
      .pkt_tx_full            (pkt_tx_full));

   rx_pause_counter rx_pause_cnt0
     (
      .clk(xgmii_clk),
      .reset_n(~xgmii_reset),
      .pause_req(pkt_rx_pause_req),
      .pause_val(pkt_rx_pause_val),
      .tx_pause(pause_tx));
					
endmodule // xge_mac_wrapper

// Local Variables:
// verilog-library-directories:("../xge/rtl/verilog" ".")
// verilog-library-extensions:(".v" ".h")
// End:
