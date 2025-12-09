// Functional Verilog model of GDPRAM v1.3
`timescale 1ns / 1ps

//`define RamName RAM2P_136x8
//`define WS 8
//`define BR 4
//`define NR 16
//`define BB 4
//`define NB 9
`define Zword 8'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
//`define Xword 8'bxxxxxxxx

module RAM2P_136x8 ( ck_a, adr_a, wri_a, ena_a, wda_a, rda_a, oe_a,
 	   ck_b, adr_b, wri_b, ena_b, wda_b, rda_b, oe_b );
 input  [7:0] adr_a; input  [7:0] adr_b;
 input  ck_a, wri_a, ena_a, oe_a, ck_b, wri_b, ena_b, oe_b;
 input  [7:0] wda_a; input  [7:0] wda_b;
 output [7:0] rda_a; output [7:0] rda_b;
 reg  [7:0] rrda_a;
 reg  [7:0] rrda_b;
 integer iadr_a, iadr_b;
 reg viol;

 reg wrq_a, wrq_b, L0_a, L0_b;
 wire enq_a, enq_b;
 reg [7:0] mem [0:143];

//specify
//  specparam tse=0.22;
////  specparam tho=0.026;
//  specparam tc1=1.1561;
//  specparam tc0=1.1561;
//  specparam tpcr=1.7961;
//  specparam tpoz=0.055;
//  $width( posedge ck_a, tc1, 0, viol );
//  $width( negedge ck_a, tc0, 0, viol );
//  $setuphold(  posedge ck_a, posedge wri_a, tse, tho, viol );
//  $setuphold(  posedge ck_a, negedge wri_a, tse, tho, viol );
////  $setuphold(  posedge ck_a, posedge ena_a, tse, tho, viol );
//  $setuphold(  posedge ck_a, negedge ena_a, tse, tho, viol );
//  $setuphold(  posedge ck_a, posedge adr_a, tse, tho, viol );
//  $setuphold(  posedge ck_a, negedge adr_a, tse, tho, viol );
//  $setuphold(  posedge ck_a &&& (wri_a==1), posedge wda_a &&& (wri_a==1), tse, tho, viol );
//  $setuphold(  posedge ck_a &&& (wri_a==1), negedge wda_a &&& (wri_a==1), tse, tho, viol );
////  $width( posedge ck_b, tc1, 0, viol );
//  $width( negedge ck_b, tc0, 0, viol );
//  $setuphold(  posedge ck_b, posedge wri_b, tse, tho, viol );
//  $setuphold(  posedge ck_b, negedge wri_b, tse, tho, viol );
////  $setuphold(  posedge ck_b, posedge ena_b, tse, tho, viol );
//  $setuphold(  posedge ck_b, negedge ena_b, tse, tho, viol );
//  $setuphold(  posedge ck_b, posedge adr_b, tse, tho, viol );
//  $setuphold(  posedge ck_b, negedge adr_b, tse, tho, viol );
//  $setuphold(  posedge ck_b &&& (wri_b==1), posedge wda_b &&& (wri_b==1), tse, tho, viol );
//  $setuphold(  posedge ck_b &&& (wri_b==1), negedge wda_b &&& (wri_b==1), tse, tho, viol );
//  (ck_a *> rda_a) = (tpcr, tpcr);
//  (oe_a *> rda_a) = (tpoz, tpoz);
//  (ck_b *> rda_b) = (tpcr, tpcr);
//  (oe_b *> rda_b) = (tpoz, tpoz);
//endspecify

assign  rda_a = (oe_a)?(rrda_a):(`Zword);
assign  rda_b = (oe_b)?(rrda_b):(`Zword);
//assign #tpoz rda_a = (oe_a)?(rrda_a):(`Zword);
//assign #tpoz rda_b = (oe_b)?(rrda_b):(`Zword);

//task all2x;
//  begin
//  for ( iadr_a = 0; iadr_a < 144; iadr_a = iadr_a+1 )
//      mem[iadr_a] = `Xword;
//  end
//endtask

initial viol = 0;

//always @( viol )
//   all2x;

// special latch for ena
always @ ( ck_a or ena_a )
  if ( ~ck_a ) L0_a = ena_a;
assign enq_a = ck_a & L0_a;

always @ (posedge ck_a )
if ( ena_a )
   begin
   iadr_a = adr_a[7:4] * 16 + adr_a[3:0];
   wrq_a = wri_a;
   if ( iadr_a < 144 ) rrda_a = mem[iadr_a];
////   else               #tpcr rrda_a = `Xword;
   if   ( wri_a )
        if ( iadr_a < 144 ) mem[iadr_a] = wda_a;
   end

// special latch for ena
always @ ( ck_b or ena_b )
  if ( ~ck_b ) L0_b = ena_b;
assign enq_b = ck_b & L0_b;

always @ (posedge ck_b )
if ( ena_b )
   begin
   iadr_b = adr_b[7:4] * 16 + adr_b[3:0];
   wrq_b = wri_b;
   if ( iadr_b < 144 ) rrda_b = mem[iadr_b];
//   else               #tpcr rrda_b = `Xword;
   if   ( wri_b )
        if ( iadr_b < 144 ) mem[iadr_b] = wda_b;
   end

// conflict detection system
always @ ( posedge ( enq_a & enq_b ) )
if ( ( iadr_a == iadr_b ) && ( wrq_a | wrq_b ) )
   begin
//   $display("Warning : overlapped acces to address %h from both ports at time %g", iadr_a, $realtime );
//   $display("          (port A is %sing, portB is %sing)", (wrq_a)?("writ"):("read"), (wrq_b)?("writ"):("read") );
//   mem[iadr_a] = `Xword;
//   rrda_a = `Xword; rrda_b = `Xword;
   end

endmodule

