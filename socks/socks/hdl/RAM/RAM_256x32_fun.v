// Functional Verilog model of GSPRAM v1.3
`timescale 1ns / 1ps

// `define RamName RAM_256x32
// `define WS 32
// `define BR 6
// `define NR 64
// `define BB 2
// `define NB 4
// Two busses rda and wda for read and write

module RAM_256x32 ( adr, wri, ena, wda, rda );
 input  [31:0] wda;
 output [31:0] rda;
 input  [7:0] adr;
 input  wri, ena;
 reg  [31:0] rrda;
 integer iadr;
 reg viol;

 reg [31:0] mem [0:255];

// specify
//  specparam tsa=0.09;
//  specparam tha=0.09;
//  specparam tsw=0.09;
//  specparam thw=0.09;
//  specparam tsd=0.09;
//  specparam thd=0.186;
//  specparam te1=1.8984;
//  specparam te0=1.8984;
//  specparam tper=1.8584;
//  specparam tpez=0.226;
//  $width( posedge ena, te1, 0, viol );
//  $width( negedge ena, te0, 0, viol );
//  $setup( adr, posedge ena, tsa, viol );
//  $hold(  negedge ena, adr, tha, viol );
//  $setup( wri, posedge ena, tsw, viol );
//  $hold(  negedge ena, wri, thw, viol );
//  $setuphold( negedge ena &&& (wri==1), negedge wda &&& (wri==1), tsd, thd, viol );
//  $setuphold( negedge ena &&& (wri==1), posedge wda &&& (wri==1), tsd, thd, viol );
//  (ena *> rda) = (tper, tper);
// endspecify

assign rda  = rrda;

// task all2x;
//   begin
//   for ( iadr = 0; iadr < 256; iadr = iadr+1 )
//       mem[iadr] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
//   end
// endtask

initial viol = 0;

always @( posedge ena )
if ( ~wri )
   begin
   iadr = adr[7:6] * 64 + adr[5:0];
//   if ( iadr < 256 ) #tper rrda = mem[iadr];
   if ( iadr < 256 ) rrda = mem[iadr];
   end

always @( negedge ena )
begin
if ( wri )
   begin
   iadr = adr[7:6] * 64 + adr[5:0];
   if ( iadr < 256 ) mem[iadr] = wda;
   end
// #tpez rrda = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
end

always @( adr )
if ( ena )
   begin
//    $display("Timing Violation RAM_256x32: adr changed while ena=1 at time %g", $realtime );
//   all2x;
   end

always @( wri )
if ( ena )
   begin
//    $display("Timing Violation RAM_256x32: wri changed while ena=1 at time %g", $realtime );
//   all2x;
   end

//always @( viol )
 //  all2x;

endmodule

