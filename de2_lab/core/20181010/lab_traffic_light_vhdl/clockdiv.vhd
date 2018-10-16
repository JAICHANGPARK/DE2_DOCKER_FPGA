library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- clockdivider ... divides x-hz clock into 1hz clock
entity clockdiv is
	port 
	( 
		-- Input ports
		clock50mhz : in  STD_LOGIC;
		clockReset : in  STD_LOGIC;
		
		-- Output ports
		clockOut : out  STD_LOGIC
	);
end clockdiv;
architecture controller of clockdiv is
	signal count : integer;
	signal clock1hz : STD_LOGIC;
begin
	divide: process(clock50mhz,clockReset)
	begin
		if(clockReset = '1') then
			count <= 0;
			clock1hz <= '0';
		elsif rising_edge(clock50mhz) then
			if (count >= 25000000) then
				clock1hz <=not clock1hz;
				count <= 0;
			else
				count<=count+1;
			end if;
		end if;
	end process;
	clockOut <= clock1hz;
end controller;