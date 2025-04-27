-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor Pipeline 
-- implementation.

-- 03/27/2025
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;
entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- : Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- : use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- : use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- : use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- : use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- : use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- : use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- : use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- : use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- : use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- : this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- : this signal indicates an overflow exception would have been initiated





 -------------------------------------------------Signals added by me below 
 signal s_Dummy : std_logic; --Dummy signal

--------------------------------------------------------------------Below is signals for my Pipeline Processor
--Signals needed for the IF Stage of the processor
signal s1_PCPlus4 : std_logic_vector (31 downto 0);
--Signals needed for the ID Stage of the processor
signal s2_Inst : std_logic_vector (31 downto 0);
signal s1_InstSL2 : std_logic_vector (31 downto 0);
signal s2_PCPlus4 : std_logic_vector (31 downto 0);
signal s_SignExtndIm		: std_logic;
signal s3_Inst : std_logic_vector (31 downto 0);
signal s1_ReadData1: std_logic_vector (31 downto 0);
signal s1_DMemData     : std_logic_vector(N-1 downto 0);
signal s1_JumpSelect 		: std_logic;
signal s1_JRSelect			: std_logic;
signal s1_Branch			: std_logic;
signal s1_StoreHalt   : std_logic;
signal s1_Bne				: std_logic;
signal s1_OvfEn				: std_logic;
signal s1_SignExtndLoad		: std_logic;
signal s1_MemtoReg			: std_logic;
signal s1_AluSrc			: std_logic;
signal s1_ShiftType			: std_logic_vector(1 downto 0);
signal s1_LoadAmt : 			std_logic_vector (1 downto 0);
signal s1_DmemWr			: std_logic;
signal s1_AluControl		: std_logic_vector(3 downto 0);
signal s1_RegWr			: std_logic;
signal s1_RegDest			: std_logic;
signal s1_JALSelect         : std_logic;
--Signals needed for the EXE Stage of the processor
signal s2_JRSelect			: std_logic;
signal s2_JumpSelect 		: std_logic;
signal s2_InstSL2 : std_logic_vector (31 downto 0);
signal s3_PCPlus4 : std_logic_vector (31 downto 0);
signal s_Branching: std_logic_vector(31 downto 0);
signal s2_Branch			: std_logic;
signal s2_Bne				: std_logic;
signal s_XorOut : std_logic;
signal s_AndOut : std_logic;
signal s_NotJump  : std_logic_vector(31 downto 0);
signal s_NotJR  : std_logic_vector(31 downto 0);
signal s1_intoPC : std_logic_vector(31 downto 0);
signal s_AluZero :std_logic; 
signal s1_StoreOvfl :std_logic; 
signal s1_StoreResult : std_logic_vector (31 downto 0);
signal s2_OvfEn				: std_logic;
signal s2_ReadData1: std_logic_vector (31 downto 0);
signal s2_AluSrc			: std_logic;
signal s2_ShiftType			: std_logic_vector(1 downto 0);
signal s2_DMemData     : std_logic_vector(N-1 downto 0);
signal s_Im32Bit : std_logic_vector(31 downto 0);
signal s_Im32bitShifted : std_logic_vector(31 downto 0);
signal s2_AluControl		: std_logic_vector(3 downto 0);
signal s2_DmemWr			: std_logic;
signal s2_LoadAmt : 			std_logic_vector (1 downto 0);
signal s2_SignExtndLoad		: std_logic;
signal s2_MemtoReg			: std_logic;
signal s2_JALSelect         : std_logic;
signal s2_RegDest			: std_logic;
signal s4_Inst : std_logic_vector (9 downto 0);
signal s2_RegWr			: std_logic;
signal s2_StoreHalt   : std_logic;
signal s3_RegInst : std_logic_vector(31 downto 0);
--Signals needed for the MEM Stage of the processor
signal s3_SignExtndLoad		: std_logic;
signal s3_LoadAmt : 			std_logic_vector (1 downto 0);
signal s1_load : std_logic_vector (31 downto 0);
signal s2_StoreResult : std_logic_vector (31 downto 0);
signal s5_Inst : std_logic_vector (9 downto 0);
signal s3_RegDest			: std_logic;
signal s3_JALSelect         : std_logic;
signal s2_StoreOvfl :std_logic; 
signal s3_MemtoReg			: std_logic;
signal s4_PCPlus4 : std_logic_vector (31 downto 0);
signal s2_intoPC : std_logic_vector(31 downto 0);
signal s3_RegWr			: std_logic;
signal s3_StoreHalt   : std_logic;
signal s3_DmemWr			: std_logic;
signal s4_RegInst : std_logic_vector(31 downto 0);
--Signals needed for the WB Stage of the processor
signal s3_intoPC : std_logic_vector(31 downto 0);
signal s4_MemtoReg			: std_logic;
signal s2_load : std_logic_vector (31 downto 0);
signal s_RegularData :std_logic_vector(31 downto 0);
signal s5_PCPlus4 : std_logic_vector (31 downto 0);
signal s4_JALSelect         : std_logic;
signal s4_RegDest			: std_logic;
signal s6_Inst : std_logic_vector (9 downto 0); 
signal s_RegMuxOut : std_logic_vector (4 downto 0);

signal s5_RegInst : std_logic_vector(31 downto 0);

-- Additional Registers outputs
signal s_IFIDout : std_logic_vector (63 downto 0);
signal s_IDEXEout : std_logic_vector (212 downto 0);
signal s_EXEMEMout : std_logic_vector (179 downto 0);
signal s_MEMWBout : std_logic_vector (175 downto 0);



--Added for HDU
signal s_stall         : std_logic;

signal controlOut_StoreHalt         : std_logic;
signal controlOut_RegDest         : std_logic;
signal controlOut_JumpSelect         : std_logic;
signal controlOut_JRSelect         : std_logic;
signal controlOut_Branch         : std_logic;
signal controlOut_LoadAmt         : std_logic_vector (1 downto 0);
signal controlOut_Bne         : std_logic;
signal controlOut_MemtoReg         : std_logic;
signal controlOut_AluControl         : std_logic_vector(3 downto 0);
signal controlOut_DMemWr         : std_logic;
signal controlOut_AluSrc         : std_logic;
signal controlOut_SignExtndIm         : std_logic;
signal controlOut_SignExtndLoad         : std_logic;
signal controlOut_RegWr         : std_logic;
signal controlOut_JALSelect         : std_logic;
signal controlOut_OvfEn         : std_logic;
signal controlOut_ShiftType         : std_logic_vector (1 downto 0);

signal s_flush : std_logic;
--Below for forwarding unit
signal s_ForwardA : std_logic_vector(1 downto 0);
signal s_ForwardB : std_logic_vector(1 downto 0);
signal s_ForwardC : std_logic;
signal s_RTorRD_MEM : std_logic_vector(4 downto 0);
signal s_RTorRD_WB : std_logic_vector(4 downto 0);

-------------PC 32 bit register
component N_bit_registerPC is
	generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       i_RST_VAL  : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));
 end component;
-------------2t1_Nbit Mux
component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;
-------------Adder
component addersubtractor is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(nAdd_Sub          : in std_logic;
       i_A          : in std_logic_vector(N-1 downto 0);
	   i_B          : in std_logic_vector(N-1 downto 0);
	   o_result          : out std_logic_vector(N-1 downto 0);
	   c_out31 : out std_logic;
	   overflow       : out std_logic);
end component;
-------------and2
component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;
--------------xor2
component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;
--------------ALU
component ALU is
  port(i_A          : in std_logic_vector(31 downto 0);
	   i_B          : in std_logic_vector(31 downto 0);
	   i_Im          : in std_logic_vector(31 downto 0);
       i_ALUSrc         : in std_logic;
	   i_OvfEn       :in std_logic;
	   i_ShiftType    : in std_logic_vector(1 downto 0);
       i_Shamt         : in std_logic_vector(4 downto 0);
	   i_ALUControl   :in std_logic_vector (3 downto 0); -- Bit 3 is the Add/Sub bit.
	   o_Ovf          : out std_logic;
	   o_Zero          : out std_logic;
       o_Result          : out std_logic_vector(31 downto 0));
end component;
--------------Register file
component RegFile is
  port(iCLK               : in std_logic;
       i_D 		            : in std_logic_vector(31 downto 0);
       i_rs 		            : in std_logic_vector(4 downto 0);
       i_rt 		          : in std_logic_vector(4 downto 0);
       i_rd  	   				: in std_logic_vector(4 downto 0);
	   i_rst  	   				: in std_logic;
	   i_wen  	   				: in std_logic;
       o_rs 		            : out std_logic_vector(31 downto 0);
       o_rt 		            : out std_logic_vector(31 downto 0));

end component;
--------------Loadselector
component LoadSelector is
  port(i_SignS        : in std_logic;     --when 1 it is signed. 
       i_LoadAmt        : in std_logic_vector(1 downto 0);
	   i_Data        : in std_logic_vector(31 downto 0);
	   i_PosSelect        : in std_logic_vector(1 downto 0);
       o_O        : out std_logic_vector(31 downto 0));  
end component;
--------------Sign Extender
component Extender16t32 is
  port(i_E        : in std_logic_vector(15 downto 0);     -- input
       i_S        : in std_logic;     			  -- Select 0 for zero extend, 1 for signed. 
       o_E        : out std_logic_vector(31 downto 0));   --Output

end component;
---------------Control
component control is
  port(i_OpCode 	: in std_logic_vector(5 downto 0);
	   i_FunctCode 	: in std_logic_vector(5 downto 0);
	   o_Halt 		: out std_logic;
	   o_RegDest	: out std_logic;
	   o_JumpSelect : out std_logic;
	   o_JRSelect	: out std_logic;
	   o_Branch		: out std_logic;
	   o_LoadAmt	: out std_logic_vector(1 downto 0);
	   o_Bne		: out std_logic;
	   o_MemToReg	: out std_logic;
	   o_AluControl : out std_logic_vector(3 downto 0);
	   o_DmemWr		: out std_logic;
	   o_AluSrc		: out std_logic;
	   o_SignExtendIm: out std_logic;
	   o_SignExtendLoad: out std_logic;
	   o_RegWr		: out std_logic;
	   o_JalSelect        : out std_logic;
	   o_OvfEn      : out std_logic;
	   o_ShiftType : out std_logic_vector(1 downto 0) );
end component;

--Mem Component
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;


--HDU Component
component HDU is
  port( i_jumping         : in std_logic;
	i_BranchTaken     : in std_logic;
	i_ID_rt          : in std_logic_vector(4 downto 0);
	i_ID_rs          : in std_logic_vector(4 downto 0);
	i_EXE_rt          : in std_logic_vector(4 downto 0);
	i_EXE_RegWr          : in std_logic;
	i_EXE_MemtoReg         : in std_logic;
        o_stall          : out std_logic;
	o_flush          :out std_logic);
end component;


component N_bit_registerStage is
	generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       i_RST_VAL  : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));
 end component;


--Forwarding unit

component ForwardingUnit is
  port( i_RegWr_MEM    : in std_logic;
	i_RS_EXE       : in std_logic_vector(4 downto 0);
	i_RTorRD_MEM   : in std_logic_vector(4 downto 0);
	i_RegWr_WB     : in std_logic;
	i_RTorRD_WB    : in std_logic_vector(4 downto 0);
	i_RT_EXE       : in std_logic_vector(4 downto 0);
	i_DMemWr_MEM   : in std_logic;
	i_RT_MEM       : in std_logic_vector(4 downto 0);
	o_ForwardA          :out std_logic_vector(1 downto 0);
        o_ForwardB          : out std_logic_vector(1 downto 0);
	o_ForwardC          :out std_logic);
 end component;



begin

  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU]
 -- TODO ENSURE THAT RESULT IS HOOKED UP TOO!
  -----------------------------------------------------TODO REWIRE BELOW TO MATCH MY SCHEMATIC
--IF
PC : N_bit_registerPC
	generic MAP(32)
    port MAP(iCLK, iRST, (s_stall OR s_flush), s1_intoPC, x"00400000", s_NextInstAddr);



PCAdder: addersubtractor
	generic MAP(32)
    port MAP('0', s_NextInstAddr, x"00000004", s1_PCPlus4, s_Dummy, s_Dummy); 

IFID : N_bit_registerStage
	generic MAP(64)
    port MAP(iCLK, (s_flush OR iRST), s_stall, s_Inst & s1_PCPlus4, x"0000000000000000", s_IFIDout);




BranchMux: mux2t1_N
	generic MAP(32)
    port MAP(s_AndOut, s1_PCPlus4, s_Branching, s_NotJump);

JumpMux: mux2t1_N
	generic MAP(32)
    port MAP(s2_JumpSelect, s_NotJump, s2_InstSL2, s_NotJR);

JRMUX: mux2t1_N
	generic MAP(32)
    port MAP(s2_JRSelect, s_NotJR, s2_ReadData1, s1_intoPC); 






--ID
s2_Inst <= s_IFIDout(63 downto 32); --Set signal from the register file. 
s2_PCPlus4 <= s_IFIDout(31 downto 0);

extend: Extender16t32
    port MAP(s2_Inst(15 downto 0), s_SignExtndIm, s3_Inst); 
Reg: RegFile
    port MAP(iCLK, s_RegWrData, s2_Inst(25 downto 21), s2_Inst(20 downto 16), s_RegWrAddr, iRST, s_RegWr, s1_ReadData1, s1_DMemData); 
Cont: control
    port MAP(s2_Inst(31 downto 26), s2_Inst(5 downto 0), controlOut_StoreHalt, controlOut_RegDest, controlOut_JumpSelect, controlOut_JRSelect, controlOut_Branch, controlOut_LoadAmt, controlOut_Bne, controlOut_MemtoReg, controlOut_AluControl,
	controlOut_DMemWr, controlOut_AluSrc, controlOut_SignExtndIm, controlOut_SignExtndLoad, controlOut_RegWr, controlOut_JALSelect, controlOut_OvfEn, controlOut_ShiftType); 

                --Below is added MUXES for Stalling

s1_StoreHalt <= controlOut_StoreHalt when s_stall = '1' else '0';
s1_RegDest <= controlOut_RegDest when s_stall = '1' else '0';
s1_JumpSelect <= controlOut_JumpSelect when s_stall = '1' else '0';
s1_JRSelect <= controlOut_JRSelect when s_stall = '1' else '0';
s1_Branch <= controlOut_Branch when s_stall = '1' else '0';
s1_LoadAmt <= controlOut_LoadAmt when s_stall = '1' else '0'&'0';
s1_Bne <= controlOut_Bne when s_stall = '1' else '0';
s1_MemtoReg <= controlOut_MemtoReg when s_stall = '1' else '0';
s1_AluControl <= controlOut_AluControl when s_stall = '1' else '0'&'0'&'0'&'0';
s1_DMemWr <= controlOut_DMemWr when s_stall = '1' else '0';
s1_AluSrc <= controlOut_AluSrc when s_stall = '1' else '0';
s_SignExtndIm <= controlOut_SignExtndIm when s_stall = '1' else '0';
s1_SignExtndLoad <= controlOut_SignExtndLoad when s_stall = '1' else '0';
s1_RegWr <= controlOut_RegWr when s_stall = '1' else '0';
s1_JALSelect <= controlOut_JALSelect when s_stall = '1' else '0';
s1_OvfEn <= controlOut_OvfEn when s_stall = '1' else '0';
s1_ShiftType <= controlOut_ShiftType when s_stall = '1' else '0'&'0';



s1_InstSL2 <=  s2_PCPlus4(31 downto 28) & s2_Inst(25 downto 0)& b"00";


IDEXE : N_bit_registerStage
	generic MAP(213)
    port MAP(iCLK, (s_flush OR iRST), '1', s2_Inst &
	s1_MemtoReg & s1_JALSelect & s1_StoreHalt & s1_RegDest & s1_RegWr & s2_PCPlus4 & s3_Inst & s1_DMemWr & s1_LoadAmt & 
	s1_SignExtndLoad & s1_AluControl & s1_ReadData1 & s1_AluSrc & s1_ShiftType & s1_InstSL2 & s1_DMemData & 
	s1_JumpSelect & s1_JRSelect & s1_Branch & s1_Bne & s1_OvfEn, x"00000000000000000000000000000000000000000000000000000" & b"0",
	s_IDEXEout);



HduComp: HDU
  port MAP( (s2_JumpSelect OR s2_JRSelect OR s2_JALSelect), s_AndOut ,s2_Inst(20 downto 16), s2_Inst(25 downto 21), s3_RegInst(20 downto 16),s2_RegWr,
	s2_MemtoReg, s_stall, s_flush);



--EXE
--Config the signals coming out of the register File
s_Im32Bit <= s_IDEXEout(143 downto 112);
s_Im32bitShifted <= s_Im32Bit(29 downto 0) & b"00";

s3_RegInst <=  s_IDEXEout(212 downto 181);
s2_MemtoReg <= s_IDEXEout(180);
s2_JALSelect <= s_IDEXEout(179);
s2_StoreHalt <= s_IDEXEout(178);
s2_RegDest <= s_IDEXEout(177);
s2_RegWr <= s_IDEXEout(176);
s3_PCPlus4 <= s_IDEXEout(175 downto 144);
s4_Inst <= s_IDEXEout(132 downto 123);
s2_DmemWr <= s_IDEXEout(111);
s2_LoadAmt <= s_IDEXEout(110 downto 109);
s2_SignExtndLoad<= s_IDEXEout(108);
s2_AluControl <= s_IDEXEout(107 downto 104);


s2_ReadData1 <= s2_StoreResult when (s_ForwardA = "01") else
		s_RegWrData when (s_ForwardA = "10") else
		s_IDEXEout(103 downto 72);





s2_AluSrc <= s_IDEXEout(71);
s2_ShiftType <= s_IDEXEout(70 downto 69);
s2_InstSL2 <= s_IDEXEout(68 downto 37);



s2_DMemData <= s2_StoreResult when (s_ForwardB = "01") else
		s_RegWrData when (s_ForwardB = "10") else
		s_IDEXEout(36 downto 5);



s2_JumpSelect <= s_IDEXEout(4);
s2_JRSelect <= s_IDEXEout(3);
s2_Branch <= s_IDEXEout(2);
s2_Bne <= s_IDEXEout(1);
s2_OvfEn <= s_IDEXEout(0);



AluComp: ALU
    port MAP(s2_ReadData1, s2_DMemData, s_Im32Bit, s2_AluSrc, s2_OvfEn, s2_ShiftType, s_Im32Bit(10 downto 6), s2_AluControl, s1_StoreOvfl, s_AluZero, s1_StoreResult); 

XorgateBranch: xorg2
    port MAP(s2_Bne, s_AluZero, s_XorOut);
andgateBranch: andg2
    port MAP(s2_Branch, s_XorOut, s_AndOut); 
   
BranchAdder: addersubtractor
    generic MAP(32)
    port MAP('0', s3_PCPlus4, s_Im32bitShifted, s_Branching, s_Dummy, s_Dummy); 
  

EXEMEM : N_bit_registerStage
	generic MAP(180)
    port MAP(iCLK, iRST, '1',s3_RegInst &  s2_DMemData & 
	s1_StoreResult & s1_intoPC & s2_MemtoReg & s2_JALSelect & s2_StoreHalt & s2_RegDest & s2_RegWr & s3_PCPlus4 & 
	s4_Inst & s2_DmemWr & s2_LoadAmt & s2_SignExtndLoad & s1_StoreOvfl, x"000000000000000000000000000000000000000000000",
	s_EXEMEMout);

Forwarding : ForwardingUnit
port MAP(s3_RegWr, s3_RegInst(25 downto 21), s_RTorRD_MEM, s_RegWr, s_RTorRD_WB, s3_RegInst(20 downto 16), s3_DmemWr, s4_RegInst(20 downto 16), s_ForwardA, s_ForwardB, s_ForwardC);








--MEM
s4_RegInst <=s_EXEMEMout(179 downto 148);
s_DMemData <= s_RegWrData when (s_ForwardC = '1') else
		s_EXEMEMout(147 downto 116);



s2_StoreResult <= s_EXEMEMout(115 downto 84);
s2_intoPC <= s_EXEMEMout(83 downto 52);
s3_MemtoReg <= s_EXEMEMout(51);
s3_JALSelect <= s_EXEMEMout(50);
s3_StoreHalt <= s_EXEMEMout(49);
s3_RegDest <= s_EXEMEMout(48);
s3_RegWr <= s_EXEMEMout(47);
s4_PCPlus4 <= s_EXEMEMout(46 downto 15);
s5_Inst <= s_EXEMEMout(14 downto 5);
s3_DmemWr <= s_EXEMEMout(4);
s3_LoadAmt <= s_EXEMEMout(3 downto 2);
s3_SignExtndLoad <= s_EXEMEMout(1);
s2_StoreOvfl <= s_EXEMEMout(0);

s_DMemAddr <= s2_StoreResult;
s_DMemWr <= s3_DmemWr;

s_RTorRD_MEM <= s4_RegInst(15 downto 11) when (s3_RegDest = '1') else s4_RegInst(20 downto 16);






LdSel: LoadSelector
    port MAP(s3_SignExtndLoad, s3_LoadAmt, s_DMemOut, s_DMemAddr(1 downto 0), s1_load); 




MEMWB : N_bit_registerStage
	generic MAP(176)
    port MAP(iCLK, iRST, '1', s4_RegInst & s2_StoreOvfl & 
	s1_load & s2_StoreResult & s2_intoPC & s3_MemtoReg & s3_JALSelect & s3_StoreHalt & s3_RegDest & s3_RegWr & 
	s4_PCPlus4 & s5_Inst, x"00000000000000000000000000000000000000000000",
	s_MEMWBout);


--WB
s5_RegInst <= s_MEMWBout(175 downto 144);
s_Ovfl <= s_MEMWBout(143);
s2_load <= s_MEMWBout(142 downto 111);
oALUOut <= s_MEMWBout(110 downto 79);
s3_intoPC <= s_MEMWBout(78 downto 47);
s4_MemtoReg <= s_MEMWBout(46);
s4_JALSelect <= s_MEMWBout(45);
s_Halt <= s_MEMWBout(44);
s4_RegDest <= s_MEMWBout(43);
s_RegWr <= s_MEMWBout(42);
s5_PCPlus4 <= s_MEMWBout(41 downto 10);
s6_Inst<= s_MEMWBout(9 downto 0);
s_RTorRD_WB <= s5_RegInst(15 downto 11) when (s4_RegDest = '1') else s5_RegInst(20 downto 16);



PostLoadSelectMux : mux2t1_N
	generic MAP(32)
    port MAP( s4_MemtoReg, s_MEMWBout(110 downto 79), s2_load, s_RegularData);

JALMux : mux2t1_N
	generic MAP(32)
    port MAP(s4_JALSelect, s_RegularData, s5_PCPlus4, s_RegWrData);




wrRegMux1 : mux2t1_N
	generic MAP(5)
    port MAP(s4_RegDest, s5_RegInst(20 downto 16), s5_RegInst(15 downto 11), s_RegMuxOut);




wrRegMux2 : mux2t1_N
	generic MAP(5)
    port MAP(s4_JALSelect, s_RegMuxOut, b"11111", s_RegWrAddr);









 
  
  

   

  
  

 
 


  
  



end structure;

