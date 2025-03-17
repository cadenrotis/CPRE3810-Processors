-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an 1-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);
end mux2t1;
------------------------------------------------------------
architecture structure of mux2t1 is

  component invg 
	port(i_A               : in std_logic;
         o_F               : out std_logic);
  end component;
  
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
  
  
 -- Signal to carry output not gate
 signal not_S         : std_logic;
  -- Signal to carry output And gate
 signal and0_O         : std_logic;
   -- Signal to carry output And gate
 signal and1_O         : std_logic;

 

begin
  notgate : invg
    port MAP(i_s ,not_S);
	
  andgate1 : andg2
    port MAP(i_D0, not_S, and0_O);
	
  andgate2 : andg2
    port MAP(i_D1, i_S, and1_O);	
  
  orgate : org2
    port MAP(and0_O, and1_O, o_O);
  
end structure;
