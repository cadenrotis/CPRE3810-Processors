-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the ALU.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_ALU;

architecture mixed of tb_ALU is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
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

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal	   i_A          :std_logic_vector(31 downto 0):= x"00000000";
signal	   i_B          :std_logic_vector(31 downto 0):= x"00000000";
signal	   i_Im          :std_logic_vector(31 downto 0):= x"00000000";
signal       i_ALUSrc    :std_logic:= '0';
signal	   i_OvfEn       :std_logic:= '0';
signal	   i_ShiftType    :std_logic_vector(1 downto 0):= b"00";
signal       i_Shamt      :std_logic_vector(4 downto 0):= b"00000";
signal	   i_ALUControl   :std_logic_vector (3 downto 0):= b"0000"; -- Bit 3 is the Add/Sub bit.
signal	   o_Ovf          :std_logic;
signal	   o_Zero          :std_logic;
signal       o_Result      :std_logic_vector(31 downto 0);



begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: ALU
  port map(
            i_A     => i_A,
			i_B       => i_B,
            i_Im       => i_Im,
			i_ALUSrc       => i_ALUSrc,
			i_OvfEn       => i_OvfEn,
			i_ShiftType       => i_ShiftType,
			i_Shamt       => i_Shamt,
			i_ALUControl       => i_ALUControl,
			o_Ovf       => o_Ovf,
			o_Zero       => o_Zero,
			o_Result       => o_Result);
			
			
			
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

    -- Test case 1: 

    --wait for gCLK_HPER*2;
	
		-- Test Case 1: Testing addi
			i_A <= x"EEEEEEEE";
			i_B <= x"00000000";
            i_Im <= x"00001111"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 2: Testing addi with ovf
			i_A <= x"40000000";
			i_B <= x"00000000";
            i_Im <= x"40000000"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   
		-- Test Case 3: Testing add
			i_A <= x"EEEEEEEE";
			i_B <= x"00001111";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 4: Testing add with ovf
			i_A <= x"40000000";
			i_B <= x"40000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 5: Testing addiu 80007FFF expected
			i_A <= x"80000000";
			i_B <= x"00000000";
            i_Im <= x"00007FFF"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   -- Test Case 6: Testing Overflow to not work addiu
			i_A <= x"40000000";
			i_B <= x"40000000";
            i_Im <= x"40000000"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 7: Testing addu 24682468 expected
			i_A <= x"12341234";
			i_B <= x"12341234";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0000";
       wait for gCLK_HPER*2;
	   -- Test Case 8: Testing and, expected 12340004(Reg)
			i_A <= x"FFFF000F";
			i_B <= x"12341234";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0001";
       wait for gCLK_HPER*2;
	   -- Test Case 9: Testing and, expected 12340004(IM)
			i_A <= x"FFFF000F";
			i_B <= x"00000000";
            i_Im <= x"12341234"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0001";
       wait for gCLK_HPER*2;
	   -- Test Case 10: Testing OR, expected FFFF123F(Reg)
			i_A <= x"FFFF000F";
			i_B <= x"12341234";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0010";
       wait for gCLK_HPER*2;
	   -- Test Case 11: Testing OR, expected FFFF123F(IM)
			i_A <= x"FFFF000F";
			i_B <= x"00000000";
            i_Im <= x"12341234"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0010";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 12: Testing SUBU, expected  10000000
			i_A <= x"20000000";
			i_B <= x"10000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1000";
       wait for gCLK_HPER*2;
	   -- Test Case 13: Testing SUBU, expected fffffff0
			i_A <= x"00000010";
			i_B <= x"00000020";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 14: Testing SUB, expected  20000000
			i_A <= x"04000000";
			i_B <= x"02000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1000";
       wait for gCLK_HPER*2;
	   -- Test Case 15: Testing SUB, expected  OVF
			i_A <= x"7FFFFFFF";
			i_B <= x"FFFFFFFF";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '1';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1000";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 16: Testing LUI, Expecting 56780000
			i_A <= x"FFFFFFFF";
			i_B <= x"00000000";
            i_Im <= x"12345678"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0110";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 17: Testing NOR, Expecting  0F0F0F0F
			i_A <= x"F0F0F0F0";
			i_B <= x"00000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0100";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 18: Testing XOR, Expecting  0f0f0f0f
			i_A <= x"F0F0F0F0";
			i_B <= x"FFFFFFFF";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0011";
       wait for gCLK_HPER*2;
	   -- Test Case 19: Testing XORI, Expecting  0f0f0f0f
			i_A <= x"F0F0F0F0";
			i_B <= x"00000000";
            i_Im <= x"FFFFFFFF"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"0011";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 20: Testing SLT Expecting x00000001
			i_A <= x"0000FFFF";
			i_B <= x"01111111";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1101";
       wait for gCLK_HPER*2;
	   -- Test Case 21: Testing SLT Expecting x00000000
			i_A <= x"0FFFFFFF";
			i_B <= x"01111111";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1101";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 22: Testing SLTI Expecting x00000001
			i_A <= x"0000FFFF";
			i_B <= x"00000000";
            i_Im <= x"02222222"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1101";
       wait for gCLK_HPER*2;
	   -- Test Case 23: Testing SLTI Expecting x00000000
			i_A <= x"0FFFFFFF";
			i_B <= x"00000000";
            i_Im <= x"02222222"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1101";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 24: Testing SLL Expecting 80000000
			i_A <= x"00000000";
			i_B <= x"0000000F";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"11111";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   -- Test Case 25: Testing SRL Expecting 0F000000
			i_A <= x"00000000";
			i_B <= x"F0000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"01";
			i_Shamt <= b"00100";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   -- Test Case 26: Testing SRA Expecting ff000000
			i_A <= x"00000000";
			i_B <= x"F0000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '1';
			i_OvfEn <= '0';
			i_ShiftType <= b"10";
			i_Shamt <= b"00100";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   
	   
	    -- Test Case 27: Testing SLLV Expecting  0F000000
			i_A <= x"00000004";
			i_B <= x"00F00000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"11111";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   -- Test Case 28: Testing SRLV Expecting 000F0000
			i_A <= x"00000004";
			i_B <= x"00F00000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"01";
			i_Shamt <= b"00100";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   -- Test Case 29: Testing SRAV Expecting  FFFF00000
			i_A <= x"0000000F";
			i_B <= x"80000000";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"10";
			i_Shamt <= b"00100";
			i_ALUControl <= b"0111";
       wait for gCLK_HPER*2;
	   
	   -- Test Case 30: Testing Zero Flag
			i_A <= x"0000000F";
			i_B <= x"0000000F";
            i_Im <= x"00000000"; 
			i_ALUSrc <= '0';
			i_OvfEn <= '0';
			i_ShiftType <= b"00";
			i_Shamt <= b"00000";
			i_ALUControl <= b"1000";
       wait for gCLK_HPER*2;
	   


	   
	   







    wait;
  end process;

end mixed;
