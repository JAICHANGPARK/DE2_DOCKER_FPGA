LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY traffic_r IS
	PORT(
		clk, reset					 : IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg : OUT STD_LOGIC);
END traffic_r;

ARCHITECTURE a OF traffic_r IS
	COMPONENT ct_mod5
		PORT(
			clk, reset		: IN	STD_LOGIC;
			q				: OUT	INTEGER RANGE 0 TO 5);
	END COMPONENT;
	TYPE STATES IS (s0, s1, s2, s3);
	SIGNAL sequence : STATES;
	SIGNAL lights : STD_LOGIC_VECTOR (5 downto 0);
	SIGNAL timer : INTEGER RANGE 0 to 5;
BEGIN
light_timer: ct_mod5 
	PORT MAP (	clk 	=>	clk,
				reset	=>	reset,
				q 		=>	timer);
	PROCESS (clk)
	BEGIN
		IF (reset = '0') THEN
			sequence <= s0;
			lights <= "011110";
		ELSIF (clk'EVENT and clk = '1') THEN
			CASE sequence IS
				WHEN s0	=>	IF timer < 4 THEN
								sequence <= s0;
								lights <= "011110";
							ELSE
								sequence <= s1;
								lights <= "011101";
							END IF;
				WHEN s1	=>	sequence <= s2;
							lights <= "110011";
				WHEN s2	=>	IF timer < 4 THEN
								sequence <= s2;
								lights <= "110011";
							ELSE
								sequence <= s3;
								lights <= "101011";
							END IF;
				WHEN s3	=>	sequence <= s0;
							lights <= "011110";
				WHEN others =>	sequence <= s0;
								lights <= "011110";
			END CASE;
		END IF;
		nsr	<=	not lights(5);
		nsy	<=	not lights(4);
		nsg	<=	not lights(3);
		ewr	<=	not lights(2);
		ewy	<=	not lights(1);
		ewg	<=	not lights(0);
	END PROCESS;
END a;

