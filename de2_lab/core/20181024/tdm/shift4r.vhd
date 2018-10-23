-- shift4r.vhd
-- Four-bit serial shift register based on a component
--   from the Library of Parameterized Modules (LPM)
-- Register has an active-LOW reset and parallel load.  Serial input is set to '0'.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY shift4r IS
	PORT(
		serial_in			: IN	STD_LOGIC;
		clk, reset, enable	: IN	STD_LOGIC;
		q_out				: OUT	STD_LOGIC_VECTOR(3 downto 0));
END shift4r;

ARCHITECTURE shift OF shift4r IS
	COMPONENT lpm_shiftreg
		GENERIC (LPM_WIDTH: POSITIVE;LPM_DIRECTION: STRING);
		PORT (clock: IN STD_LOGIC;
			enable: IN STD_LOGIC := '1';
			shiftin: IN STD_LOGIC := '1';
			aclr: IN STD_LOGIC := '0';
			q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL	clrn:	STD_LOGIC;
BEGIN
--Instantiate 4-bit shift register
	four_bit_shift: lpm_shiftreg
		GENERIC MAP (LPM_WIDTH	=> 4, LPM_DIRECTION => "RIGHT") 
		PORT MAP (	aclr		=> clrn,
					clock 		=> clk,
					enable 		=> enable,
					shiftin		=> serial_in,
					q			=> q_out(3 downto 0));

	clrn	<=	not reset;
END shift;


