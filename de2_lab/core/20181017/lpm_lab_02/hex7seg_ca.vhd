-- hex7seg_ca.vhd
-- hexadecimal-to-seven-segment decoder
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hex7seg_ca IS
	PORT(
		d : IN STD_LOGIC_VECTOR(3 downto 0);
		ao, bo, co, do, eo, fo, go	: OUT	STD_LOGIC);
END hex7seg_ca;

ARCHITECTURE seven_segment OF hex7seg_ca IS
	SIGNAL input : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL output: STD_LOGIC_VECTOR (6 downto 0);
BEGIN
	WITH d SELECT
		output <=	"0000001" WHEN "0000", -- display 0
					"1001111" WHEN "0001", -- display 1
					"0010010" WHEN "0010", -- display 2
					"0000110" WHEN "0011", -- display 3
					"1001100" WHEN "0100", -- display 4
					"0100100" WHEN "0101", -- display 5
					"0100000" WHEN "0110", -- display 6 (with tail)
					"0001111" WHEN "0111", -- display 7
					"0000000" WHEN "1000", -- display 8
					"0000100" WHEN "1001", -- display 9 (with tail)
					"0001000" WHEN "1010", -- display A
					"1100000" WHEN "1011", -- display b
					"0110001" WHEN "1100", -- display C
					"1000010" WHEN "1101", -- display d
					"0110000" WHEN "1110", -- display E
					"0111000" WHEN "1111", -- display F
					"1111111" WHEN others;

		-- Separate the output vector to make individual pin outputs.
		ao	<=	output(6);
		bo	<=	output(5);
		co	<=	output(4);
		do	<=	output(3);
		eo	<=	output(2);
		fo	<=	output(1);
		go	<=	output(0);

END seven_segment;

