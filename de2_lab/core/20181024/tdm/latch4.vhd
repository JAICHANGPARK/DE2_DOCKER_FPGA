-- latch4.vhd
-- 4-bit latch with enable ("gate") (LPM components)
-- gate = 1: transparent
-- gate = 0: latch


LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

ENTITY latch4 IS
	PORT(
		d		: IN	STD_LOGIC_VECTOR (3 downto 0);
		enable	: IN	STD_LOGIC;
		q		: OUT	STD_LOGIC_VECTOR (3 downto 0));
END latch4;

ARCHITECTURE latch OF latch4 IS
BEGIN
	four_bit_latch: lpm_latch
		GENERIC MAP(LPM_WIDTH	=>	4)
		PORT MAP(data	=>	d(3 downto 0),
				 gate	=>	enable,
				 q		=>	q(3 downto 0));
END latch;
