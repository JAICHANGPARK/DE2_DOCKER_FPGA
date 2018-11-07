LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY traffic_walk_r IS
	PORT(
		clk, reset, ns_walk_sw, ew_walk_sw 			: IN  STD_LOGIC;
		nsr, nsy, nsg, ewr, ewy, ewg 				: OUT STD_LOGIC;
		ns_walk_lt, ns_reset, ew_walk_lt, ew_reset	: OUT STD_LOGIC);
END traffic_walk_r;

ARCHITECTURE a OF traffic_walk_r IS
	COMPONENT ct_mod5
		PORT(
			clk, reset		: IN	STD_LOGIC;
			q				: OUT	INTEGER RANGE 0 TO 5);
	END COMPONENT;
	TYPE STATES IS (s0, s1, s2, s3, s4, s5);
	SIGNAL sequence : STATES;
	SIGNAL outputs : STD_LOGIC_VECTOR (1 to 10);
	SIGNAL timer : INTEGER RANGE 0 to 5;
BEGIN
output_timer: ct_mod5 
	PORT MAP (	clk 	=>	clk,
				reset	=>	reset,
				q 		=>	timer);
	PROCESS (clk)
	BEGIN
		IF (reset = '0') THEN
			sequence <= s0;
			outputs <= "0111101111";
		ELSIF (clk'EVENT and clk = '1') THEN
			CASE sequence IS
				WHEN s0	=>	IF timer < 4 THEN
								sequence <= s0;
								outputs <= "0111101111";
							ELSE
								sequence <= s1;
								outputs <= "0111011111";
							END IF;
				WHEN s1	=>	IF ns_walk_sw = '0' THEN
								sequence <= s2;
								outputs <= "1100111111";
							ELSE
								sequence <= s5;
								outputs <= "1100110111";
							END IF;
				WHEN s2	=>	IF timer < 4 THEN
								sequence <= s2;
								outputs <= "1100111111";
							ELSE
								sequence <= s3;
								outputs <= "1010111111";
							END IF;
				WHEN s3	=>	IF ew_walk_sw = '0' THEN
								sequence <= s0;
								outputs <= "0111101111";
							ELSE
								sequence <= s4;
								outputs <= "0111101101";
							END IF;
				WHEN s4	=>	IF timer < 4 THEN
								sequence <= s4;
								outputs <= "0111101101";
							ELSE
								sequence <= s1;
								outputs <= "0111011110";
							END IF;
				WHEN s5	=>	IF timer < 4 THEN
								sequence <= s5;
								outputs <= "1100110111";
							ELSE
								sequence <= s3;
								outputs <= "1010111011";
							END IF;
				WHEN others =>	sequence <= s0;
								outputs <= "0111101111";
			END CASE;
		END IF;
		nsr			<=	not outputs(1);
		nsy			<=	not outputs(2);
		nsg			<=	not outputs(3);
		ewr			<=	not outputs(4);
		ewy			<=	not outputs(5);
		ewg			<=	not outputs(6);
		ns_walk_lt	<=	not outputs(7);
		ns_reset	<=	outputs(8);
		ew_walk_lt	<=	not outputs(9);
		ew_reset	<=	outputs(10);
	END PROCESS;
END a;

