-- Traffic controller with a clock divider to slow down system clock
-- Altera UP-1: Divide by 2^25 (~0.75 Hz)
-- RSR PLDT-2: Divide by 2^22 (~0.95 Hz)
-- Also contains latches for input switches to control walk cycle
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.ALL;
LIBRARY altera;
USE altera.maxplus2.ALL;

ENTITY traf_walk_vis_r IS
	PORT(
		clk, reset, ns_walk_sw, ew_walk_sw 	: IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg 		: OUT STD_LOGIC;
		ns_walk_lt, ew_walk_lt				: OUT STD_LOGIC;
		tick: OUT STD_LOGIC;
		unused: OUT STD_LOGIC_VECTOR(1 to 7));
END traf_walk_vis_r;

ARCHITECTURE a OF traf_walk_vis_r IS
	COMPONENT DFF
		PORT (d   : IN STD_LOGIC;
      		clk : IN STD_LOGIC;
			clrn: IN STD_LOGIC;
			prn : IN STD_LOGIC;
			q   : OUT STD_LOGIC );
		END COMPONENT;

	COMPONENT clkdiv
	GENERIC (width: POSITIVE);
	PORT (clk_in : IN STD_LOGIC;
	  	clk_out: OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT traffic_walk_r
	PORT(
		clk, reset, ns_walk_sw, ew_walk_sw 			: IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg 				: OUT STD_LOGIC;
		ns_walk_lt, ns_reset, ew_walk_lt, ew_reset	: OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL internal_clock	: STD_LOGIC;
	SIGNAL internal_ns_reset: STD_LOGIC;
	SIGNAL internal_ns_sw	: STD_LOGIC;
	SIGNAL internal_ew_reset: STD_LOGIC;
	SIGNAL internal_ew_sw	: STD_LOGIC;
	SIGNAL dff_clk			: STD_LOGIC;
	SIGNAL dff_d			: STD_LOGIC;
BEGIN
	clock_divider: clkdiv
	GENERIC MAP (width => 22)
	PORT MAP (clk, internal_clock);

	dff_d	<= '0';
	dff_clk	<= '0';
	ns_latch: DFF
	PORT MAP(dff_d, dff_clk, internal_ns_reset, ns_walk_sw, internal_ns_sw);

	ew_latch: DFF
	PORT MAP(dff_d, dff_clk, internal_ew_reset, ew_walk_sw, internal_ew_sw);

	traffic_controller: traffic_walk_r
	PORT MAP(clk		=> internal_clock,
			reset		=> reset,
			ns_walk_sw	=> internal_ns_sw,
			ew_walk_sw	=> internal_ew_sw,
			nsr			=> nsr,
			nsy			=> nsy,
			nsg			=> nsg,
			ewr			=> ewr,
			ewy			=> ewy,
			ewg			=> ewg,
			ns_walk_lt	=> ns_walk_lt,
			ns_reset	=> internal_ns_reset,
			ew_walk_lt	=> ew_walk_lt,
			ew_reset	=> internal_ew_reset);

	-- Monitor clock pulse on LED
	tick <= internal_clock;
	-- Disable unused LEDs
	unused <= (others => '0');
END a;
