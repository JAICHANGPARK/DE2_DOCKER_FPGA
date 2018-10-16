library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;
entity lab_traffic_light_vhdl is
	port
	(
		-- Input ports
		clock1hz			: in 	STD_LOGIC;
		reset				: in 	STD_LOGIC;
		-- Output ports
		tLightsRed1		: out STD_LOGIC;
		tLightsYellow1	: out STD_LOGIC;
		tLightsGreen1	: out STD_LOGIC;
		tLightsRed2		: out STD_LOGIC;
		tLightsYellow2	: out STD_LOGIC;
		tLightsGreen2	: out STD_LOGIC
	);
end lab_traffic_light_vhdl;

architecture controller of lab_traffic_light_vhdl is
	signal count : integer;
begin
	process(clock1hz, reset)
	begin
		if(reset = '1') then
			count <= 0;			
		elsif rising_edge(clock1hz) then
			
			count <= count +1;
			
			if (count = 1) then -- light 1 green
				tLightsGreen1 	<= '1';
				tLightsYellow1 <= '0';
				tLightsRed1 	<= '0';
				tLightsGreen2 	<= '0';
				tLightsYellow2 <= '0';
				tLightsRed2 	<= '1';
			elsif	(count = 30) then
				tLightsGreen1 	<= '0';
				tLightsYellow1 <= '1';
				tLightsRed1 	<= '0';
				tLightsGreen2 	<= '0';
				tLightsYellow2 <= '0';
				tLightsRed2 	<= '1';
			elsif (count = 31) then -- light 2 green
				tLightsGreen1 	<= '0';
				tLightsYellow1 <= '0';
				tLightsRed1 	<= '1';
				tLightsGreen2 	<= '1';
				tLightsYellow2 <= '0';
				tLightsRed2 	<= '0';	
			elsif (count = 60) then
				tLightsGreen1 	<= '0';
				tLightsYellow1 <= '0';
				tLightsRed1 	<= '1';
				tLightsGreen2 	<= '0';
				tLightsYellow2 <= '1';
				tLightsRed2 	<= '0';			
				
				count <= 0;	-- reset counter
			end if;		
		end if;
	end process;
		
end controller;