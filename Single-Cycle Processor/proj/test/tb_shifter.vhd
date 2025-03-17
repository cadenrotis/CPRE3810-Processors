-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the shifter.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_shifter is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_shifter;

architecture mixed of tb_shifter is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component shifter is
  port(i_RT          : in std_logic_vector(31 downto 0);
       i_ShiftType         : in std_logic_vector(1 downto 0);
       i_Shamt         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal i_RT : std_logic_vector(31 downto 0) := x"00000000";
signal i_ShiftType   : std_logic_vector(1 downto 0) := b"00";
signal i_Shamt   : std_logic_vector(4 downto 0) := b"00000";
signal o_O   : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: shifter
  port map(
            i_RT     => i_RT,
			i_ShiftType       => i_ShiftType,
            i_Shamt       => i_Shamt,
            o_O       => o_O);
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
	
	        -- Test Case 1: SLL
        i_RT       <= "00000000000000000000000000001010"; -- 10 in decimal
        i_ShiftType<= "00"; -- SLL
        i_Shamt    <= "00010"; 
       wait for gCLK_HPER*2; --Expecting 00000000000000000000000000101000 = x28

        -- Test Case 2: SRL (Logical Right Shift) - Shift Right 2
        i_RT       <= "00000000000000000000000000001010"; -- 10 in decimal
        i_ShiftType<= "01"; -- SRL
        i_Shamt    <= "00010"; 
        wait for gCLK_HPER*2; -- expecting 00000000000000000000000000000010 = x2

        -- Test Case 3: SRA 
        i_RT       <= "10000000000000000000000000001010";
        i_ShiftType<= "10"; -- SRA
        i_Shamt    <= "00010"; 
        wait for gCLK_HPER*2; -- Expecting 11100000000000000000000000000010 = x E0000002

        -- Test Case 4: SLL 
        i_RT       <= "00000000000000000000000000001010";
        i_ShiftType<= "00"; -- SLL
        i_Shamt    <= "00100";
        wait for gCLK_HPER*2;-- Expecting 00000000000000000000000010100000 = xA0

        -- Test Case 5: SRL 
        i_RT       <= "00000000000000000000000000001010";
        i_ShiftType<= "01"; -- SRL
        i_Shamt    <= "00100"; 
        wait for gCLK_HPER*2;-- Expecting 00000000000000000000000000000000 = x0

        -- Test Case 6: SRA 
        i_RT       <= "11110000000000000000000000000000";
        i_ShiftType<= "10"; -- SRA
        i_Shamt    <= "00100"; 
       wait for gCLK_HPER*2; -- expecting 11111111000000000000000000000000 = xff000000

        -- Test Case 7: No shifting
        i_RT       <= "10101010101010101010101010101010";
        i_ShiftType<= "00"; -- SLL
        i_Shamt    <= "00000"; -- No shift
        wait for gCLK_HPER*2; -- Expect xAAAAAAAAA


    wait;
  end process;

end mixed;
