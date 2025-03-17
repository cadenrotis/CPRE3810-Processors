-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
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
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated





 -------------------------------------------------Signals added by me below 
 signal s_Dummy : std_logic; --Dummy signal
 
 -- Signals coming out of our ALU
 signal s_JumpSelect 		: std_logic;
 signal s_JRSelect			: std_logic;
 signal s_JALSelect         : std_logic;
 signal s_Branch			: std_logic;
 signal s_Bne				: std_logic;
 signal s_OvfEn				: std_logic;
 signal s_SignExtndLoad		: std_logic;
 signal s_SignExtndIm		: std_logic;
 signal s_MemtoReg			: std_logic;
 signal s_AluSrc			: std_logic;
 signal s_ShiftType			: std_logic_vector(1 downto 0);
 signal s_AluControl		: std_logic_vector(3 downto 0);
 signal s_RegDest			: std_logic;
 -- Signals Needed elseware (See Design for location of specific 
 signal s_load : std_logic_vector(31 downto 0);
 signal s_RegularData :std_logic_vector(31 downto 0);
 signal s_XorOut : std_logic;
 signal s_AndOut : std_logic;
 signal s_Branching: std_logic_vector(31 downto 0);
 signal s_NotJump  : std_logic_vector(31 downto 0);
 signal s_NotJR  : std_logic_vector(31 downto 0);
 signal s_intoPC : std_logic_vector(31 downto 0);
 signal s_Im32Bit : std_logic_vector(31 downto 0);
 signal s_Im32bitShifted : std_logic_vector(31 downto 0);
signal s_PCPlus4 : std_logic_vector (31 downto 0);
signal s_RegMuxOut : std_logic_vector (4 downto 0);
 signal s_ReadData1: std_logic_vector (31 downto 0);
signal s_AluZero :std_logic; 
signal s_LoadAmt : std_logic_vector (1 downto 0);
signal s_AluOut : std_logic_vector (31 downto 0);


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

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
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
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
  
  
  s_Im32bitShifted <= s_Im32Bit(29 downto 0) & "00";
s_DMemAddr <= OAluOut;
s_AluOut <= OAluOut;
  
  
 PC : N_bit_registerPC
	generic MAP(32)
    port MAP(iCLK, iRST, '1', s_intoPC, x"00400000", s_NextInstAddr);
 
 JALMux : mux2t1_N
	generic MAP(32)
    port MAP(s_JALSelect, s_RegularData, s_PCPlus4, s_RegWrData);
	
  wrRegMux1 : mux2t1_N
	generic MAP(5)
    port MAP(s_RegDest, s_Inst(20 downto 16), s_Inst( 15 downto 11), s_RegMuxOut);
  wrRegMux2 : mux2t1_N
	generic MAP(5)
    port MAP( s_JALSelect,s_RegMuxOut, b"11111", s_RegWrAddr);
  PostLoadSelectMux : mux2t1_N
	generic MAP(32)
    port MAP( s_MemtoReg, s_AluOut, s_load, s_RegularData);
   BranchMux: mux2t1_N
	generic MAP(32)
    port MAP(s_AndOut, s_PCPlus4, s_Branching, s_NotJump);
   JumpMux: mux2t1_N
	generic MAP(32)
    port MAP(s_JumpSelect, s_NotJump, s_PCPlus4(31 downto 28) & s_Inst(25 downto 0)& b"00", s_NotJR);
   JRMUX: mux2t1_N
	generic MAP(32)
    port MAP(s_JRSelect, s_NotJR, s_ReadData1, s_intoPC); 
  
    PCAdder: addersubtractor
	generic MAP(32)
    port MAP('0', s_NextInstAddr, x"00000004", s_PCPlus4, s_Dummy, s_Dummy); 
      
	BranchAdder: addersubtractor
	generic MAP(32)
    port MAP('0', s_PCPlus4, s_Im32bitShifted, s_Branching, s_Dummy, s_Dummy); 
  
  	andgateBranch: andg2
    port MAP(s_Branch, s_XorOut, s_AndOut); 
  
   	XorgateBranch: xorg2
    port MAP(s_Bne, s_AluZero, s_XorOut); 
  
	AluComp: ALU
    port MAP(s_ReadData1, s_DMemData, s_Im32Bit, s_AluSrc, s_OvfEn, s_ShiftType, s_Im32Bit(10 downto 6), s_AluControl, s_Ovfl, s_AluZero, oALUOut); 
 
    Reg: RegFile
    port MAP(iCLK, s_RegWrData, s_Inst(25 downto 21), s_Inst(20 downto 16), s_RegWrAddr, iRST, s_RegWr, s_ReadData1, s_DMemData); 
  
	LdSel: LoadSelector
    port MAP(s_SignExtndLoad, s_LoadAmt, s_DMemOut, s_AluOut(1 downto 0),s_load); 
  extend: Extender16t32
    port MAP(s_Inst(15 downto 0), s_SignExtndIm, s_Im32Bit); 
  Cont: control
    port MAP(s_Inst(31 downto 26), s_Inst(5 downto 0), s_Halt, s_RegDest, s_JumpSelect, s_JRSelect, s_Branch, s_LoadAmt, s_Bne, s_MemtoReg, s_AluControl,
	s_DMemWr, s_AluSrc, s_SignExtndIm, s_SignExtndLoad, s_RegWr, s_JALSelect, s_OvfEn, s_ShiftType); 
  
  
  



end structure;

