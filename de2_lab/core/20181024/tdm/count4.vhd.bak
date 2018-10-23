-- count4.vhd
-- Four-bit binary counter based on a component
--   from the Library of Parameterized Modules (LPM)
-- Counter has an active-LOW reset

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY count4 IS
	PORT(
		clk, reset	: IN	STD_LOGIC;
		ctr_q		: OUT	STD_LOGIC_VECTOR (3 downto 0));
END count4;

ARCHITECTURE count OF count4 IS
	SIGNAL clrn : STD_LOGIC;
BEGIN
-- Instantiate 5-bit counter
	clock_divider: lpm_counter
		GENERIC MAP (LPM_WIDTH	=>	4) 
		PORT MAP (	clock 		=>	clk,
					aclr		=>	clrn, 
					q 			=>	ctr_q(3 DOWNTO 0));

	clrn	<=	not reset;
END count;

