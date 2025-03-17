-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the loadselector.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_LoadSelector is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_LoadSelector;

architecture mixed of tb_LoadSelector is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component LoadSelector is
  port(i_SignS        : in std_logic;     
       i_LoadAmt        : in std_logic_vector(1 downto 0);
	   i_Data        : in std_logic_vector(31 downto 0);
	   i_PosSelect: in std_logic_vector(1 downto 0);
       o_O        : out std_logic_vector(31 downto 0)); 
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal i_SignS : std_logic := '0';
signal i_LoadAmt   : std_logic_vector(1 downto 0) := b"00";
signal i_PosSelect   : std_logic_vector(1 downto 0) := b"00";
signal i_Data   : std_logic_vector(31 downto 0) := x"00000000";
signal o_O   : std_logic_vector(31 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: LoadSelector
  port map( i_SignS     => i_SignS,
			i_LoadAmt       => i_LoadAmt,
            i_Data       => i_Data,
			i_PosSelect => i_PosSelect,
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

  
    --wait for gCLK_HPER*2;
	
	    -- Test Case 1: Load Full amount
        i_SignS       <= '0';
        i_LoadAmt<= "00"; 
        i_Data    <= x"12345678"; 
       wait for gCLK_HPER*2; --Expecting 12345678
	   
	   
	   -- Test Case 2: Load lower half amount signed
        i_SignS       <= '1';
        i_LoadAmt<= "01"; 
        i_Data    <= x"1234FEDC"; 
       wait for gCLK_HPER*2; --Expecting FFFFFEDC
	   
	   -- Test Case 3: Load lower half amount unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "01"; 
        i_Data    <= x"1234FEDC"; 
       wait for gCLK_HPER*2; --Expecting 0000FEDC
		-- Test Case 4: Load upper half amount signed
        i_SignS       <= '1';
        i_LoadAmt<= "01"; 
		i_PosSelect <= "10";
        i_Data    <= x"F2345678"; 
       wait for gCLK_HPER*2; --Expecting FFFFF234
	   -- Test Case 5: Load upper half amount unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "01"; 
		i_PosSelect <= "10";
        i_Data    <= x"F2345678"; 
       wait for gCLK_HPER*2; --Expecting 0000F234
	------------------Below will be all of the Byte sized tests: 4Bytes
	 -- Test Case 6: Load bottom byte  unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "00";
        i_Data    <= x"12345688"; 
       wait for gCLK_HPER*2; --Expecting 00000088
	   
	   -- Test Case 7: Load bottom byte  unsigned
        i_SignS       <= '1';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "00";
        i_Data    <= x"12345688"; 
       wait for gCLK_HPER*2; --Expecting FFFFFF88
	   
	   
	   -- Test Case 8: Load 2nd Last byte  unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "01";
        i_Data    <= x"12349911"; 
       wait for gCLK_HPER*2; --Expecting 00000099
	   -- Test Case 9: Load 2nd Last byte  signed
        i_SignS       <= '1';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "01";
        i_Data    <= x"12349911"; 
       wait for gCLK_HPER*2; --Expecting FFFFFF99
	    -- Test Case 10: Load 3nd Last byte  unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "11";
		i_PosSelect <= "10";
        i_Data    <= x"12AA3411"; 
       wait for gCLK_HPER*2; --Expecting 000000AA
	   -- Test Case 11: Load 3nd Last byte  signed
        i_SignS       <= '1';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "10";
        i_Data    <= x"12AA3411"; 
       wait for gCLK_HPER*2; --Expecting FFFFFFAA
	-- Test Case 12: Load Last byte  unsigned
        i_SignS       <= '0';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "11";
        i_Data    <= x"CC123411"; 
       wait for gCLK_HPER*2; --Expecting 000000CC
	   -- Test Case 13: Load Last byte  signed
        i_SignS       <= '1';
        i_LoadAmt<= "11"; 
		i_PosSelect <= "11";
        i_Data    <= x"CC123411"; 
       wait for gCLK_HPER*2; --Expecting FFFFFFCC
	
	
	
	
	




    wait;
  end process;

end mixed;
