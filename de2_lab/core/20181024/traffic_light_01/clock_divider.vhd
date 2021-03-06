-- clkdiv.vhd
-- Clock divider of selectable width
-- For Altera UP-2, use width = 25
-- For RSR PLDT-2, use width = 22
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY clock_divider IS
	GENERIC(width : POSITIVE := 25);
	PORT(clk_in	: IN STD_LOGIC;
		clk_out : OUT STD_LOGIC);
END clock_divider;

ARCHITECTURE divider OF clock_divider IS
	SIGNAL count : STD_LOGIC_VECTOR(width-1 downto 0);
BEGIN
	PROCESS(clk_in)
		BEGIN
		IF(clk_in'EVENT and clk_in = '1')THEN
			count <= count + 1;
		END IF;
		
		clk_out <= count(width-1);
	END PROCESS;
END divider;