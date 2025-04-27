-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- HDU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Forwarding Unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is
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
end ForwardingUnit;
------------------------------------------------------------
architecture structure of ForwardingUnit is

begin


o_ForwardA <= "01" when (i_RegWr_MEM = '1' and i_RTorRD_MEM = i_RS_EXE and i_RTorRD_MEM /= "00000") else
              "10" when (i_RegWr_WB = '1' and i_RTORRD_WB = i_RS_EXE and i_RTorRD_WB /= "00000") else
              "00";

o_ForwardB <= "01" when (i_RegWr_MEM = '1' and i_RTorRD_MEM = i_RT_EXE and i_RTorRD_MEM /= "00000") else
              "10" when (i_RegWr_WB = '1' and i_RTORRD_WB = i_RT_EXE and i_RTorRD_WB /= "00000") else
              "00";

o_ForwardC <= '1' when (i_DMemWr_MEM = '1' and i_RegWr_WB = '1' and i_RTorRD_WB = i_RT_MEM and 
                            i_RTorRD_WB /= "00000") else
              '0';



end structure;
