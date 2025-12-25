// top level pins shit
module controlchip(
//power
VDD, GND,
//i2s microphone
I2S_WS_RX_P, I2S_SCK_RX_P, I2S_SDI0_P, I2S_SDI1_P, I2S_SDI2_P, I2S_SDI3_P,
//i2s speaker
I2S_WS_TX_P, I2S_SCK_TX_P, I2S_SDO_P,
//clock reset
CCLK_P,RSTN_P,
//By Pass
BYP_P,BYP_GO_P,BYP_RDY_P,BYP_VLD_P,
//initialization
INIT_IN_P,
//scan
SCAN_EN_P,SCAN_O_P,
//not connected
NC_P
);



//Power Supplies
inout VDD, GND;
wire VDD, GND;

//ByPass Signals
input	[25:0]	BYP_P;
wire	[25:0]	BYP_P;
wire	[25:0]	BYP; // core
input BYP_VLD_P;
output BYP_GO_P, BYP_RDY_P;
wire BYP_GO_P,BYP_RDY_P,BYP_VLD_P;
wire BYP_GO,BYP_RDY,BYP_VLD;

//microphone
output	I2S_WS_RX_P, I2S_SCK_RX_P;
wire	I2S_WS_RX_P, I2S_SCK_RX_P;
wire	I2S_WS_RX, I2S_SCK_RX; // core
input	I2S_SDI0_P, I2S_SDI1_P, I2S_SDI2_P, I2S_SDI3_P;
wire	I2S_SDI0_P, I2S_SDI1_P, I2S_SDI2_P, I2S_SDI3_P;
wire	I2S_SDI0, I2S_SDI1, I2S_SDI2, I2S_SDI3; // core
//i2s speaker
output	I2S_WS_TX_P, I2S_SCK_TX_P, I2S_SDO_P;
wire	I2S_WS_TX_P, I2S_SCK_TX_P, I2S_SDO_P;
wire	I2S_WS_TX, I2S_SCK_TX, I2S_SDO; // core

//clock reset
input CCLK_P,RSTN_P;
wire CCLK_P,RSTN_P;
wire CCLK,RSTN; // core

//initialization
input INIT_IN_P;
wire INIT_IN_P;
wire INIT_IN; // core

//scan
input SCAN_EN_P;
output SCAN_O_P;
wire SCAN_EN_P,SCAN_O_P;
wire SCAN_EN,SCAN_O;

//not connected
output NC_P;
wire NC_P;
wire NC;

//PADs North
PVSS1DGZ_G	Driver_N01	();
PDDW16SDGZ_G	Driver_N02	(.PAD(I2S_WS_RX_P), .I(I2S_WS_RX), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_N03	(.PAD(I2S_SCK_RX_P), .I(I2S_SCK_RX), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_N04	(.PAD(I2S_SDI0_P), .C(I2S_SDI0), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_N05	(.PAD(I2S_SDI1_P), .C(I2S_SDI1), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_N06	(.PAD(I2S_SDI2_P), .C(I2S_SDI2), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_N07	(.PAD(I2S_SDI3_P), .C(I2S_SDI3), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVSS2DGZ_G	Driver_N08	();
PDDW16SDGZ_G	Driver_N09	(.PAD(I2S_WS_TX_P), .I(I2S_WS_TX), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_N10	(.PAD(I2S_SCK_TX_P), .I(I2S_SCK_TX), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_N11	(.PAD(I2S_SDO_P), .C(I2S_SDO), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVDD1DGZ_G	Driver_N12	(); 
PDDW16SDGZ_G	Driver_N13	(.PAD(CCLK_P), .I(CCLK), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_N14	(.PAD(RSTN_P), .I(RSTN), .OEN(1'b0), .REN(1'b0));
PVDD2DGZ_G	Driver_N15	();

//PADs East
PVSS1DGZ_G	Driver_E01	();
PVDD1DGZ_G	Driver_E02	();
PVSS2DGZ_G	Driver_E03	();
PVDD2DGZ_G	Driver_E04	();
PDDW16SDGZ_G	Driver_E05	(.PAD(BYP_P[0]), .C(BYP[0]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E06	(.PAD(BYP_P[1]), .C(BYP[1]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E07	(.PAD(BYP_P[2]), .C(BYP[2]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E08	(.PAD(BYP_P[3]), .C(BYP[3]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E09	(.PAD(BYP_P[4]), .C(BYP[4]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E10	(.PAD(BYP_P[5]), .C(BYP[5]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E11	(.PAD(BYP_P[6]), .C(BYP[6]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E12	(.PAD(BYP_P[7]), .C(BYP[7]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E13	(.PAD(BYP_P[8]), .C(BYP[8]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E14	(.PAD(BYP_P[9]), .C(BYP[9]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_E15	(.PAD(BYP_P[10]), .C(BYP[10]), .I(1'b0), .OEN(1'b1), .REN(1'b1));

//PADs South
PDDW16SDGZ_G    Driver_S01    (.PAD(BYP_P[11]), .C(BYP[11]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S02    (.PAD(BYP_P[12]), .C(BYP[12]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S03    (.PAD(BYP_P[13]), .C(BYP[13]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S04    (.PAD(BYP_P[14]), .C(BYP[14]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S05    (.PAD(BYP_P[15]), .C(BYP[15]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S06    (.PAD(BYP_P[16]), .C(BYP[16]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S07    (.PAD(BYP_P[17]), .C(BYP[17]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S08    (.PAD(BYP_P[18]), .C(BYP[18]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S09    (.PAD(BYP_P[19]), .C(BYP[19]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S10    (.PAD(BYP_P[20]), .C(BYP[20]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_S11    (.PAD(BYP_P[21]), .C(BYP[21]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVSS1DGZ_G		Driver_S12    (); 
PVDD1DGZ_G		Driver_S13    ();
PVSS2DGZ_G		Driver_S14    ();
PVDD2DGZ_G      Driver_S15    ();

//PADs West
PDDW16SDGZ_G    Driver_W01    (.PAD(BYP_P[22]), .C(BYP[22]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W02    (.PAD(BYP_P[23]), .C(BYP[23]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W03    (.PAD(BYP_P[24]), .C(BYP[24]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W04    (.PAD(BYP_P[25]), .C(BYP[25]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G	Driver_W05    (.PAD(BYP_GO_P), .I(BYP_GO), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G	Driver_W06    (.PAD(BYP_RDY_P), .I(BYP_RDY), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G    Driver_W07    (.PAD(BYP_VLD_P), .C(BYP_VLD), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W08    (.PAD(INIT_IN_P), .C(INIT_IN), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W09    (.PAD(SCAN_EN_P), .C(SCAN_EN), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW16SDGZ_G    Driver_W10    (.PAD(SCAN_O_P), .I(SCAN_O), .OEN(1'b0), .REN(1'b0));
PDDW16SDGZ_G    Driver_W11    (.PAD(NC_P), .I(1'b0), .OEN(1'b0), .REN(1'b0));
PVSS1DGZ_G	Driver_W12    (); 
PVDD1DGZ_G	Driver_W13    ();
PVSS2DGZ_G	Driver_W14    ();
PVDD2POC_G	Driver_W15    ();

// Instantiate the Chip Verilog Block 
hardware_top core (
//power
.VDD(VDD), .GND(GND),
//i2s mic
.I2S_WS_RX(I2S_WS_RX), .I2S_SCK_RX(I2S_SCK_RX), .I2S_SDI0(I2S_SDI0), .I2S_SDI1(I2S_SDI1),  .I2S_SDI2(I2S_SDI2),  .I2S_SDI3(I2S_SDI3),
//i2s speaker
.I2S_WS_TX(I2S_WS_TX), .I2S_SCK_TX(I2S_SCK_TX), .I2S_SDO(I2S_SDO),
//clock reset
.CCLK(CCLK),.RSTN(RSTN),
//By Pass
.BYP(BYP),.BYP_GO(BYP_GO),.BYP_RDY(BYP_RDY),.BYP_VLD(BYP_VLD),
//initialization
.INIT_IN(INIT_IN),
//scan
.SCAN_EN(SCAN_EN),.SCAN_O(SCAN_O)
);
endmodule


/*
//module controlchip( vd1p0, vd0p0, va1p0, va1p8, vd3p3, vd6p6, VDDPST, VSSPST, va1p0_PLL, va1p0_Drv, IPDin, EODrvOut, ExtDSM_in_P, SData_Out_P, PTAT_P1, PTAT_P2, ScanOut_P, VBN, VBP, VrefDrvPAD, VrefPLLPAD, VrefPTAT1, VresPTAT, pb_Out, vcm, vd1p0_50OhmDrv, PLLRstN_P, RSTN_P,RefClk_P,ScanClk_P,ScanIn_P,TestClk50Ohm, DivClkOut_P);

// Power Supplies
inout vd1p0, vd0p0, va1p0, va1p8, vd3p3, vd6p6, vd1p0_50OhmDrv, VDDPST, VSSPST, va1p0_PLL, va1p0_Drv;
wire  vd1p0, vd0p0, va1p0, va1p8, vd3p3, vd6p6, vd1p0_50OhmDrv, VDDPST, VSSPST, va1p0_PLL, va1p0_Drv ;

// Digital Signals

input [21:0] ExtDSM_in_P ;

wire [21:0] ExtDSM_in_P ;

output [39:0] SData_Out_P ;

wire [39:0] SData_Out_P ;

output DivClkOut_P, ScanOut_P ;

wire DivClkOut_P, ScanOut_P ;

input PLLRstN_P, RSTN_P, RefClk_P, ScanClk_P, ScanIn_P ;

wire PLLRstN_P, RSTN_P, RefClk_P, ScanClk_P, ScanIn_P ;

//Bias Voltages (Core Analog Voltage)

inout VBN, VBP, pb_Out ;

wire VBN, VBP, pb_Out ;


//LDO References

inout VrefDrvPAD, VrefPLLPAD ;

wire VrefDrvPAD, VrefPLLPAD ;

// Ref & Resistor Connection for PTAT Bias

inout VrefPTAT1, VresPTAT;

wire VrefPTAT1, VresPTAT; 

//VCM reference for ADC

inout vcm ;
wire vcm ;

// 50 Ohm Clock

inout  TestClk50Ohm ;

wire  TestClk50Ohm ;

// Photodetector Input

inout [39:0] IPDin ;

wire [39:0] IPDin ;

// EoDrv Output (Note this is 6.6V)

inout [39:0] EODrvOut ;

wire [39:0] EODrvOut ;



wire [39:0] ExtDSM_in;
wire [39:0] SDataOut;
wire  RSTN, RefClk, ScanClk, ScanIn;




//Floating bumps for ptat temperature sensor on PIC
wire PTAT_P1,  PTAT_P2;
inout PTAT_P1, PTAT_P2;


// PVDD1DGZ Core VDD High VOltage Tolerant (CDG non high voltage tolerant)
// PIN: VDD
// PVDD2DGZ Post- Drivers (i.e PAD) VDDPST (Tie to VDD 3.3, 2.5,1.8)
// PIN: VDDPST
//
// PVSS1DGZ Core GNDD High VOltage Tolerant (CDG non high voltage tolerant)
// PIN: VSS
// PVSS2DGZ Post- Drivers (i.e PAD) VSSPST (Tie to ground)
// PIN : VSSPST

//Mandatory to Use one an Only oNe PVDD2POC cell in each digital Domain
//
// PVDD1ANA : Dedicated Analog Supply for MACROS such as PLLs (Does not need a PRCut to isolate in PADring)
// PIN: AVDD
//
// PVSS1ANA : Ground PAD
// PIN: AVSS
// Need PCLAMP if PVDD1Ana is used with PVSS1ANA

// For High Voltage Analog Blocks use PVDD2ANA (This cannot be used to connect Core VOltage levels)
// PIN: AVDD

// PVSS2ANA : Ground PAD
// PIN: AVSS

// FOR Isolated Domain (using PRCUT)
//FOR optimal Results PRCUTA must be placed adjacent to PVDD1DGZ on the digital side
// 
//Analog Core VOltage I/O
//PDB3AC
// Power PIN: TACVDD
// GND Pin: VSS
// SIG PIN: AIO

//High Voltage Analog I/O
//PDB3A
// POWER PIN: TAVDD
// GND PIN : VSS
// SIG PIN: AIO


//PVDD3A/AC
//VDD Pin connected to TAVDD or TACVDD

//PVSS3A/AC
// VSS Connection (Floating must use PVSS1DGZ) 
 
//_G suffix referes to Staggered PAD layout

//PADs North

PDDW04SDGZ_G	Driver_N01	(.PAD(ExtDSM_in_P[19]), .C(ExtDSM_in[19]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N02	(.PAD(SData_Out_P[19]), .I(SData_Out[19]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N03	(.PAD(ExtDSM_in_P[20]), .C(ExtDSM_in[20]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N04	(.PAD(SData_Out_P[20]), .I(SData_Out[20]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N05	(.PAD(ExtDSM_in_P[21]), .C(ExtDSM_in[21]), .I(1'b0), .OEN(1'b1), .REN(1'b1)); 
PDDW04SDGZ_G	Driver_N06	(.PAD(SData_Out_P[21]), .I(SData_Out[21]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N07	(.PAD(ExtDSM_in_P[22]), .C(ExtDSM_in[22]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N08	(.PAD(SData_Out_P[22]), .I(SData_Out[22]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N09	(.PAD(ExtDSM_in_P[23]), .C(ExtDSM_in[23]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N10	(.PAD(SData_Out_P[23]), .I(SData_Out[23]), .OEN(1'b0), .REN(1'b0));
PVSS1DGZ_G	    Driver_N11	(); 
PVDD1DGZ_G	    Driver_N12	(); 
PVDD2DGZ_G	    Driver_N13	(); 
PVSS2DGZ_G	    Driver_N14	(); 
PDDW04SDGZ_G	Driver_N15  (.PAD(ExtDSM_in_P[24]), .C(ExtDSM_in[24]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N16  (.PAD(SData_Out_P[24]), .I(SData_Out[24]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N17  (.PAD(ExtDSM_in_P[25]), .C(ExtDSM_in[25]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N18  (.PAD(SData_Out_P[25]), .I(SData_Out[25]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N19  (.PAD(ExtDSM_in_P[26]), .C(ExtDSM_in[26]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N20  (.PAD(SData_Out_P[26]), .I(SData_Out[26]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N21	(.PAD(ExtDSM_in_P[27]), .C(ExtDSM_in[27]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N22	(.PAD(SData_Out_P[27]), .I(SData_Out[27]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N23	(.PAD(ExtDSM_in_P[28]), .C(ExtDSM_in[28]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N24	(.PAD(SData_Out_P[28]), .I(SData_Out[28]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N25	(.PAD(ExtDSM_in_P[29]), .C(ExtDSM_in[29]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N26	(.PAD(SData_Out_P[29]), .I(SData_Out[29]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N27	(.PAD(ExtDSM_in_P[30]), .C(ExtDSM_in[30]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N28	(.PAD(SData_Out_P[30]), .I(SData_Out[30]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N29	(.PAD(ExtDSM_in_P[31]), .C(ExtDSM_in[31]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N30	(.PAD(SData_Out_P[31]), .I(SData_Out[31]), .OEN(1'b0), .REN(1'b0));
PVSS1DGZ_G	Driver_N31	();
PVDD1DGZ_G	Driver_N32	();
PVDD2DGZ_G	Driver_N33	();
PVSS2DGZ_G	Driver_N34	();
PDDW04SDGZ_G	Driver_N35	(.PAD(ExtDSM_in_P[32]), .C(ExtDSM_in[32]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N36	(.PAD(SData_Out_P[32]), .I(SData_Out[32]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N37	(.PAD(ExtDSM_in_P[33]), .C(ExtDSM_in[33]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N38	(.PAD(SData_Out_P[33]), .I(SData_Out[33]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N39	(.PAD(ExtDSM_in_P[34]), .C(ExtDSM_in[34]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N40	(.PAD(SData_Out_P[34]), .I(SData_Out[34]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N41	(.PAD(ExtDSM_in_P[35]), .C(ExtDSM_in[35]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N42	(.PAD(SData_Out_P[35]), .I(SData_Out[35]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N43	(.PAD(ExtDSM_in_P[36]), .C(ExtDSM_in[36]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N44	(.PAD(SData_Out_P[36]), .I(SData_Out[36]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N45	(.PAD(ExtDSM_in_P[37]), .C(ExtDSM_in[37]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N46	(.PAD(SData_Out_P[37]), .I(SData_Out[37]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N47	(.PAD(ExtDSM_in_P[38]), .C(ExtDSM_in[38]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N48	(.PAD(SData_Out_P[38]), .I(SData_Out[38]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N49	(.PAD(ExtDSM_in_P[39]), .C(ExtDSM_in[39]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_N50	(.PAD(SData_Out_P[39]), .I(SData_Out[39]), .OEN(1'b0), .REN(1'b0));
PVSS1DGZ_G	Driver_N51	(); 
PVDD1DGZ_G	Driver_N52	();
PVDD2DGZ_G	Driver_N53	();
PVSS2DGZ_G	Driver_N54	();
PDDW04SDGZ_G	Driver_N55	(.PAD(DivClkOut_P), .I(DivClkOut), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G	Driver_N56	(.PAD(ScanOut_P), .I(ScanOut), .OEN(1'b0), .REN(1'b0));


//East PADs

PDDW04SDGZ_G	Driver_E01	(.PAD(PLLRstN_P), .C(PLLRstN), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_E02	(.PAD(RSTN_P), .C(RSTN), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_E03	(.PAD(RefClk_P), .C(RefClk), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_E04	(.PAD(ScanClk_P), .C(ScanClk), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G	Driver_E05	(.PAD(ScanIn_P), .C(ScanIn), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVDD2DGZ_G	Driver_E06	();
PVSS2DGZ_G	Driver_E07	();
PVSS1DGZ_G	Driver_E08	();
PVDD1DGZ_G	Driver_E09	();
PRCUTA_G	Driver_E10	();
PVDD3A_G	Driver_E11	(.TAVDD(vd3p3));
PVSS3A_G	Driver_E12	();
PVBUS_G	    Driver_E13	(.VBUS(vd6p6));
PVBUS_G	    Driver_E14	(.VBUS(EODrvOut[0]));
PVBUS_G	    Driver_E15	(.VBUS(EODrvOut[1]));
PVBUS_G	    Driver_E16	(.VBUS(EODrvOut[2]));
PVBUS_G	    Driver_E17	(.VBUS(EODrvOut[3]));
PVBUS_G	    Driver_E18	(.VBUS(EODrvOut[4]));
PVBUS_G	    Driver_E19	(.VBUS(EODrvOut[5]));
PVBUS_G	    Driver_E20	(.VBUS(EODrvOut[6]));
PVBUS_G	    Driver_E21	(.VBUS(EODrvOut[7]));
PVBUS_G	    Driver_E22	(.VBUS(vd6p6));
PVSS3A_G    Driver_E23	();
PVBUS_G	    Driver_E24	(.VBUS(EODrvOut[8]));
PVBUS_G	    Driver_E25	(.VBUS(EODrvOut[9]));
PVBUS_G	    Driver_E26	(.VBUS(EODrvOut[10]));
PVBUS_G	    Driver_E27	(.VBUS(EODrvOut[11]));
PVBUS_G	    Driver_E28	(.VBUS(EODrvOut[12]));
PVBUS_G	    Driver_E29	(.VBUS(EODrvOut[13]));
PVBUS_G	    Driver_E30	(.VBUS(EODrvOut[14]));
PVBUS_G	    Driver_E31	(.VBUS(EODrvOut[15]));
PVDD3A_G	Driver_E32	(.TAVDD(vd3p3));
PVSS3A_G    Driver_E33	();
PVBUS_G	    Driver_E34	(.VBUS(EODrvOut[16]));
PVBUS_G	    Driver_E35	(.VBUS(EODrvOut[17]));
PVBUS_G	    Driver_E36	(.VBUS(EODrvOut[18]));
PVBUS_G	    Driver_E37	(.VBUS(EODrvOut[19]));
PVBUS_G	    Driver_E38	(.VBUS(EODrvOut[20]));
PVBUS_G	    Driver_E39	(.VBUS(EODrvOut[21]));
PVBUS_G	    Driver_E40	(.VBUS(EODrvOut[22]));
PVBUS_G	    Driver_E41	(.VBUS(EODrvOut[23]));
PVBUS_G	    Driver_E42	(.VBUS(vd6p6));
PVSS3A_G    Driver_E43	();
PVBUS_G	    Driver_E44	(.VBUS(EODrvOut[24]));
PVBUS_G	    Driver_E45	(.VBUS(EODrvOut[25]));
PVBUS_G	    Driver_E46	(.VBUS(EODrvOut[26]));
PVBUS_G	    Driver_E47	(.VBUS(EODrvOut[27]));
PVBUS_G	    Driver_E48	(.VBUS(EODrvOut[28]));
PVBUS_G	    Driver_E49	(.VBUS(EODrvOut[29]));
PVBUS_G	    Driver_E50	(.VBUS(EODrvOut[30]));
PVBUS_G	    Driver_E51	(.VBUS(EODrvOut[31]));
PVDD3A_G	Driver_E52	(.TAVDD(vd3p3));
PVSS3A_G    Driver_E53	();
PVBUS_G	    Driver_E54	(.VBUS(EODrvOut[32]));
PVBUS_G	    Driver_E55	(.VBUS(EODrvOut[33]));
PVBUS_G	    Driver_E56	(.VBUS(EODrvOut[34]));
PVBUS_G	    Driver_E57	(.VBUS(EODrvOut[35]));
PVBUS_G	    Driver_E58	(.VBUS(EODrvOut[36]));
PVBUS_G	    Driver_E59	(.VBUS(EODrvOut[37]));
PVBUS_G	    Driver_E60	(.VBUS(EODrvOut[38]));
PVBUS_G	    Driver_E61	(.VBUS(EODrvOut[39]));
PVBUS_G	    Driver_E62	(.VBUS(vd6p6));
PVSS3A_G	Driver_E63	();
PRCUTA_G	Driver_E64	();
PVDD3AC_G	Driver_E65	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_E66	();
PDB3AC_G	Driver_E67	(.AIO(pb_Out));

// PADs South

		
PDB3AC_G	Driver_S01	(.AIO(PTAT_P1));
PDB3AC_G	Driver_S02	(.AIO(PTAT_P2));
PDB3AC_G	Driver_S03	(.AIO(VrefPTAT));
PDB3AC_G	Driver_S04	(.AIO(VresPTAT));
PDB3AC_G	Driver_S05	(.AIO(IPDin[0]));
PDB3AC_G	Driver_S06	(.AIO(IPDin[1]));
PVDD3AC_G	Driver_S07	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_S08	();
PDB3AC_G	Driver_S09	(.AIO(IPDin[2]));
PDB3AC_G	Driver_S10	(.AIO(IPDin[3]));
PDB3AC_G	Driver_S11	(.AIO(IPDin[4]));
PDB3AC_G	Driver_S12	(.AIO(IPDin[5]));
PDB3AC_G	Driver_S13	(.AIO(IPDin[6]));
PDB3AC_G	Driver_S14	(.AIO(IPDin[7]));
PDB3AC_G	Driver_S15	(.AIO(IPDin[8]));
PVDD3AC_G	Driver_S16	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_S17	();
PDB3AC_G	Driver_S18	(.AIO(IPDin[9]));
PDB3AC_G	Driver_S19	(.AIO(IPDin[10]));
PDB3AC_G	Driver_S20	(.AIO(IPDin[11]));
PDB3AC_G	Driver_S21	(.AIO(IPDin[12]));
PDB3AC_G	Driver_S22	(.AIO(IPDin[13]));
PDB3AC_G	Driver_S23	(.AIO(IPDin[14]));
PDB3AC_G	Driver_S24	(.AIO(IPDin[15]));
PDB3AC_G	Driver_S25	(.AIO(IPDin[16]));
PVDD3AC_G	Driver_S26	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_S27	();
PDB3AC_G	Driver_S28	(.AIO(IPDin[17]));
PDB3AC_G	Driver_S29	(.AIO(IPDin[18]));
PDB3AC_G	Driver_S30	(.AIO(IPDin[19]));
PDB3AC_G	Driver_S31	(.AIO(IPDin[20]));
PDB3AC_G	Driver_S32	(.AIO(IPDin[21]));
PDB3AC_G	Driver_S33	(.AIO(IPDin[22]));
PDB3AC_G	Driver_S34	(.AIO(IPDin[23]));
PDB3AC_G	Driver_S35	(.AIO(IPDin[24]));
PVDD3AC_G	Driver_S36	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_S37	(.TACVSS(vd0p0));
PDB3AC_G	Driver_S38	(.AIO(IPDin[25]));
PDB3AC_G	Driver_S39	(.AIO(IPDin[26]));
PDB3AC_G	Driver_S40	(.AIO(IPDin[27]));
PDB3AC_G	Driver_S41	(.AIO(IPDin[28]));
PDB3AC_G	Driver_S42	(.AIO(IPDin[29]));
PDB3AC_G	Driver_S43	(.AIO(IPDin[30]));
PDB3AC_G	Driver_S44	(.AIO(IPDin[31]));
PDB3AC_G	Driver_S45	(.AIO(IPDin[32]));
PVDD3AC_G	Driver_S46	(.TACVDD(va1p0_Drv));
PVSS3AC_G	Driver_S47	(.TACVSS(vd0p0));
PDB3AC_G	Driver_S48	(.AIO(IPDin[33]));
PDB3AC_G	Driver_S49	(.AIO(IPDin[34]));
PDB3AC_G	Driver_S50	(.AIO(IPDin[35]));
PDB3AC_G	Driver_S51	(.AIO(IPDin[36]));
PDB3AC_G	Driver_S52	(.AIO(IPDin[37]));
PDB3AC_G	Driver_S53	(.AIO(IPDin[38]));
PDB3AC_G	Driver_S54	(.AIO(IPDin[39]));
PVSS3AC_G	Driver_S55	(.TACVSS(vd0p0));
PVDD3AC_G	Driver_S56	(.TACVDD(va1p0_Drv));

//PADs West

PVDD1DGZ		Driver_W67	();
PDDW04SDGZ_G		Driver_W66	(.PAD(SData_Out_P[18]), .I(SData_Out[18]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W65	(.PAD(ExtDSM_in_P[18]), .C(ExtDSM_in[18]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W64	(.PAD(SData_Out_P[17]), .I(SData_Out[17]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W63	(.PAD(ExtDSM_in_P[17]), .C(ExtDSM_in[17]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W62	(.PAD(SData_Out_P[16]), .I(SData_Out[16]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W61	(.PAD(ExtDSM_in_P[16]), .C(ExtDSM_in[16]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVSS1DGZ_G		Driver_W60	();
PVDD1DGZ_G		Driver_W59	();
PVDD2DGZ_G		Driver_W58	();
PVSS2DGZ_G		Driver_W57	();
PDDW04SDGZ_G		Driver_W56	(.PAD(SData_Out_P[15]), .I(SData_Out[15]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W55	(.PAD(ExtDSM_in_P[15]), .C(ExtDSM_in[15]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W54	(.PAD(SData_Out_P[14]), .I(SData_Out[14]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W53	(.PAD(ExtDSM_in_P[14]), .C(ExtDSM_in[14]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W52	(.PAD(SData_Out_P[13]), .I(SData_Out[13]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W51	(.PAD(ExtDSM_in_P[13]), .C(ExtDSM_in[13]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W50	(.PAD(SData_Out_P[12]), .I(SData_Out[12]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W49	(.PAD(ExtDSM_in_P[12]), .C(ExtDSM_in[12]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W48	(.PAD(SData_Out_P[11]), .I(SData_Out[11]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W47	(.PAD(ExtDSM_in_P[11]), .C(ExtDSM_in[11]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W46	(.PAD(SData_Out_P[10]), .I(SData_Out[10]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W45	(.PAD(ExtDSM_in_P[10]), .C(ExtDSM_in[10]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W44	(.PAD(SData_Out_P[09]), .I(SData_Out[09]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W43	(.PAD(ExtDSM_in_P[09]), .C(ExtDSM_in[09]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W42	(.PAD(SData_Out_P[08]), .I(SData_Out[08]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W41	(.PAD(ExtDSM_in_P[08]), .C(ExtDSM_in[08]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVSS1DGZ_G		    Driver_W40	();
PVDD1DGZ_G		    Driver_W39	();
PVDD2POC_G		    Driver_W38	();
PVSS2DGZ_G		    Driver_W37	();
PDDW04SDGZ_G		Driver_W36	(.PAD(SData_Out_P[07]), .I(SData_Out[07]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W35	(.PAD(ExtDSM_in_P[07]), .C(ExtDSM_in[07]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W34	(.PAD(SData_Out_P[06]), .I(SData_Out[06]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W33	(.PAD(ExtDSM_in_P[06]), .C(ExtDSM_in[06]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W32	(.PAD(SData_Out_P[05]), .I(SData_Out[05]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W31	(.PAD(ExtDSM_in_P[05]), .C(ExtDSM_in[05]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W30	(.PAD(SData_Out_P[04]), .I(SData_Out[04]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W29	(.PAD(ExtDSM_in_P[04]), .C(ExtDSM_in[04]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W28	(.PAD(SData_Out_P[03]), .I(SData_Out[03]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W27	(.PAD(ExtDSM_in_P[03]), .C(ExtDSM_in[03]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W26	(.PAD(SData_Out_P[02]), .I(SData_Out[02]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W25	(.PAD(ExtDSM_in_P[02]), .C(ExtDSM_in[02]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W24	(.PAD(SData_Out_P[01]), .I(SData_Out[01]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W23	(.PAD(ExtDSM_in_P[01]), .C(ExtDSM_in[01]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PDDW04SDGZ_G		Driver_W22	(.PAD(SData_Out_P[00]), .I(SData_Out[00]), .OEN(1'b0), .REN(1'b0));
PDDW04SDGZ_G		Driver_W21	(.PAD(ExtDSM_in_P[00]), .C(ExtDSM_in[00]), .I(1'b0), .OEN(1'b1), .REN(1'b1));
PVSS1DGZ_G		Driver_W20	();
PVDD1DGZ_G		Driver_W19	();
PVDD2DGZ_G		Driver_W18	();
PVSS2DGZ_G		Driver_W17	();
PVDD2ANA_G		Driver_W16	(.AVDD(va1p8));
PVDD2ANA_G		Driver_W15	(.AVDD(va1p8));
PVSS2DGZ_G		Driver_W14	();
PVDD2ANA_G		Driver_W13	(.AVDD(va1p8));
PVSS1DGZ_G		Driver_W12	();
PVDD1ANA_G		Driver_W11	(.AVDD(vd1p0_50OhmDrv));
PRCUTA_G		Driver_W10	();
PDB3AC_G		Driver_W09	(.AIO(TestClk50Ohm));
PDB3AC_G		Driver_W08	(.AIO(VBN));
PDB3AC_G		Driver_W07	(.AIO(VBP));
PDB3AC_G		Driver_W06	(.AIO(VrefPLLPAD));
PVSS3AC_G		Driver_W05	();
PVDD3AC_G		Driver_W04	(.TACVDD(va1p0_PLL));
PRCUTA_G		Driver_W03	();
PDB3AC_G		Driver_W02	(.AIO(VrefDrvPAD));
PDB3AC_G		Driver_W01	(.AIO(vcm));
			
// Instantiate the Chip Verilog Block 

CTL_Chip core ( .DivClkOut(DivClkOut),.SDataOut(SDataOut),.EoDrvOut(EODrvOut),.ExtDSM_in(ExtDSM_in),.IPDin(IPDin), .ScanOut(ScanOut), .PTAT_P1(PTAT_P1), .PTAT_P2(PTAT_P2),.VBN(VBN), .VBP(VBP), .VrefDrvPAD(VrefDrvPAD), .VrefPLLPAD(VrefPLLPAD),.VrefPTAT(VrefPTAT1), .VresPTAT(VresPTAT), .pb_Out(pb_Out),.va1p0_Drv(va1p0), .va1p0_PLL(va1p0_PLL), .va1p8(vdio2p5), .vcm(vcm), .vd1p0(vd1p0), .vd1p0_50OhmDrv(vd1p0_50OhmDrv), .vd3p3(vd3p3),.vd6p6(vd6p6), .PLLRstN(PLLRstN), .RSTN(RSTN),.RefClk(RefClk), .ScanClk(ScanClk), .ScanIn(ScanIn), .TestClk50Ohm(TestClk50Ohm));

endmodule
*/
