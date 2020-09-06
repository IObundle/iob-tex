/*****************************************************************************

  Description: I2S Prototype Transceiver Wrapper

  Copyright (C) 2020 IObundle, Lda  All rights reserved

******************************************************************************/

`timescale 1ns / 1ps
`include "iob_i2s.vh"

//i2s multiplexer for tx/rx single module instantiation
module iob_i2s(
	       input         clk, //System clock input
	       input         rst, //System reset, asynchronous and active high

	       //CPU SIDE
               input         valid, //Native CPU interface valid signal
	       input [4:0]   address, //Native CPU interface address signal
               input [31:0]  wdata, //Native CPU interface data write signal
	       input         wstrb, //Native CPU interface write strobe signal
	       output [31:0] rdata, //Native CPU interface read data signal
	       output        ready, //Native CPU interface ready signal

	       //I2S RX interface
	       input         bclk_rxin, //RX bit clock input signal for slave mode
	       input         fsync_rxin, //RX frame start sync pulsefor slave mode

	       output        bclk_rxout, //RX bit clock output signal for master mode
	       output        fsync_rxout, //RX frame start sync pulse for master mode

               output        ms_sel, //RX master/slave select bit; can be used to control a tri-state buffer to decide whether the external bclk and fsync lines are driven by the core bclk and fsync outputs (1) or not (0)
	       input         sdata_rxin, //RX data serial input

	       //Other RX signals
	       input         mute, // Mutes received audio (1) or not (0)
	       output        error, // Received input format is wrong (1) or not (0)
	       output        overflow, // Receive FIFO is overflown

	       //I2S TX interface
	       input         bclk_txin, //TX bit clock input signal for slave mode
	       input         fsync_txin, //TX frame start sync pulsefor slave mode

	       output        bclk_txout, //TX bit clock output signal for master mode
	       output        fsync_txout, //TX frame start sync pulse for master mode

               output        ms_sel, //TX master/slave select bit; can be used to control a tri-state buffer to decide whether the external bclk and fsync lines are driven by the core bclk and fsync outputs (1) or not (0)
	       output        sdata_txout, //TX data serial output

               output        interrupt //Interrupt pin: goes high if RX FIFO above level threshhold or TX FIFO below level threshhold, remains low otherwise           
	       );

   reg        tx_valid;
   reg [3:0]  tx_address;
   reg [31:0] tx_wdata;
   reg        tx_wstrb;
   reg [31:0] tx_rdata;
   reg        tx_ready;

   reg        rx_valid;
   reg [3:0]  rx_address;
   reg [31:0] rx_wdata;
   reg        rx_wstrb;
   reg [31:0] rx_rdata;
   reg        rx_ready;

   iob_i2s_tx i2s_tx
     (
      .clk      (clk),
      .rst      (rst),

      //cpu interface
      .valid    (tx_valid),
      .address  (tx_address),
      .data_in  (tx_wdata),
      .wstrb    (tx_wstrb),
      .data_out (tx_rdata),
      .ready    (tx_ready),


      //I2S interface
      .bclk     (bclk ),
      .lrclk    (lrclk),
      .sdata    (sdata)
      );

   iob_i2s_rx i2s_rx
     (
      .clk      (clk),
      .rst      (rst),

      //cpu interface
      .valid    (rx_valid),
      .address  (rx_address),
      .data_in  (rx_wdata),
      .wstrb    (rx_wstrb),
      .data_out (rx_rdata),
      .ready    (rx_ready),

      //I2S interface
      .bclk     (bclk ),
      .lrclk    (lrclk),
      .sdata    (sdata),

      //Other signals
      .mute     (mute), // if 1, mutes audio
      .error    (error),
      .overflow (overflow)
      );


   always @* begin //address demuxer (tx/rx bit determines which I/F to route to)
      if ( address[4] == `I2S_TX) begin
	 tx_valid   <= valid;
	 tx_address <= address[3:0];
	 tx_wdata   <= wdata;
	 tx_wstrb   <= wstrb;
	 rdata      <= tx_rdata;
	 ready      <= tx_ready;

	 //unobtrusive values while addressing rx
	 rx_valid   <= 1'b0;
	 rx_address <= 4'd15; //unassigned addr
	 rx_wdata   <= 32'b0;
	 rx_wstrb   <= 1'b0;
      end
      else //if ( address[4] == `I2S_RX) begin
	begin
	   rx_valid   <= valid;
	   rx_address <= address[3:0];
	   rx_wdata   <= wdata;
	   rx_wstrb   <= wstrb;
	   rdata      <= rx_rdata;
	   ready      <= rx_ready;

	   //unobtrusive values while addressing tx
	   tx_valid   <= 1'b0;
	   tx_address <= 4'd15; //unassigned addr
	   tx_wdata   <= 32'b0;
	   tx_wstrb   <= 1'b0;
	end
   end

endmodule // iob_i2s
