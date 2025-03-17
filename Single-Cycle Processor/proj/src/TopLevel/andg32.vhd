-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- andg32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32-input AND 
-- gate.

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity andg32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));

end andg32;

architecture dataflow of andg32 is
begin

  o_F <= i_A and i_B;
  
end dataflow;
