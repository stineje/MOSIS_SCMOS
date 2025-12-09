
`timescale 1ns / 100ps

module amba_iface
                 (
                  rst_n,                 // Basic I/O
                  clk,

                  ahbSlaveIn,            // Slave Iface I/O
                  ahbSlaveOut,           

                  s_ack_i,               // Wbone Wrapper Control I/O
                  s_stb_o,

                  s_dat_i,               // Wbone Wrapper Data I/O
                  s_dat_o, 
                  s_we_o,
                  s_adr_o
                 );


 // Basic I/O
  input         rst_n;
  input         clk;

 // Slave Iface I/O
  input  [83:0] ahbSlaveIn;
  output [50:0] ahbSlaveOut;

 // Wbone Wrapper Control I/O
  input         s_ack_i;
  output        s_stb_o;

 // Wbone Wrapper Data I/O
  input  [31:0] s_dat_i;
  output        s_we_o;
  output [31:0] s_adr_o;
  output [31:0] s_dat_o;


// -- AMBA Slave Signals
 wire        hsel_s      = ahbSlaveIn[83];    // IN
 wire        hwrite_s    = ahbSlaveIn[82];    // IN
 wire        hready_in_s = ahbSlaveIn[81];    // IN
 wire [1:0]  htrans_s    = ahbSlaveIn[80:79]; // IN
 wire [2:0]  hsize_s     = ahbSlaveIn[78:76]; // IN
 wire [2:0]  hburst_s    = ahbSlaveIn[75:73]; // IN
 wire [3:0]  hprot_s     = ahbSlaveIn[72:69]; // IN
 wire [3:0]  hmaster_s   = ahbSlaveIn[68:65]; // IN
 wire        hmastlock_s = ahbSlaveIn[64];    // IN
 wire [31:0] haddr_s     = ahbSlaveIn[63:32]; // IN
 wire [31:0] hwdata_s    = ahbSlaveIn[31:0];  // IN

 wire [15:0] hsplit_s;     // OUT
 wire        hready_out_s; // OUT
 reg  [1:0]  hresp_s;      // OUT
 wire [31:0] hrdata_s;     // OUT

// Slave Latches  
 reg  [31:0] haddr_s_lat, haddr_s_lat2;

//-- WishBone Slave Signals
 reg         s_stb_o;       // OUT
 reg         s_we_o;        // OUT
 wire  [31:0] s_adr_o;       // OUT
 reg  [31:0] hrdata_s_reg;


 reg  [2:0]  slv_bus_state; // synthesis state_machine


 parameter
          HTRANS_IDLE   = 2'h0,
          HTRANS_BUSY   = 2'h1,
          HTRANS_NONSEQ = 2'h2,
          HTRANS_SEQ    = 2'h3,

          HRESP_OKAY    = 2'h0,
          HRESP_ERROR   = 2'h1,
          HRESP_RETRY   = 2'h2,
          HRESP_SPLIT   = 2'h3,

          HBURST_SINGLE = 3'h0,
          HBURST_INCR   = 3'h1,
          HBURST_WRAP4  = 3'h2,
          HBURST_INCR4  = 3'h3,
          HBURST_WRAP8  = 3'h4,
          HBURST_INCR8  = 3'h5,
          HBURST_WRAP16 = 3'h6,
          HBURST_INCR16 = 3'h7,

          HSIZE_BYTE    = 3'h0,
          HSIZE_HWORD   = 3'h1,
          HSIZE_WORD    = 3'h2,
          HSIZE_DWORD   = 3'h3,
          HSIZE_4WORD   = 3'h4,
          HSIZE_8WORD   = 3'h5,
          HSIZE_16WORD  = 3'h6,
          HSIZE_32WORD  = 3'h7,

     // State machine states
     SLV_IDLE     = 3'b000,

     SLV_WR1      = 3'b001,
     SLV_WR_TRANS = 3'b010,
     SLV_WR2      = 3'b011,

     SLV_RD1      = 3'b100,
     SLV_RD_TRANS = 3'b101,
     SLV_RD2      = 3'b110,

     SLV_ERR      = 3'b111;


//-- AMBA Slave assignment
 assign hsplit_s    = 16'h0;              // Split mode not supported
 assign hready_out_s = (slv_bus_state == SLV_IDLE) ? 1'b1 : s_ack_i;

 assign ahbSlaveOut = {hready_out_s,
                       hresp_s,
                       hsplit_s,
                       hrdata_s
                      };



always @ (negedge rst_n or posedge clk)
      if (!rst_n)
        begin
          haddr_s_lat <= 32'h0;
          haddr_s_lat2 <= 32'h0;
        end
      else
        begin
         if (hsel_s) 
           begin
             haddr_s_lat <= haddr_s;
             haddr_s_lat2 <= haddr_s_lat;
           end
         else
           begin
             haddr_s_lat <= haddr_s_lat;
             haddr_s_lat2 <= haddr_s_lat2;
           end
        end


//-- State transition
always @ (negedge rst_n or posedge clk)
      if (!rst_n) 
        slv_bus_state <= SLV_IDLE;   
      else 
        begin
          case (slv_bus_state)      
            SLV_IDLE    : begin
                            if (hsel_s && hready_in_s)
                              begin
                                if ((htrans_s == HTRANS_NONSEQ) && (hsize_s == HSIZE_WORD))
                                  begin
                                    if (hwrite_s)
                                      slv_bus_state <= SLV_WR1;
                                    else
                                      slv_bus_state <= SLV_RD1;
                                  end
                                else if (((htrans_s == HTRANS_BUSY) || (htrans_s == HTRANS_IDLE)) && (hsize_s == HSIZE_WORD))
                                  slv_bus_state <= SLV_IDLE;
                                else
                                  slv_bus_state <= SLV_ERR;
                              end
                            else
                              slv_bus_state <= SLV_IDLE;
                          end 
            SLV_WR1     : begin
                            if (s_ack_i)
                              begin
                                if (hsel_s)
                                  begin
                                    if ((htrans_s == HTRANS_NONSEQ) && (hsize_s == HSIZE_WORD))
                                      begin
                                        if (hwrite_s)
                                          slv_bus_state <= SLV_WR_TRANS;
                                        else
                                          slv_bus_state <= SLV_RD_TRANS;
                                      end
                                    else if (((htrans_s == HTRANS_BUSY) || (htrans_s == HTRANS_IDLE)) && (hsize_s == HSIZE_WORD))
                                      slv_bus_state <= SLV_WR1;
                                    else
                                      slv_bus_state <= SLV_ERR;
                                  end
                                else
                                  slv_bus_state <= SLV_IDLE;
                              end
                            else
                              begin
                                  slv_bus_state <= SLV_WR1;
                              end
                          end
            SLV_WR_TRANS: begin
                            if (hsel_s)
                              begin
                                if ((htrans_s == HTRANS_NONSEQ) && (hsize_s == HSIZE_WORD))
                                  begin
                                    if (hwrite_s)
                                      slv_bus_state <= SLV_WR2;
                                    else
                                      slv_bus_state <= SLV_RD2;
                                  end
                                else if (((htrans_s == HTRANS_BUSY) || (htrans_s == HTRANS_IDLE)) && (hsize_s == HSIZE_WORD))
                                  slv_bus_state <= SLV_WR_TRANS;
                                else
                                  slv_bus_state <= SLV_ERR;
                              end
                            else
                              slv_bus_state <= SLV_WR1;
                          end
            SLV_WR2     : begin
                            if (s_ack_i)
                              slv_bus_state <= SLV_WR_TRANS;
                            else
                              begin
                                  slv_bus_state <= SLV_WR2;
                              end
                          end
            SLV_RD1     : begin
                            if (s_ack_i)
                              begin
                                if (hsel_s)
                                  begin
                                    if ((htrans_s == HTRANS_NONSEQ) && (hsize_s == HSIZE_WORD))
                                      begin
                                        if (hwrite_s)
                                          slv_bus_state <= SLV_WR_TRANS;
                                        else
                                          slv_bus_state <= SLV_RD_TRANS;
                                      end
                                    else if (((htrans_s == HTRANS_BUSY) || (htrans_s == HTRANS_IDLE)) && (hsize_s == HSIZE_WORD))
                                      slv_bus_state <= SLV_RD1;
                                    else
                                      slv_bus_state <= SLV_ERR;
                                  end
                                else
                                  slv_bus_state <= SLV_IDLE;
                              end
                            else
                              begin
                                  slv_bus_state <= SLV_RD1;
                              end
                          end 
            SLV_RD_TRANS: begin
                            if (hsel_s)
                              begin
                                if ((htrans_s == HTRANS_NONSEQ) && (hsize_s == HSIZE_WORD))
                                  begin
                                    if (hwrite_s)
                                      slv_bus_state <= SLV_WR2;
                                    else
                                      slv_bus_state <= SLV_RD2;
                                  end
                                else if (((htrans_s == HTRANS_BUSY) || (htrans_s == HTRANS_IDLE)) && (hsize_s == HSIZE_WORD))
                                  slv_bus_state <= SLV_RD_TRANS;
                                else
                                  slv_bus_state <= SLV_ERR;
                              end
                            else
                              slv_bus_state <= SLV_RD1;
                          end
            SLV_RD2     : begin
                            if (s_ack_i)
                              slv_bus_state <= SLV_RD_TRANS;
                            else
                              begin
                                  slv_bus_state <= SLV_RD2;
                              end
                          end
            SLV_ERR     : slv_bus_state <= SLV_IDLE;
          endcase
	     end 


//-- State output block
always @ (slv_bus_state)
      begin
        case (slv_bus_state)
          SLV_IDLE    : begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b0;
                          s_we_o = 1'b0;
                        end
          SLV_WR1     : begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b1;
                          s_we_o = 1'b1;
                        end
          SLV_WR_TRANS: begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b0;
                          s_we_o = 1'b0;
                        end
          SLV_WR2     : begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b1;
                          s_we_o = 1'b1;
                        end
          SLV_RD1     : begin 
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b1;
                          s_we_o = 1'b0;
                        end
          SLV_RD_TRANS: begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b0;
                          s_we_o = 1'b0;
                        end
          SLV_RD2     : begin
                          hresp_s = HRESP_OKAY;
                          s_stb_o = 1'b1;
                          s_we_o = 1'b0;
                        end
          SLV_ERR     : begin
                          hresp_s = HRESP_ERROR;
                          s_stb_o = 1'b0;
                          s_we_o = 1'b0;
                        end
        endcase
      end


assign s_dat_o = ((slv_bus_state == SLV_WR1) || (slv_bus_state == SLV_WR2)) ?  hwdata_s : 31'h0;


assign s_adr_o = ((slv_bus_state == SLV_WR1) || (slv_bus_state == SLV_RD1)) ? haddr_s_lat : 
                 (((slv_bus_state == SLV_WR2) || (slv_bus_state == SLV_RD2)) ? haddr_s_lat2 : 32'h0);


assign hrdata_s = (s_ack_i && s_stb_o && !s_we_o) ? s_dat_i : hrdata_s_reg;


always @ (negedge rst_n or posedge clk)
      if (!rst_n)
        hrdata_s_reg <= 32'h0;
      else
        hrdata_s_reg <= hrdata_s;

/*
always @ (negedge rst_n or posedge clk)
      if (!rst_n)
        hrdata_s <= 32'h0;
      else
        begin
          if (s_ack_i && s_stb_o && !s_we_o)
            hrdata_s <= s_dat_i;
          else
            hrdata_s <= hrdata_s;
        end
*/

 endmodule 
