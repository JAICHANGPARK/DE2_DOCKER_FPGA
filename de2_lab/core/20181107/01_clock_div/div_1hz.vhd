LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY div_1hz IS
	PORT(
		clk, reset	: IN  STD_LOGIC;
		ad_wr : buffer std_logic);
END div_1hz;

ARCHITECTURE a OF div_1hz IS
BEGIN
	PROCESS (clk, reset)
		VARIABLE count : INTEGER RANGE 0 to 24999999;
	BEGIN
		IF (reset = '0') THEN
			count	:= 0;
			ad_wr <= '0';
		ELSE
			IF (clk'EVENT and clk = '1') THEN
				IF (count = 24999999) THEN
					count := 0;
					ad_wr <= not ad_wr;
				ELSE
					count := count + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END a;

