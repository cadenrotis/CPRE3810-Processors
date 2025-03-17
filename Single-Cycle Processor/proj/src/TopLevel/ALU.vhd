-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ALU
-- that will take in A, B, IM, ALUSrc, ShiftType, Shamt, ALUControl
-- it will output Ovf, Zeroflag and result (O).
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
  port(i_A          : in std_logic_vector(31 downto 0);
	   i_B          : in std_logic_vector(31 downto 0);
	   i_Im          : in std_logic_vector(31 downto 0);
       i_ALUSrc         : in std_logic;
	   i_OvfEn       :in std_logic;
	   i_ShiftType    : in std_logic_vector(1 downto 0);
       i_Shamt         : in std_logic_vector(4 downto 0);
	   i_ALUControl   :in std_logic_vector (3 downto 0); -- Bit 3 is the Add/Sub bit.
	   o_Ovf          : out std_logic;
	   o_Zero          : out std_logic;
       o_Result          : out std_logic_vector(31 downto 0));
end ALU;
------------------------------------------------------------
architecture structure of ALU is

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;


component mux2t1 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);
end component;



component andg32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

component org32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

component invg32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

component shifter is
  port(i_RT          : in std_logic_vector(31 downto 0);
       i_ShiftType         : in std_logic_vector(1 downto 0);
       i_Shamt         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end component;

component xorg32 is
  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0));
end component;

component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org1_32bit is
  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);
end component;

component invg is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

component mux8t1_32Bit is
  port(i_S          : in std_logic_vector(2 downto 0);
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
	   i_D2         : in std_logic_vector(31 downto 0);
	   i_D3         : in std_logic_vector(31 downto 0);
	   i_D4         : in std_logic_vector(31 downto 0);
       i_D5         : in std_logic_vector(31 downto 0);
	   i_D6         : in std_logic_vector(31 downto 0);
	   i_D7         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end component;

component addersubtractor is
  generic(N : integer := 32);
  port(nAdd_Sub          : in std_logic;
       i_A          : in std_logic_vector(N-1 downto 0);
	   i_B          : in std_logic_vector(N-1 downto 0);
	   o_result          : out std_logic_vector(N-1 downto 0);
	   c_out31       :out std_logic;
	   overflow       : out std_logic);
end component;



--Signals

signal s_B : std_logic_vector(31 downto 0);
signal s_AShamt : std_logic_vector(4 downto 0); --Shamt Bits from A [last5]
signal s_Shamt : std_logic_vector(4 downto 0); --Shamt into shifter after MUX
signal s_AddSubSelect : std_logic; --Select add/Sub. Come from ALUcontrol
signal s_cout  : std_logic;  --Cout from Adder
signal s_c31  : std_logic;  --C31 from Adder
signal s_AddSub : std_logic_vector(31 downto 0); --Adder/Sub Output 
signal s_ovf  : std_logic;  --Ovf output signal from our XOR.
signal s_Shift : std_logic_vector(31 downto 0); --Our shifted Value 
signal s_And    :std_logic_vector(31 downto 0); --Our And value to go into Control Mux
signal s_Or    :std_logic_vector(31 downto 0);--Our Or value to go into Control Mux
signal s_Xor    :std_logic_vector(31 downto 0);--Our Xor value to go into Control Mux
signal s_Nor    :std_logic_vector(31 downto 0);--Our Nor value to go into Control Mux
signal s_Slt    :std_logic_vector(31 downto 0);--Our SLT value to go into Control Mux
signal s_NZero :std_logic; -- Inverse of Zero flag. 
signal s_Lui    :std_logic_vector(31 downto 0); -- LUI valye to go into control mux
signal s_result :std_logic_vector(31 downto 0); -- Stroe result 

begin
s_AShamt <= i_A(4 downto 0);
s_AddSubSelect <= i_ALUControl(3);

mux_BorIm : mux2t1_N --Mux to select IM or B
    port MAP(i_ALUSrc, i_B, i_Im, s_B);

mux_Shamt : mux2t1_N --Mux to select Shamt from Shamt or A
	generic MAP(5)
    port MAP(i_ALUSrc, s_AShamt, i_Shamt, s_Shamt);

AdderSub : addersubtractor --AdderSubtractor
    port MAP(s_AddSubSelect, i_A, s_B, s_AddSub,  s_c31, s_cout);

xorgOvf : xorg2 --Xor for OVF
    port MAP(s_c31, s_cout, s_ovf);

mux_OvfEnable : mux2t1 --Mux to select Ovf or not and set it to output. 
    port MAP(i_OvfEn, '0', s_ovf, o_Ovf);

Shift : shifter --Shifter to do our shift Op
    port MAP(i_B, i_ShiftType, s_Shamt, s_Shift);

 Andg: andg32 --Andgate32 bits
    port MAP(i_A,s_B,s_And);

 Org: org32 --Orgate32 bits 2 inputs
    port MAP(i_A,s_B,s_Or);

 Xorg: xorg32 --XOrgate32 bits 2 inputs
    port MAP(i_A,s_B,s_Xor);

 invg32bits: invg32 --NOrgate32 bits 2 inputs
    port MAP(s_Or,s_Nor);
	
	

s_Slt <= "0000000000000000000000000000000" & s_AddSub(31);--Our SLT value. 

 orgZero: org1_32bit --Orgate of 31 input bits for zero flag.
    port MAP(s_result,s_NZero);
	
invgZero: invg --Inverse not zero flag
    port MAP(s_NZero,o_Zero);

s_Lui <= s_B(15 downto 0) & x"0000"; --LUI value.



ControlMux: mux8t1_32Bit --Mux to select output 
    port MAP(i_ALUControl(2 downto 0), s_AddSub, s_And, s_Or, s_Xor, s_Nor,s_Slt, s_Lui, s_Shift, s_result);

o_Result <= s_result;


  
end structure;
