-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- Nripplefulladder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Nripplefulladder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Nripplefulladder is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(c_in          : in std_logic;
       i_X          : in std_logic_vector(N-1 downto 0);
	   i_Y          : in std_logic_vector(N-1 downto 0);
	   o_sum          : out std_logic_vector(N-1 downto 0);
	   c_31				: out std_logic;
       c_out          : out std_logic);
end Nripplefulladder;
------------------------------------------------------------
architecture structure of Nripplefulladder is

component fulladder 
  port(
		c_in          : in std_logic;
		i_X          : in std_logic;
		i_Y          : in std_logic;
		o_sum		: out std_logic;
       c_out          : out std_logic);
  end component;
  
 -- Signal to carry carry bit
 signal c_temp         : std_logic_vector(N downto 0);
 
begin
     c_temp(0) <= c_in; -- Initial carry input
  -- Instantiate N instances.
  nbitrip: for i in 0 to N-1 generate
    Ones_Comp1: fulladder 
	port map(
                c_in     => c_temp(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
	            i_X     => i_X(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
                i_Y     => i_Y(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
				o_sum      => o_sum(i),			  
                c_out      => c_temp(i+1));  -- ith instance's data output hooked up to ith data output.
  end generate nbitrip;

   c_out <= c_temp(N);
   c_31 <= c_temp(N-1);
  
end structure;
