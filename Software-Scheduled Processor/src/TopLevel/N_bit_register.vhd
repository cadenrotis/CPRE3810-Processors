-------------------------------------------------------------------------
-- Chris Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- N_bit_register.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit register
--
--
-- NOTES:
-- 2/3/25 by Chris
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity N_bit_register is
	generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end N_bit_register;

architecture mixed of N_bit_register is



  component dffg 
	port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;

begin
 -- Instantiate N instances.
  N_bit_reg: for i in 0 to N-1 generate
    N_bit_reg1: dffg
	--Generic map (N => N)
	port map(
			i_CLK     => i_CLK,  
			i_RST     => i_RST,  
			i_WE     => i_WE,  
            i_D     => i_D(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
            o_Q      => o_Q(i));  -- ith instance's data output hooked up to ith data output.
			  
  end generate N_bit_reg;
  
end mixed;
