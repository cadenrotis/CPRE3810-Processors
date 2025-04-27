-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Changed by -- Christopher Hausner & Caden Otis
-------------------------------------------------------------------------


-- dffgPC.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dffgStage is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
	   i_RST_VAL    : in std_logic;
       o_Q          : out std_logic);   -- Data value output

end dffgStage;

architecture mixed of dffgStage is
  signal s_D    : std_logic;    -- Multiplexed input to the FF
  signal s_Q    : std_logic;    -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;
  
  -- Create a multiplexed input to the FF based on i_WE
  with i_WE select
    s_D <= i_D when '1',
           s_Q when others;
  
  -- This process handles the syncrhonous reset and
  -- synchronous write.
process (i_CLK)
begin
  if (rising_edge(i_CLK)) then
    if (i_RST = '1') then
      s_Q <= i_RST_VAL; -- Reset value, e.g. "(others => '0')" for N-bit values
    else
      s_Q <= s_D; -- Normal operation
    end if;
  end if;
end process;
  
end mixed;
