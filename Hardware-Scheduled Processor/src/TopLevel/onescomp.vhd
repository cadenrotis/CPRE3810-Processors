-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- onescomp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: ones comp.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onescomp is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end onescomp;
------------------------------------------------------------
architecture structure of onescomp is

  component invg 
	port(i_A               : in std_logic;
         o_F               : out std_logic);
  end component;
  
 
begin
 
  -- Instantiate N instances.
  Ones_Comp: for i in 0 to N-1 generate
    Ones_Comp1: invg 
	port map(
              i_A     => i_A(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_F      => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate Ones_Comp;

  
end structure;
