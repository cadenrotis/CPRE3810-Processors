-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- addersubtractor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: addersubtractor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addersubtractor is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(nAdd_Sub          : in std_logic;
       i_A          : in std_logic_vector(N-1 downto 0);
	   i_B          : in std_logic_vector(N-1 downto 0);
	   o_result          : out std_logic_vector(N-1 downto 0);
	   c_out31 : out std_logic;
	   overflow       : out std_logic);
end addersubtractor;
------------------------------------------------------------
architecture structure of addersubtractor is

component Nripplefulladder is
  generic(N : integer := 32);
  port(c_in          : in std_logic;
       i_X          : in std_logic_vector(N-1 downto 0);
	   i_Y          : in std_logic_vector(N-1 downto 0);
	   o_sum          : out std_logic_vector(N-1 downto 0);
	   c_31          : out std_logic;
       c_out          : out std_logic);
end component;

component onescomp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;

component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

  
 -- Signal to carry inverted 
 signal B_invert         : std_logic_vector(N-1 downto 0);
 --Signal to go into adder
  signal B_correct         : std_logic_vector(N-1 downto 0);

  
  
 
begin

  inverter : onescomp
  Generic map (N => N)
    port MAP(i_B ,B_invert);
	
  addsubmux : mux2t1_N
  Generic map (N => N)
    port MAP(nAdd_Sub, i_B, B_invert,B_correct );


  addsub : Nripplefulladder
  Generic map (N => N)
    port MAP(nAdd_Sub, i_A ,B_correct, o_result,c_out31, overflow);






  
end structure;
