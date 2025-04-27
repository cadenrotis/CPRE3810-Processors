-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- invg32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 1-input NOT 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity invg32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));

end invg32;

architecture dataflow of invg32 is
begin

  o_F <= not i_A;
  
end dataflow;
