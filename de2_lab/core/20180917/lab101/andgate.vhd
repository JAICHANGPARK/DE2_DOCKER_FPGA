library ieee;
use ieee.std_logic_1164.all;

entity andgate is
port(
sw1 : in std_logic;
sw2 : in std_logic;
led : out std_logic);
end andgate;

architecture sample of andgate is
begin 
led <= sw1 and sw2;
end sample;

