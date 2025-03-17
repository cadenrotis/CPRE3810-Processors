-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- org32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 2-input OR 
-- gate.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity org32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));

end org32;

architecture dataflow of org32 is
begin

  o_F <= i_A or i_B;
  
end dataflow;
