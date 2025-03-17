-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- mux8t1_32Bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an 32-bit wide 8:1
-- mux using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux8t1_32Bit is
  port(i_S          : in std_logic_vector(2 downto 0);
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
	   i_D2         : in std_logic_vector(31 downto 0);
	   i_D3         : in std_logic_vector(31 downto 0);
	   i_D4         : in std_logic_vector(31 downto 0);
       i_D5         : in std_logic_vector(31 downto 0);
	   i_D6         : in std_logic_vector(31 downto 0);
	   i_D7         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end mux8t1_32Bit;
------------------------------------------------------------
architecture structure of mux8t1_32Bit is


begin

     o_O <= i_D0 when i_S = "000" else
			i_D1 when i_S = "001" else
			i_D2 when i_S = "010" else
			i_D3 when i_S = "011" else
			i_D4 when i_S = "100" else
			i_D5 when i_S = "101" else
			i_D6 when i_S = "110" else
			i_D7 when i_S = "111";
  
end structure;
