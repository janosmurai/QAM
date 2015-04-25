`timescale 1ns / 1ps

module clk_gen(
   input  rstn_in,
   input  clk_in,
   output clk_out,
   output rst_out,
   
   output [1:0] dbg_locked
);


wire rst_in;
assign rst_in = ~rstn_in;

wire clk_in_bufg;
wire dcm0_clkfx;
wire dcm0_clkfx_bufg;
wire [1:0] dcm_locked;


IBUFG ibufg_in (
   .O(clk_in_bufg),
   .I(clk_in)
);


reg [15:0] rst_cnt0;
reg rst_dcm0;
always @ (posedge clk_in_bufg, posedge rst_in)
if (rst_in)
begin
   rst_cnt0 <= 0;
   rst_dcm0 <= 1;
end
else
begin
   if (rst_cnt0[15]==0)
      rst_cnt0 <= rst_cnt0+1;
   else if (rst_cnt0[15]==1 & dcm_locked[0]==0)
      rst_cnt0 <= 0;

   if (rst_cnt0[15:14]==0)
      rst_dcm0 <= 1;
   else
      rst_dcm0 <= 0;
end


DCM_CLKGEN #(
   .CLKFXDV_DIVIDE(2),       // CLKFXDV divide value (2, 4, 8, 16, 32)
   .CLKFX_DIVIDE(125),         // Divide value - D - (1-256)
   .CLKFX_MD_MAX(0.0),       // Specify maximum M/D ratio for timing anlysis
   .CLKFX_MULTIPLY(128),       // Multiply value - M - (2-256)
   .CLKIN_PERIOD(20.0),       // Input clock period specified in nS
   .SPREAD_SPECTRUM("NONE"), // Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD", "CENTER_HIGH_SPREAD",
                             // "VIDEO_LINK_M0", "VIDEO_LINK_M1" or "VIDEO_LINK_M2" 
   .STARTUP_WAIT("FALSE")    // Delay config DONE until DCM_CLKGEN LOCKED (TRUE/FALSE)
)
DCM_CLKGEN_0 (
   .CLKFX(dcm0_clkfx),         // 1-bit output: Generated clock output
   .CLKFX180(),   // 1-bit output: Generated clock output 180 degree out of phase from CLKFX.
   .CLKFXDV(),     // 1-bit output: Divided clock output
   .LOCKED(dcm_locked[0]),       // 1-bit output: Locked output
   .PROGDONE(),   // 1-bit output: Active high output to indicate the successful re-programming
   .STATUS(),       // 2-bit output: DCM_CLKGEN status
   .CLKIN(clk_in_bufg),         // 1-bit input: Input clock
   .FREEZEDCM(1'b0), // 1-bit input: Prevents frequency adjustments to input clock
   .PROGCLK(1'b0),     // 1-bit input: Clock input for M/D reconfiguration
   .PROGDATA(1'b0),   // 1-bit input: Serial data input for M/D reconfiguration
   .PROGEN(1'b0),       // 1-bit input: Active high program enable
   .RST(rst_dcm0)              // 1-bit input: Reset input pin
);

BUFG bufg_dcm0_clkfx (
   .O(dcm0_clkfx_bufg),
   .I(dcm0_clkfx)
);

wire cntr_rst;
assign cntr_rst = rst_in | ~dcm_locked[0];
reg [15:0] rst_cnt;
reg rst_dcm;
always @ (posedge dcm0_clkfx_bufg, posedge cntr_rst)
if (cntr_rst)
begin
   rst_cnt <= 0;
   rst_dcm <= 1;
end
else
begin
   if (rst_cnt[15]==0)
      rst_cnt <= rst_cnt+1;
   else if (rst_cnt[15]==1 & dcm_locked[1]==0)
      rst_cnt <= 0;

   if (rst_cnt[15:14]==0)
      rst_dcm <= 1;
   else
      rst_dcm <= 0;
end

wire dcm1_clkfx;
wire dcm1_clkfx_bufg;

DCM_CLKGEN #(
   .CLKFXDV_DIVIDE(2),       // CLKFXDV divide value (2, 4, 8, 16, 32)
   .CLKFX_DIVIDE(25),         // Divide value - D - (1-256)
   .CLKFX_MD_MAX(0.0),       // Specify maximum M/D ratio for timing anlysis
   .CLKFX_MULTIPLY(48),       // Multiply value - M - (2-256)
   .CLKIN_PERIOD(19.53125),       // Input clock period specified in nS
   .SPREAD_SPECTRUM("NONE"), // Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD", "CENTER_HIGH_SPREAD",
                             // "VIDEO_LINK_M0", "VIDEO_LINK_M1" or "VIDEO_LINK_M2" 
   .STARTUP_WAIT("FALSE")    // Delay config DONE until DCM_CLKGEN LOCKED (TRUE/FALSE)
)
DCM_CLKGEN_1 (
   .CLKFX(dcm1_clkfx),         // 1-bit output: Generated clock output
   .CLKFX180(),   // 1-bit output: Generated clock output 180 degree out of phase from CLKFX.
   .CLKFXDV(),     // 1-bit output: Divided clock output
   .LOCKED(dcm_locked[1]),       // 1-bit output: Locked output
   .PROGDONE(),   // 1-bit output: Active high output to indicate the successful re-programming
   .STATUS(),       // 2-bit output: DCM_CLKGEN status
   .CLKIN(dcm0_clkfx_bufg),         // 1-bit input: Input clock
   .FREEZEDCM(1'b0), // 1-bit input: Prevents frequency adjustments to input clock
   .PROGCLK(1'b0),     // 1-bit input: Clock input for M/D reconfiguration
   .PROGDATA(1'b0),   // 1-bit input: Serial data input for M/D reconfiguration
   .PROGEN(1'b0),       // 1-bit input: Active high program enable
   .RST(rst_dcm)              // 1-bit input: Reset input pin
);

BUFGMUX bufg_dcm1_clkfx (
   .O(dcm1_clkfx_bufg),
   .I0(1'b0),
   .I1(dcm1_clkfx),
   .S(dcm_locked[1])
);

reg [15:0] locked1_dl = 0;
always @ (posedge clk_out)
   locked1_dl <= {locked1_dl[14:0], dcm_locked[1]};

assign clk_out = dcm1_clkfx_bufg;
assign rst_out = ~locked1_dl[15];


assign dbg_locked = dcm_locked;

endmodule

