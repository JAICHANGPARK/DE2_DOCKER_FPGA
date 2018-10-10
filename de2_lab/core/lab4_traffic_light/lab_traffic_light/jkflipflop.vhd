Library ieee;
USE ieee.std_logic_1164.ALL;

entity jkflipflop is
	port (j, k, clock : in std_logic;
		  Q, Qnot: inout std_logic);
end jkflipflop;

architecture sample of jkflipflop is

begin 
process(j,k,clock)
begin
	if(clock'event and clock='1') then
		if(j='1' and k='0') then
		q <= '1';
		elsif(j='0' and k='1') then
		q <= '0';
		elsif(j='1' and k='1') then
		q <= Qnot;
		end if;
	end if;
end process;
end sample;