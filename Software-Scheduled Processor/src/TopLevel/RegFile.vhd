-------------------------------------------------------------------------
-- Chris hausner & Caden Otis
-- Iowa State University
-------------------------------------------------------------------------


-- RegFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a RegFile
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegFile is
  port(iCLK               : in std_logic;
       i_D 		            : in std_logic_vector(31 downto 0);
       i_rs 		            : in std_logic_vector(4 downto 0);
       i_rt 		          : in std_logic_vector(4 downto 0);
       i_rd  	   				: in std_logic_vector(4 downto 0);
	   i_rst  	   				: in std_logic;
	   i_wen  	   				: in std_logic;
       o_rs 		            : out std_logic_vector(31 downto 0);
       o_rt 		            : out std_logic_vector(31 downto 0));

end RegFile;

architecture structure of RegFile is
  

  component Mux32t1
    port(i_S          : in std_logic_vector(4 downto 0);
		i_D0          : in std_logic_vector(31 downto 0);
		i_D1          : in std_logic_vector(31 downto 0);
		i_D2          : in std_logic_vector(31 downto 0);
		i_D3          : in std_logic_vector(31 downto 0);
		i_D4          : in std_logic_vector(31 downto 0);
		i_D5          : in std_logic_vector(31 downto 0);
		i_D6          : in std_logic_vector(31 downto 0);
		i_D7          : in std_logic_vector(31 downto 0);
		i_D8          : in std_logic_vector(31 downto 0);
		i_D9          : in std_logic_vector(31 downto 0);
		i_D10          : in std_logic_vector(31 downto 0);
		i_D11          : in std_logic_vector(31 downto 0);
		i_D12          : in std_logic_vector(31 downto 0);
		i_D13          : in std_logic_vector(31 downto 0);
		i_D14          : in std_logic_vector(31 downto 0);
		i_D15          : in std_logic_vector(31 downto 0);
		i_D16          : in std_logic_vector(31 downto 0);
		i_D17          : in std_logic_vector(31 downto 0);
		i_D18          : in std_logic_vector(31 downto 0);
		i_D19          : in std_logic_vector(31 downto 0);
		i_D20          : in std_logic_vector(31 downto 0);
		i_D21          : in std_logic_vector(31 downto 0);
		i_D22          : in std_logic_vector(31 downto 0);
		i_D23          : in std_logic_vector(31 downto 0);
		i_D24          : in std_logic_vector(31 downto 0);
		i_D25          : in std_logic_vector(31 downto 0);
		i_D26          : in std_logic_vector(31 downto 0);
		i_D27          : in std_logic_vector(31 downto 0);
		i_D28          : in std_logic_vector(31 downto 0);
		i_D29          : in std_logic_vector(31 downto 0);
		i_D30          : in std_logic_vector(31 downto 0);
		i_D31          : in std_logic_vector(31 downto 0);
		o_O          : out std_logic_vector(31 downto 0));
  end component;

  component Fiveto32Decoder
    port(i_EN          : in std_logic;
       i_D          : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  component N_bit_register
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;


 --Signal to carry the reg outputs
type bus_t is array(31 downto 0) of std_logic_vector(31 downto 0);
Signal mux_bus : bus_t;
--Signal to carry the Decoder output
signal o_Decoder         : std_logic_vector(31 downto 0);

begin


  decoder: Fiveto32Decoder
    port MAP(i_EN            => i_wen, 
             i_D               => i_rd,
             o_O               => o_Decoder);


  ---------------------------------------------------------------------------
  -- Level 1: Registers
  ---------------------------------------------------------------------------
  
  
  regFile0: N_bit_register 
	Generic map (N => 32)
	port map(
                i_CLK     => iCLK,  
	            i_RST     => '1',  
                i_WE     => i_wen, 
				i_D      => i_D,			  
                o_Q      => mux_bus(0)); 
  
  nbitreg: for i in 1 to 31 generate
    regFile1: N_bit_register 
	Generic map (N => 32)
	port map(
                i_CLK     => iCLK,  
	            i_RST     => i_rst,  
                i_WE     => o_Decoder(i), 
				i_D      => i_D,			  
                o_Q      => mux_bus(i)); 
  end generate nbitreg;
    
  ---------------------------------------------------------------------------
  -- Level 2: MUX's
  ---------------------------------------------------------------------------
  Mux_rs: Mux32t1------------- MUX => Local
    port MAP(i_S             =>  i_rs,
             i_D0               => mux_bus(0),
			 i_D1               => mux_bus(1),
			 i_D2               => mux_bus(2),
			 i_D3               => mux_bus(3),
			 i_D4               => mux_bus(4),
			 i_D5               => mux_bus(5),
			 i_D6               => mux_bus(6),
			 i_D7               => mux_bus(7),
			 i_D8               => mux_bus(8),
			 i_D9               => mux_bus(9),
			 i_D10               => mux_bus(10),
			 i_D11               => mux_bus(11),
			 i_D12               => mux_bus(12),
			 i_D13               => mux_bus(13),
			 i_D14               => mux_bus(14),
			 i_D15               => mux_bus(15),
			 i_D16               => mux_bus(16),
			 i_D17               => mux_bus(17),
			 i_D18               => mux_bus(18),
			 i_D19               => mux_bus(19),
			 i_D20               => mux_bus(20),
			 i_D21               => mux_bus(21),
			 i_D22               => mux_bus(22),
			 i_D23               => mux_bus(23),
			 i_D24               => mux_bus(24),
			 i_D25               => mux_bus(25),
			 i_D26               => mux_bus(26),
			 i_D27               => mux_bus(27),
			 i_D28               => mux_bus(28),
			 i_D29               => mux_bus(29),
			 i_D30               => mux_bus(30),
			 i_D31               => mux_bus(31),
             o_O               => o_rs);


  Mux_rt: Mux32t1------------- MUX => Local
    port MAP(i_S             =>  i_rt,
             i_D0               => mux_bus(0),
			 i_D1               => mux_bus(1),
			 i_D2               => mux_bus(2),
			 i_D3               => mux_bus(3),
			 i_D4               => mux_bus(4),
			 i_D5               => mux_bus(5),
			 i_D6               => mux_bus(6),
			 i_D7               => mux_bus(7),
			 i_D8               => mux_bus(8),
			 i_D9               => mux_bus(9),
			 i_D10               => mux_bus(10),
			 i_D11               => mux_bus(11),
			 i_D12               => mux_bus(12),
			 i_D13               => mux_bus(13),
			 i_D14               => mux_bus(14),
			 i_D15               => mux_bus(15),
			 i_D16               => mux_bus(16),
			 i_D17               => mux_bus(17),
			 i_D18               => mux_bus(18),
			 i_D19               => mux_bus(19),
			 i_D20               => mux_bus(20),
			 i_D21               => mux_bus(21),
			 i_D22               => mux_bus(22),
			 i_D23               => mux_bus(23),
			 i_D24               => mux_bus(24),
			 i_D25               => mux_bus(25),
			 i_D26               => mux_bus(26),
			 i_D27               => mux_bus(27),
			 i_D28               => mux_bus(28),
			 i_D29               => mux_bus(29),
			 i_D30               => mux_bus(30),
			 i_D31               => mux_bus(31),
             o_O               => o_rt);

    

  end structure;
