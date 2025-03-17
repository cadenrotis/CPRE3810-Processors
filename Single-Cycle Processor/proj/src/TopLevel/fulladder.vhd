-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- fulladder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: ones comp.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is

  port(
		c_in          : in std_logic;
		i_X          : in std_logic;
		i_Y          : in std_logic;
		o_sum		: out std_logic;
       c_out          : out std_logic);
	   
end fulladder;
------------------------------------------------------------
architecture structure of fulladder is
	
  	component andg2
	port(i_A               : in std_logic;
		 i_B			   : in std_logic;
         o_F               : out std_logic);
  end component;
  

  
    
  component org2
	port(i_A               : in std_logic;
		 i_B				  : in std_logic;
         o_F               : out std_logic);
  end component;



    component xorg2
	port(i_A               : in std_logic;
		 i_B				  : in std_logic;
         o_F               : out std_logic);
  end component;
 
 
  -- Signal to carry output xor1 gate
 signal x_xor_y         : std_logic;
 
   -- Signal to carry output And1 gate
 signal and1_O         : std_logic;
    -- Signal to carry output And2 gate
 signal and2_O         : std_logic;
    -- Signal to carry output And3 gate
 signal and3_O         : std_logic;
     -- Signal to carry output or1 gate
 signal or1_O         : std_logic;
 
 
begin

  xorGate1 : xorg2
    port MAP(i_X, i_Y, x_xor_y);
	
  xorGate2 : xorg2
    port MAP(x_xor_y, c_in, o_sum);

  andgate1 : andg2
    port MAP(i_X, c_in, and1_O);

  andgate2 : andg2
    port MAP(i_X, i_Y, and2_O);
	
  andgate3 : andg2
    port MAP(i_Y, c_in, and3_O);
 
  orgate1 : org2
    port MAP(and1_O, and2_O, or1_O);
 
  orgate2 : org2
    port MAP(or1_O, and3_O, c_out);

  
end structure;
