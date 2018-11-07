LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY div_10k_2_2hz IS
	PORT(
		clk, reset	: IN  STD_LOGIC;
		ad_wr : buffer std_logic);
END div_10k_2_2hz;

ARCHITECTURE a OF div_10k_2_2hz IS
SIGNAL count : STD_LOGIC_VECTOR(2499 downto 0);
BEGIN
	PROCESS (clk, reset)
		VARIABLE count : INTEGER RANGE 0 to 2499;
	BEGIN
		IF (reset = '0') THEN
			count	:= 0;
			ad_wr <= '0';
		ELSE
			IF (clk'EVENT and clk = '1') THEN
				IF (count = 2499) THEN
					count := 0;
					ad_wr <= not ad_wr;
				ELSE
					count := count + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END a;

