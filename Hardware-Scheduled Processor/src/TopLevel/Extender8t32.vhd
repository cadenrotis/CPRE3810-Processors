-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- Extender8t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an Extender8t32.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Extender8t32 is
  port(i_E        : in std_logic_vector(7 downto 0);     -- input
       i_S        : in std_logic;     			  -- Select 0 for zero extend, 1 for signed. 
       o_E        : out std_logic_vector(31 downto 0));   --Output

end Extender8t32;

architecture mixed of Extender8t32 is


begin

with i_S select
o_E <=		(x"000000" & i_E)     when '0', --When Zero extend
			(i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)-- Sign extend
			&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)&i_E(7)& i_E)  when '1',					--Yes its ugly but it works. 
			(others => '0') when others;
	
  
  
end mixed;
