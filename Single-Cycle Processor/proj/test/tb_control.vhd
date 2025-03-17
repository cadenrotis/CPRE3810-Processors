-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the Control.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_control is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_control;

architecture mixed of tb_control is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
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
	   o_ShiftType  : out std_logic_vector(1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal i_OpCode 	:std_logic_vector(5 downto 0);
signal i_FunctCode 	:std_logic_vector(5 downto 0);
signal o_Halt 		:std_logic;
signal o_RegDest	:std_logic;
signal o_JumpSelect :  std_logic;
signal o_JRSelect	:  std_logic;
signal  o_Branch		:  std_logic;
signal o_LoadAmt	:  std_logic_vector(1 downto 0);
signal o_Bne		:  std_logic;
signal o_MemToReg	:  std_logic;
signal o_AluControl :  std_logic_vector(3 downto 0);
signal o_DmemWr		:  std_logic;
signal o_AluSrc		:  std_logic;
signal o_SignExtendIm:  std_logic;
signal o_SignExtendLoad:  std_logic;
signal o_RegWr		:  std_logic;
signal o_JalSelect        :  std_logic;
signal o_OvfEn      :  std_logic;
signal o_ShiftType  : std_logic_vector(1 downto 0);



begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: control
  port map(i_OpCode, i_FunctCode, o_Halt, o_RegDest, o_JumpSelect, o_JRSelect, o_Branch, o_LoadAmt, o_Bne, o_MemToReg, o_AluControl, 
 o_DmemWr, o_AluSrc, o_SignExtendIm, o_SignExtendLoad, o_RegWr, o_JalSelect, o_OvfEn,o_ShiftType );

  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

	-----------------------------------Note Fuct code =111111=x3F means no funct code. 
	      -- Test Case 1: Addi
        i_OpCode       <= b"001000";
        i_FunctCode<= b"111111"; --No Funct
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 2: Add
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100000"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 3: Addiu
        i_OpCode       <= b"001001";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 4: Addu
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100001"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 5: and
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100100"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 6: andi
        i_OpCode       <= b"001100";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 7: lui
        i_OpCode       <= b"001111";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 8: lw
        i_OpCode       <= b"100011";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 9: nor
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 10: xor
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100110"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 11: xori
        i_OpCode       <= b"001110";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 12: or
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100101"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 13: ori
        i_OpCode       <= b"001101";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 14: slt
        i_OpCode       <= b"000000";
        i_FunctCode<= b"101010"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 15: slti
        i_OpCode       <= b"001010";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 16: sll
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000000"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 17: srl
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000010"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 18: sra
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000011"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 19: sw
        i_OpCode       <= b"101011";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 20: sub
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100010"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 21: subu
        i_OpCode       <= b"000000";
        i_FunctCode<= b"100011"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 22: beq
        i_OpCode       <= b"000100";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 23: bne
        i_OpCode       <= b"000101";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 24: j
        i_OpCode       <= b"000010";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 25: jal
        i_OpCode       <= b"000011";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 26: jr 
        i_OpCode       <= b"000000";
        i_FunctCode<= b"001000"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 27: lb
        i_OpCode       <= b"100000";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 28: lh
        i_OpCode       <= b"100001";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 29: lbu
        i_OpCode       <= b"100100";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   
	   -- Test Case 30: lhu
        i_OpCode       <= b"100101";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 31: sllv
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000100"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 32: srlv
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000110"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 33: srav
        i_OpCode       <= b"000000";
        i_FunctCode<= b"000111"; 
       wait for gCLK_HPER*2; 
	   
	   -- Test Case 34: Halt
        i_OpCode       <= b"010100";
        i_FunctCode<= b"111111"; 
       wait for gCLK_HPER*2; 


    wait;
  end process;

end mixed;
