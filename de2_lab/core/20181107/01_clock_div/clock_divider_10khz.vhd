
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clock_divider_10khz IS
	PORT(
		clk: IN  STD_LOGIC;
		clk_out : OUT STD_LOGIC);
END clock_divider_10khz;

ARCHITECTURE a OF clock_divider_10khz IS
SIGNAL count : STD_LOGIC_VECTOR(2499 downto 0);
BEGIN
	PROCESS (clk)
		VARIABLE count : INTEGER RANGE 0 to 2499;
	BEGIN
			IF (clk'EVENT and clk = '1') THEN
				IF (count = 2499) THEN
					clk_out <= count(2499);
					count := 0;
				ELSE
					count := count + 1;
				END IF;
			END IF;
	END PROCESS;
END a;

