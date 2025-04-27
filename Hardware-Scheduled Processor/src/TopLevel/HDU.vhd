-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- HDU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a HDU
--NOPS & Flushing Logic
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity HDU is
  port( i_jumping         : in std_logic;
	i_BranchTaken     : in std_logic;
	i_ID_rt          : in std_logic_vector(4 downto 0);
	i_ID_rs          : in std_logic_vector(4 downto 0);
	i_EXE_rt          : in std_logic_vector(4 downto 0);
	i_EXE_RegWr          : in std_logic;
	i_EXE_MemtoReg         : in std_logic;
        o_stall          : out std_logic;
	o_flush          :out std_logic);


end HDU;
------------------------------------------------------------
architecture structure of HDU is
    -- Intermediate signals to break down the logic
signal s_Using_Loaded  : std_logic;

begin
	--Only need to stall when we are loading, and also reading the loading value
    s_Using_Loaded <= '1' when (i_ID_rt = i_EXE_rt OR i_ID_rs = i_EXE_rt) else '0';




 
    -- Final Stall logic
    o_stall <= NOT (s_Using_Loaded AND i_EXE_RegWr AND i_EXE_MemtoReg);
    o_flush <= (i_BranchTaken OR i_jumping);--Going to Flush Only when Branch is being taken 
end structure;
