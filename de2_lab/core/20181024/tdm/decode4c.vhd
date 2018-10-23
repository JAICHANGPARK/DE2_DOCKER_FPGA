-- decode4c.vhd
-- 4-channel decoder
-- Makes one and only one "X" output HIGH for each binary combination of (s1, s0).
-- Makes one and only one "Y" output LOW for each binary combination of (s1, s0).

-- Standard VHDL models
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Define inputs and outputs
ENTITY decode4c IS
	PORT(
		d1, d0							: IN	STD_LOGIC;	
		x0, x1, x2, x3, y0, y1, y2, y3	: OUT	STD_LOGIC);
END decode4c;

-- Define i/o relationship
ARCHITECTURE four_ch_decode OF decode4c IS
BEGIN
	--  Concurrent Signal Assignment
	x0	<=	(not d1) and (not d0);	-- input 00: output x0 HIGH
	x1	<=	(not d1) and (    d0);	-- input 01  output x1 HIGH
	x2	<=	(    d1) and (not d0);	-- input 10: output x2 HIGH
	x3	<=	(    d1) and (    d0);	-- input 11: output x3 HIGH

	y0	<=	not ((not d1) and (not d0));	-- input 00: output x0 HIGH
	y1	<=	not ((not d1) and (    d0));	-- input 01  output x1 HIGH
	y2	<=	not ((    d1) and (not d0));	-- input 10: output x2 HIGH
	y3	<=	not ((    d1) and (    d0));	-- input 11: output x3 HIGH
END four_ch_decode;

