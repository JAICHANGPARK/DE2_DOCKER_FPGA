-- shift4.vhd
-- Four-bit serial shift register based on a component
--   from the Library of Parameterized Modules (LPM)
-- Register has an active-LOW reset and parallel load.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY shift4 IS
	PORT(
		parallel			: IN	STD_LOGIC_VECTOR(3 downto 0);
		serial_in			: IN	STD_LOGIC	:= '0';
		load, clk, reset	: IN	STD_LOGIC;
		serial_out			: OUT	STD_LOGIC);
END shift4;

ARCHITECTURE shift OF shift4 IS
	SIGNAL	clrn:	STD_LOGIC;
BEGIN
-- Instantiate 4-bit shift register
	four_bit_shift: lpm_shiftreg
		GENERIC MAP (LPM_WIDTH	=> 4, LPM_DIRECTION => "RIGHT") 
		PORT MAP (	aclr		=> clrn,
					clock 		=> clk,
					load 		=> load,
--					shiftin		=> serial_in,
					data 		=> parallel(3 downto 0),
					shiftout	=> serial_out);

	clrn	<=	not reset;
END shift;


