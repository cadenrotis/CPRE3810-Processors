-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a shifter
-- that will take in 32 bits and shift it SSL, SLR, SRA Depening on selector
--ShiftType: 00 = SSL, 01=SRL, 10=SRA
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity shifter is
  port(i_RT          : in std_logic_vector(31 downto 0);
       i_ShiftType         : in std_logic_vector(1 downto 0);
       i_Shamt         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end shifter;
------------------------------------------------------------
architecture structure of shifter is

  
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

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

--Signals for the sll
signal SLL_by1 :std_logic_vector(31 downto 0);
signal SLL_by2 :std_logic_vector(31 downto 0);
signal SLL_by4 :std_logic_vector(31 downto 0);
signal SLL_by8 :std_logic_vector(31 downto 0);
signal SLL_by16 :std_logic_vector(31 downto 0);
--Signals for the srl
signal SRL_by1 :std_logic_vector(31 downto 0);
signal SRL_by2 :std_logic_vector(31 downto 0);
signal SRL_by4 :std_logic_vector(31 downto 0);
signal SRL_by8 :std_logic_vector(31 downto 0);
signal SRL_by16 :std_logic_vector(31 downto 0);
--Signals for the sra
signal SRA_by1 :std_logic_vector(31 downto 0);
signal SRA_by2 :std_logic_vector(31 downto 0);
signal SRA_by4 :std_logic_vector(31 downto 0);
signal SRA_by8 :std_logic_vector(31 downto 0);
signal SRA_by16 :std_logic_vector(31 downto 0);

--Outputs for 32bit 4t1 Mux's
signal out_mux4t1_0 :std_logic_vector(31 downto 0); 
signal out_mux4t1_1 :std_logic_vector(31 downto 0);
signal out_mux4t1_2 :std_logic_vector(31 downto 0);
signal out_mux4t1_3 :std_logic_vector(31 downto 0);
signal out_mux4t1_4 :std_logic_vector(31 downto 0);


--Outputs for 32bit 2t1 Mux's
signal out_mux2t1_0 :std_logic_vector(31 downto 0); 
signal out_mux2t1_1 :std_logic_vector(31 downto 0);
signal out_mux2t1_2 :std_logic_vector(31 downto 0);
signal out_mux2t1_3 :std_logic_vector(31 downto 0);
--Sign bit
signal signBit : std_logic;






begin
	signBit <= i_RT(31);--Save sign bit
	--Shift left Logic
	SLL_by1 <= i_RT(30 downto 0) & '0';
	--Shift right Logic
	SRL_by1 <= '0' & i_RT(31 downto 1);
	--Shift right A (Keep sign preserved)
    SRA_by1 <= signBit & i_RT(31 downto 1);
    




  mux4t1_0 : mux4t1_N
    port MAP(i_ShiftType, SLL_by1, SRL_by1, SRA_by1, x"00000000", out_mux4t1_0);
  mux2t1_0 : mux2t1_N
    port MAP(i_Shamt(0), i_RT, out_mux4t1_0, out_mux2t1_0);
 
 
 	SLL_by2 <= out_mux2t1_0(29 downto 0) & "00";
    SRL_by2 <= "00" & out_mux2t1_0(31 downto 2);
	SRA_by2 <= (signBit & signBit) & out_mux2t1_0(31 downto 2);
    
 
   mux4t1_1 : mux4t1_N
    port MAP(i_ShiftType, SLL_by2, SRL_by2, SRA_by2, x"00000000", out_mux4t1_1);
  mux2t1_1 : mux2t1_N
    port MAP(i_Shamt(1), out_mux2t1_0, out_mux4t1_1, out_mux2t1_1);
	
	SLL_by4 <= out_mux2t1_1(27 downto 0) & "0000";
	SRL_by4 <= "0000" & out_mux2t1_1(31 downto 4);
	SRA_by4 <= (signBit & signBit & signBit & signBit) & out_mux2t1_1(31 downto 4);
    
	
   mux4t1_2 : mux4t1_N
    port MAP(i_ShiftType, SLL_by4, SRL_by4, SRA_by4, x"00000000", out_mux4t1_2);
  mux2t1_2 : mux2t1_N
    port MAP(i_Shamt(2), out_mux2t1_1, out_mux4t1_2, out_mux2t1_2);
	
	SLL_by8 <= out_mux2t1_2(23 downto 0) & "00000000";
	SRL_by8 <= "00000000" & out_mux2t1_2(31 downto 8);
	SRA_by8 <= (signBit & signBit & signBit & signBit & signBit & signBit & signBit & signBit) & out_mux2t1_2(31 downto 8);
    
	
	
   mux4t1_3 : mux4t1_N
    port MAP(i_ShiftType, SLL_by8, SRL_by8, SRA_by8, x"00000000", out_mux4t1_3);	
  mux2t1_3 : mux2t1_N
    port MAP(i_Shamt(3), out_mux2t1_2, out_mux4t1_3, out_mux2t1_3);
	
	SLL_by16 <= out_mux2t1_3(15 downto 0) & "0000000000000000";
	SRL_by16 <= "0000000000000000" & out_mux2t1_3(31 downto 16);
	SRA_by16 <= (signBit & signBit & signBit & signBit & signBit & signBit & signBit & signBit &
               signBit & signBit & signBit & signBit & signBit & signBit & signBit & signBit) & out_mux2t1_3(31 downto 16);
	
   mux4t1_4 : mux4t1_N
    port MAP(i_ShiftType, SLL_by16, SRL_by16, SRA_by16, x"00000000", out_mux4t1_4);
  mux2t1_4 : mux2t1_N
    port MAP(i_Shamt(4), out_mux2t1_3, out_mux4t1_4, o_O);
  
end structure;
