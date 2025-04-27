-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- LoadSelector.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an LoadSelector.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity LoadSelector is

  port(i_SignS        : in std_logic;     --when 1 it is signed. 
       i_LoadAmt        : in std_logic_vector(1 downto 0);
	   i_Data        : in std_logic_vector(31 downto 0);
	   i_PosSelect        : in std_logic_vector(1 downto 0);
       o_O        : out std_logic_vector(31 downto 0));  

end LoadSelector;
architecture mixed of LoadSelector is

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

  
component mux4t1_N is
  generic(N : integer := 32);
  port(
    i_S 		          : in std_logic_vector(1 downto 0);
	i_D0 		            : in std_logic_vector(N-1 downto 0);
	i_D1 		            : in std_logic_vector(N-1 downto 0);
	i_D2 		            : in std_logic_vector(N-1 downto 0);
	i_D3 		            : in std_logic_vector(N-1 downto 0);
    o_O 		            : out std_logic_vector(N-1 downto 0));
end component;

component Extender16t32 is
  port(i_E        : in std_logic_vector(15 downto 0);     -- input
       i_S        : in std_logic;     			  -- Select 0 for zero extend, 1 for signed. 
       o_E        : out std_logic_vector(31 downto 0));   --Output
end component;

component Extender8t32 is
  port(i_E        : in std_logic_vector(7 downto 0);     -- input
       i_S        : in std_logic;     			  -- Select 0 for zero extend, 1 for signed. 
       o_E        : out std_logic_vector(31 downto 0));   --Output
end component;

signal s_16bitRaw : std_logic_vector(15 downto 0); -- Signal for after the MUX of 16 upper and lower. 
signal s_8bitRaw : std_logic_vector(7 downto 0); -- Signal for after the MUX of 8 upper and lower. 
signal s_16bit : std_logic_vector(31 downto 0); -- Signal for after the MUX of 16 upper and lower. 
signal s_8bit : std_logic_vector(31 downto 0); -- Signal for after the MUX of 16 upper and lower. 


begin


mux_16UpperLower : mux2t1_N --Mux to select Upper and Lower 16 bits
	generic MAP(16)
    port MAP(i_PosSelect(1), i_Data(15 downto 0), i_Data(31 downto 16) , s_16bitRaw);
Extender16t32Bits : Extender16t32 --Extend 16 bits to 32
    port MAP(s_16bitRaw, i_SignS, s_16bit);



mux_8UpperLower : mux2t1_N --Mux to select Upper and Lower 16 bits
	generic MAP(8)
    port MAP(i_PosSelect(0), s_16bitRaw(7 downto 0), s_16bitRaw(15 downto 8) , s_8bitRaw);
Extender8t32Bits : Extender8t32 --Extend 8 bits to 32
    port MAP(s_8bitRaw, i_SignS, s_8bit);


mux4t1_32bit : mux4t1_N --Extend 16 bits to 32
    port MAP(i_LoadAmt, i_Data, s_16bit, x"00000000", s_8bit,  o_O);

  
end mixed;
