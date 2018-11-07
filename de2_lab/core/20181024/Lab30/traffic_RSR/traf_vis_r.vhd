-- Traffic controller with a clock divider to slow down system clock
-- Altera UP-1: Divide by 2^25 (~0.75 Hz)
-- RSR PLDT-2: Divide by 2^22 (~0.95 Hz)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY traf_vis_r IS
	PORT(
		clk, reset					 : IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg : OUT STD_LOGIC;
		tick: OUT STD_LOGIC;
		unused: OUT STD_LOGIC_VECTOR(1 to 9));
END traf_vis_r;

ARCHITECTURE a OF traf_vis_r IS
	COMPONENT clkdiv
	GENERIC (width: POSITIVE);
	PORT (clk_in : IN STD_LOGIC;
	  	clk_out: OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT traffic_r
	PORT(
		clk, reset					 : IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL internal_clock: STD_LOGIC;
BEGIN
	clock_divider: clkdiv
	GENERIC MAP (width => 22)
	PORT MAP (clk, internal_clock);

	traffic_controller: traffic_r
	PORT MAP(internal_clock, reset, nsr, nsy, nsg, ewr, ewy, ewg);

	-- Monitor clock pulse on LED
	tick <= internal_clock;
	-- Disable unused LEDs
	unused <= (others => '0');
END a;
