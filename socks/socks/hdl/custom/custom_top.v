`timescale 1ns / 100ps

//
// Toplevel module for the Custom Logic Block
// This must be called "custom_top"
//
// The data here is accessed with the "custom" pointer
// in the C code
//
// For example custom[2]=0x12345678;
// would give data_in=32'h12345678
// and adr=32'hA016008 (which is A016000+2*4)
//
// Note that one *int address covers 4 bytes
//

module custom_top(rst_n, clk, ahbSlaveIn, ahbSlaveOut );
  input         rst_n;
  input         clk;
  input  [83:0] ahbSlaveIn;
  output [50:0] ahbSlaveOut;

  wire strobe, we, match, ack;
  wire [31:0] data_in, adr;
  reg  [31:0] data_out;

// Instantiate the AMBA bus interface logic
  amba_iface amba1(rst_n, clk, ahbSlaveIn, ahbSlaveOut, ack,  strobe, data_out, data_in, we, adr);

// Interface Signals:
//   rst_n    Input:   Active-low reset
//   strobe   Input:   New data arrived
//   ack      Output:  Have read data
//   we       Input:   Write Enable (CPU is writing, not reading)
//   adr      Input:   Address
//   data_in  Input:   Incoming data (for we=1)
//   data_out Output:  Outgoing data (we=0)

// Decode incoming address
// We have 128kByte starting at A016_0000 available
  assign match=(adr==32'hA0160000);

// We give ACK in the same clock cycle
// Could delay ack if we need more time to react
  assign ack=strobe;

// This is the main logic
// If a word is written to the correct address
// the output result is computed and stored

  always @(posedge clk or negedge rst_n)
  begin
	if(!rst_n) begin
	  	data_out<=32'b0;
	end 
	else begin
		if(we && match && strobe)  begin
			data_out<=data_in*data_in*data_in;
		end
	end
  end
	
endmodule