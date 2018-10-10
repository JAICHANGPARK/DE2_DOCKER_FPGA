Library ieee;
USE ieee.std_logic_1164.ALL;

entity timer is
	port (enable, clock : in std_logic;
		  SetCount : in integer;
		  Qout : buffer std_logic);
end timer;

architecture sample of timer is 
begin
	process(enable, clock)
	variable Cnt: integer;
	begin 
		if(clock'event and clock ='1') then
			if enable='0' then 
				Cnt := 0;
				Qout <= '1';
			elsif Cnt = SetCount -1 then
				Qout <= '0';
			else
				Cnt := Cnt + 1;
			end if;
		end if;
	end process;
end sample;