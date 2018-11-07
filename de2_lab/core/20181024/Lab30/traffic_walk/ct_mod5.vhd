LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ct_mod5 IS
	PORT(
		clk, reset	: IN  STD_LOGIC;
		q			: OUT INTEGER RANGE 0 to 5);
END ct_mod5;

ARCHITECTURE a OF ct_mod5 IS
BEGIN
	PROCESS (clk, reset)
		VARIABLE count : INTEGER RANGE 0 to 5;
	BEGIN
		IF (reset = '0') THEN
			count	:= 0;
		ELSE
			IF (clk'EVENT and clk = '1') THEN
				IF (count = 4) THEN
					count := 0;
				ELSE
					count := count + 1;
				END IF;
			END IF;
		END IF;
		q <= count;
	END PROCESS;
END a;

