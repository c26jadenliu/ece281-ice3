--+----------------------------------------------------------------------------
--| 
--| DESCRIPTION   : This file implements the top level module for a BASYS 
--|
--|     Ripple-Carry Adder: S = A + B
--|
--|     Our **user** will input the following:
--|
--|     - $C_{in}$ on switch 0
--|     - $A$ on switches 4-1
--|     - $B$ on switches 15-12
--|
--|     Our **user** will expect the following outputs:
--|
--|     - $Sum$ on LED 3-0
--|     - $C_{out} on LED 15
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
	port(
		-- Switches
		sw		:	in  std_logic_vector(15 downto 0);
		
		-- LEDs
		led	    :	out	std_logic_vector(15 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
	
    -- declare the component of your top-level design
    component ripple_adder is
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC
           );
       end component ripple_adder;  

    -- declare any signals you will need
    signal w_A    : std_logic_vector(3 downto 0);
    signal w_B    : std_logic_vector(3 downto 0);
    signal w_Cin  : std_logic;
    signal w_Sum  : std_logic_vector(3 downto 0);
    signal w_Cout : std_logic;
	
  
begin
	-- PORT MAPS --------------------
    w_Cin <= sw(0);              
    w_A   <= sw(4 downto 1);    
    w_B   <= sw(15 downto 12);
	---------------------------------
	U1: ripple_adder
        port map (
            A    => w_A,
            B    => w_B,
            Cin  => w_Cin,
            S    => w_Sum,
            Cout => w_Cout
        );
        
        led(3 downto 0)  <= w_Sum;   -- Sum on LED 3-0
        led(15)          <= w_Cout;  -- Carry-out on LED 15
	-- CONCURRENT STATEMENTS --------
	led(14 downto 4) <= (others => '0'); -- Ground unused LEDs
	---------------------------------
end top_basys3_arch;
