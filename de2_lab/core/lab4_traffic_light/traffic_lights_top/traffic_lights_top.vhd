-- Example 62: traffic_lights_top
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity traffic_lights_top is
 port(
 clk : in STD_LOGIC;
 btn : in STD_LOGIC_VECTOR(3 downto 3);
 ld : out STD_LOGIC_VECTOR(7 downto 2)
 );
end traffic_lights_top;
architecture traffic_lights_top of traffic_lights_top is
component clkdiv is
 port(
 mclk : in STD_LOGIC;
 clr : in STD_LOGIC;
 clk190 : out STD_LOGIC;
 clk3 : out STD_LOGIC
 );
end component; 

component traffic is
 port (clk: in STD_LOGIC;
 clr: in STD_LOGIC;
 lights: out STD_LOGIC_VECTOR(5 downto 0));
end component;
signal clr, clk3: STD_LOGIC;
begin
 clr <= btn(3);
 U1: clkdiv
 port map (
 mclk=>clk,
 clr=>clr,
 clk3=>clk3
 );
 U2: traffic
 port map (
 clk=>clk3,
 clr=>clr,
 lights=>ld
 );
end traffic_lights_top;