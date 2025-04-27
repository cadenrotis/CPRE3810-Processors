-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the Stage Registers.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_StageRegisters is
  generic(gCLK_HPER   : time := 10 ns;
          DATA_WIDTH  : integer := 16);   -- Generic for half of the clock cycle period
end tb_StageRegisters;

architecture mixed of tb_StageRegisters is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.

component N_bit_registerStage is
generic(N : integer := 32);
port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
	   i_RST_VAL  : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal i_flush : std_logic;
signal i_stall : std_logic;

--Register Signals
signal i_intoIFID : std_logic_vector(31 downto 0);
signal i_outIFID : std_logic_vector(31 downto 0);
signal i_intoIDEXE : std_logic_vector(31 downto 0);
signal i_intoEXEMEM : std_logic_vector(31 downto 0);
signal i_intoMEMWB : std_logic_vector(31 downto 0);
signal i_ReadingWB: std_logic_vector(31 downto 0);


begin


IFID : N_bit_registerStage
	generic MAP(32)
    port MAP(CLK, (i_flush), i_stall, i_intoIFID, x"00000000", i_outIFID);

i_intoIDEXE <= i_outIFID when (i_stall = '1') else x"00000000";

IDEXE : N_bit_registerStage
	generic MAP(32)
    port MAP(CLK, (i_flush), '1',i_intoIDEXE , x"00000000", i_intoEXEMEM);


EXEMEM : N_bit_registerStage
	generic MAP(32)
    port MAP(CLK, reset, '1',i_intoEXEMEM , x"00000000", i_intoMEMWB);


MEMWB : N_bit_registerStage
	generic MAP(32)
    port MAP(CLK, reset, '1', i_intoMEMWB, x"00000000", i_ReadingWB);




			
			
			
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
	wait for gCLK_HPER*2;
	wait for gCLK_HPER*2;
	i_flush <= '0';
	i_stall <= '1';

	i_intoIFID <= x"ABCDEF00";

     
    	--Below shows that values trickle through the registers as we would expect.
   	wait for gCLK_HPER*2;
	i_intoIFID <= x"0ABCDEF0";
	wait for gCLK_HPER*2;
	i_intoIFID <= x"00ABCDEF";
	wait for gCLK_HPER*2;
	i_intoIFID <= x"F00ABCDE";
	wait for gCLK_HPER*2;
	i_intoIFID <= x"EF00ABCD";
	wait for gCLK_HPER*2;
	i_intoIFID <= x"DEF00ABC";
	wait for gCLK_HPER*2;
	--Below is going to show how a stall would work.
	i_stall <= '0'; --Low stall, would turn the PC off => Into IFID Stays the same. 
	i_intoIFID <= x"CDEF00AB";
	wait for gCLK_HPER*2;
	i_stall <= '1'; --Stall back off.
	i_intoIFID <= x"CDEF00AB";
	wait for gCLK_HPER*2;

	i_intoIFID <= x"BCDEF00A";
	wait for gCLK_HPER*2;
	i_intoIFID <= x"ABCDEF00";--Now we will perform a Flush when this instruction is in the EXE Stage 
	wait for gCLK_HPER*2;

	i_intoIFID <= x"0ABCDEF0";--ID Stage
	wait for gCLK_HPER*2;
	i_intoIFID <= x"00ABCDEF";--EXE STAGE 
	i_flush <= '1'; --Flush On.
	wait for gCLK_HPER*2;
	i_intoIFID <= x"11111111";
	i_flush <= '0'; --Flush Off.
	wait for gCLK_HPER*2;
	i_intoIFID <= x"11111112";
	wait for gCLK_HPER*2;
	
		   


	   
	   







    wait;
  end process;

end mixed;
