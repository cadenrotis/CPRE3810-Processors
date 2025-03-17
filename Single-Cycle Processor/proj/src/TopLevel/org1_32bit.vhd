-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- org1_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32bit OR 
-- gate.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity org1_32bit is

  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);

end org1_32bit;

architecture dataflow of org1_32bit is
begin

  o_F <= i_A(0) OR i_A(1) OR i_A(2) OR i_A(3) OR i_A(4) OR i_A(5) OR i_A(6) OR i_A(7) OR
         i_A(8) OR i_A(9) OR i_A(10) OR i_A(11) OR i_A(12) OR i_A(13) OR i_A(14) OR i_A(15) OR
         i_A(16) OR i_A(17) OR i_A(18) OR i_A(19) OR i_A(20) OR i_A(21) OR i_A(22) OR i_A(23) OR
         i_A(24) OR i_A(25) OR i_A(26) OR i_A(27) OR i_A(28) OR i_A(29) OR i_A(30) OR i_A(31);
  
end dataflow;
