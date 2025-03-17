-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- Extender16t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an Extender16t32.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Extender16t32 is
  port(i_E        : in std_logic_vector(15 downto 0);     -- input
       i_S        : in std_logic;     			  -- Select 0 for zero extend, 1 for signed. 
       o_E        : out std_logic_vector(31 downto 0));   --Output

end Extender16t32;

architecture mixed of Extender16t32 is


begin

with i_S select
o_E <=		(x"0000" & i_E)     when '0', --When Zero extend
			(i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)&i_E(15)-- Sign extend
			&i_E(15)&i_E(15)&i_E(15)&i_E(15)& i_E)  when '1',					--Yes its ugly but it works. 
			(others => '0') when others;
	
  
  
end mixed;
