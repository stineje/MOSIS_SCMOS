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
  wire  [31:0] data_out;

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
  assign match=(adr[31:7]==25'h1402C00);
  assign match_fpscr=(adr[31:0]==32'hA016_0080);

  assign ack=strobe;

//Since address is Byte addressable it is divided by four (shifted right by 2)

top_fpu top_fpu0(data_in, clk, rst_n, adr[6:2], we, match, match_fpscr, data_out);

// registerfile rf(adr[6:2], data_in, regwrite, clk_bar, data_out);


//  always @(posedge clk or negedge rst_n)
//  begin
//	if(!rst_n) begin
//	  	data_out<=32'b0;
//	end 
//	else begin
//		if(match && strobe)  begin
//			data_out <= d_out;
//		end
//	end
//  end
	
endmodule
