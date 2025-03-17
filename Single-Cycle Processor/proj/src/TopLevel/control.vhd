-------------------------------------------------------------------------
-- Christopher Hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a Control for my MIPS processor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(i_OpCode 	: in std_logic_vector(5 downto 0);
	   i_FunctCode 	: in std_logic_vector(5 downto 0);
	   o_Halt 		: out std_logic;
	   o_RegDest	: out std_logic;
	   o_JumpSelect : out std_logic;
	   o_JRSelect	: out std_logic;
	   o_Branch		: out std_logic;
	   o_LoadAmt	: out std_logic_vector(1 downto 0);
	   o_Bne		: out std_logic;
	   o_MemToReg	: out std_logic;
	   o_AluControl : out std_logic_vector(3 downto 0);
	   o_DmemWr		: out std_logic;
	   o_AluSrc		: out std_logic;
	   o_SignExtendIm: out std_logic;
	   o_SignExtendLoad: out std_logic;
	   o_RegWr		: out std_logic;
	   o_JalSelect        : out std_logic;
	   o_OvfEn      : out std_logic;
	   o_ShiftType : out std_logic_vector(1 downto 0) );

end control;


architecture dataflow of control is

signal s_UseOp : std_logic;  --Used for all muxs to chose OPcode or FUNCT code 1= useOP


--------------------------------------Based on OPCode
signal op_AluControl :std_logic_vector(3 downto 0);
signal op_AluSrc		:std_logic;
signal op_RegWr		:std_logic;
signal op_OvfEn     :std_logic;
signal op_RegDest   :std_logic;

signal op_Halt   :std_logic;
signal op_JumpSelect   :std_logic;
signal op_JRSelect   :std_logic;
signal op_Branch   :std_logic;
signal op_LoadAmt   :std_logic_vector(1 downto 0);
signal op_Bne   :std_logic;
signal op_MemToReg   :std_logic;
signal op_DmemWr   :std_logic;
signal op_SignExtendIm   :std_logic;
signal op_SignExtendLoad   :std_logic;
signal op_JalSelect   :std_logic;
signal op_ShiftType   :std_logic_vector(1 downto 0);
--------------------------------------Based on Funct
signal f_AluControl :std_logic_vector(3 downto 0);
signal f_AluSrc		:std_logic;
signal f_RegWr		:std_logic;
signal f_OvfEn     :std_logic;
signal f_RegDest : std_logic;

signal f_Halt   :std_logic;
signal f_JumpSelect   :std_logic;
signal f_JRSelect   :std_logic;
signal f_Branch   :std_logic;
signal f_LoadAmt   :std_logic_vector(1 downto 0);
signal f_Bne   :std_logic;
signal f_MemToReg   :std_logic;
signal f_DmemWr   :std_logic;
signal f_SignExtendIm   :std_logic;
signal f_SignExtendLoad   :std_logic;
signal f_JalSelect   :std_logic;
signal f_ShiftType   :std_logic_vector(1 downto 0);
---------------------------------------

begin

s_UseOp <= i_OpCode(5) or i_OpCode(4) or i_OpCode(3) or i_OpCode(2) or i_OpCode(1) or i_OpCode(0); 


------------------------------------------------------------------------------------Set OPcode Versions
WITH i_OpCode SELECT
        op_Halt <= '1' WHEN "010100",  -- Opcode(010100) --No funct for hault so this is all we need. 
             '0' WHEN OTHERS;    -- Default case

WITH i_OpCode SELECT --Only case for JumpSelect so no alt needed for funct codes
        op_JumpSelect <= '1' WHEN "000011", 
			'1' WHEN "000010", 
             '0' WHEN OTHERS;
WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_Branch <= '1' WHEN "000101", 
			'1' WHEN "000100", 
             '0' WHEN OTHERS;
			 
WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_LoadAmt <= "11" WHEN "100000", --LBU
			"11" WHEN "100100", --Lb
			"01" WHEN "100001", -- LH
			"01" WHEN "100101", --LHU
			 "00" WHEN OTHERS;
WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_Bne <= '1' WHEN "000101", 
             '0' WHEN OTHERS;		 
WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_MemToReg <= '1' WHEN "100000", 
			'1' WHEN "100001", 
			'1' WHEN "100100", 
			'1' WHEN "100101", 
			'1' WHEN "100011", 
             '0' WHEN OTHERS;	

WITH i_OpCode SELECT 
        op_AluControl <= "0001" WHEN "001100", 
				"0110" WHEN "001111", 
				"0011" WHEN "001110", 
				"0010" WHEN "001101", 
				"1101" WHEN "001010", 
				"1000" WHEN "000100", 
				"1000" WHEN "000101", 
             "0000" WHEN OTHERS;	
WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_DmemWr <= '1' WHEN "101011", --SW only
             '0' WHEN OTHERS;

WITH i_OpCode SELECT 
        op_AluSrc <= '1' WHEN "001000", 
			'1' WHEN "001001",
			'1' WHEN "001100",
			'1' WHEN "001111",
			'1' WHEN "100011",
			'1' WHEN "001110",
			'1' WHEN "001101",
			'1' WHEN "001010",
			'1' WHEN "101011",
			'1' WHEN "100000",
			'1' WHEN "100001",
			'1' WHEN "100100",
			'1' WHEN "100101",
             '0' WHEN OTHERS;			 



WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_SignExtendIm <= '1' WHEN "001000", 
			'1' WHEN "001001",
			'1' WHEN "100011",
			'1' WHEN "001010",
			'1' WHEN "101011",
			'1' WHEN "000100",
			'1' WHEN "000101",
             '0' WHEN OTHERS;

WITH i_OpCode SELECT --Only OPcode, no Funct Needed. 
        op_SignExtendLoad <= '1' WHEN "100000", 
			'1' WHEN "100001",
             '0' WHEN OTHERS;	

WITH i_OpCode SELECT 
        op_RegWr <= '0' WHEN "101011", 
			'0' WHEN "000100",
			'0' WHEN "000101",
			'0' WHEN "000010",
             '1' WHEN OTHERS;			 
		

WITH i_OpCode SELECT 
        op_JalSelect <= '1' WHEN "000011", 
             '0' WHEN OTHERS;		
			 
WITH i_OpCode SELECT 
        op_OvfEn <= '1' WHEN "001000", 
             '0' WHEN OTHERS;

op_RegDest <= '0';
op_JRSelect <= '0';
op_ShiftType <= "00";			 
------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------Set Funct Versions
f_Halt <= '0';
f_JumpSelect <= '0';
f_Branch <= '0';
f_LoadAmt <= "00";
f_Bne <= '0';
f_MemToReg <= '0';
f_DmemWr <= '0';
f_SignExtendIm <= '0';
f_SignExtendLoad <= '0';
f_JalSelect <= '0';




 WITH i_FunctCode SELECT 
        f_JRSelect <= '1' WHEN "001000", 
             '0' WHEN OTHERS;
 
 f_RegDest <= '1';	
  WITH i_FunctCode SELECT 
        f_AluControl <= "0001" WHEN "100100", 
			"0100" WHEN "100111", 
			"0011" WHEN "100110", 
			"0010" WHEN "100101", 
			"1101" WHEN "101010", 
			"0111" WHEN "000000", 
			"0111" WHEN "000010", 
			"0111" WHEN "000011", 
			"1000" WHEN "100010", 
			"1000" WHEN "100011", 
			"0111" WHEN "000100", 
			"0111" WHEN "000110", 
			"0111" WHEN "000111", 
             "0000" WHEN OTHERS;
 WITH i_FunctCode SELECT 
        f_RegWr <= '0' WHEN "001000", 
             '1' WHEN OTHERS;
  
 WITH i_FunctCode SELECT 
        f_OvfEn <= '1' WHEN "100000", 
			'1' WHEN "100010", 
             '0' WHEN OTHERS;  
  
  
  
  
  
  WITH i_FunctCode SELECT 
        f_AluSrc <= '1' WHEN "000000", 
			'1' WHEN "000010",
			'1' WHEN "000011",
             '0' WHEN OTHERS;
  
  
  
  
  
WITH i_FunctCode SELECT 
     f_ShiftType <= "01" WHEN "000010", 
     "10" WHEN "000011",
	 "01" WHEN "000110",
	 "10" WHEN "000111",
     "00" WHEN OTHERS;
  
  
  ------------------------------------------------------------------------------------Mux
  
   WITH s_UseOp SELECT 
        o_RegDest <= op_RegDest WHEN '1', 
             f_RegDest WHEN OTHERS;  
  
   WITH s_UseOp SELECT 
        o_AluControl <= op_AluControl WHEN '1', 
             f_AluControl WHEN OTHERS;  
			 
   WITH s_UseOp SELECT 
        o_AluSrc <= op_AluSrc WHEN '1', 
             f_AluSrc WHEN OTHERS;  

   WITH s_UseOp SELECT 
        o_RegWr <= op_RegWr WHEN '1', 
             f_RegWr WHEN OTHERS;  

   WITH s_UseOp SELECT 
        o_OvfEn <= op_OvfEn WHEN '1', 
             f_OvfEn WHEN OTHERS;  


-----Added because needed with redesign
   WITH s_UseOp SELECT 
        o_Halt <= op_Halt WHEN '1', 
             f_Halt WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_JumpSelect <= op_JumpSelect WHEN '1', 
             f_JumpSelect WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_JRSelect <= op_JRSelect WHEN '1', 
             f_JRSelect WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_Branch <= op_Branch WHEN '1', 
             f_Branch WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_LoadAmt <= op_LoadAmt WHEN '1', 
             f_LoadAmt WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_Bne <= op_Bne WHEN '1', 
             f_Bne WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_MemToReg <= op_MemToReg WHEN '1', 
             f_MemToReg WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_DmemWr <= op_DmemWr WHEN '1', 
             f_DmemWr WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_SignExtendIm <= op_SignExtendIm WHEN '1', 
             f_SignExtendIm WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_SignExtendLoad <= op_SignExtendLoad WHEN '1', 
             f_SignExtendLoad WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_JalSelect <= op_JalSelect WHEN '1', 
             f_JalSelect WHEN OTHERS; 
   WITH s_UseOp SELECT 
        o_ShiftType <= op_ShiftType WHEN '1', 
             f_ShiftType WHEN OTHERS; 





















			 
  
end dataflow;
	   
	 
