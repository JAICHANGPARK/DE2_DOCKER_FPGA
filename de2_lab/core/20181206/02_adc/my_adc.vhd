
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity my_adc is
port(
clk : in std_logic;
ad_in : in std_logic_vector(7 downto 0);
up, dn : in std_logic;
set : in std_logic;
led_set : out std_logic;
led_fan : out std_logic;
fan_run : out std_logic;
wr : buffer std_logic;
eoc, rd, decr : out std_logic;
o_clk : out std_logic;
sel_seg : out std_logic_vector(7 downto 0);
dis_seg : out std_logic_vector(7 downto 0)
);
end my_adc;

architecture hb of my_adc is
function dis(input : std_logic_vector(3 downto 0)) return std_logic_vector is
variable seg_decode : std_logic_vector(0 to 6);
begin
case input is
when "0000" => seg_decode := "0000001";
when "0001" => seg_decode := "1111110";
when "0010" => seg_decode := "0110000";
when "0011" => seg_decode := "1101101";
when "0100" => seg_decode := "1111001";
when "0101" => seg_decode := "0110011";
when "0110" => seg_decode := "1011011";
when "0111" => seg_decode := "1011111";
when "1000" => seg_decode := "1110000";
when "1001" => seg_decode := "1111111";
when "1010" => seg_decode := "1111011";
when "1111" => seg_decode := "0000000";
when others => seg_decode := "1111110";
end case;
return (seg_decode);
end dis;

component lpm_rom
generic (
lpm_width : positive;
lpm_widthad : positive;
lpm_address_control : string;
lpm_indata : string;
lpm_outdata : string;
lpm_file : string
);
port (
address : in std_logic_vector (7 downto 0);
q : out std_logic_vector (15 downto 0)
);
end component;

signal seg, sega : std_logic_vector(15 downto 0);
signal k_clk : std_logic;
signal tmp : std_logic_vector(7 downto 0);
signal con_int : std_logic_vector(7 downto 0);
signal con_vec : std_logic_vector(15 downto 0);
signal tg_set : std_logic;
begin
eoc <= '1';
rd <= '0';
decr <= '0';
o_clk <= clk;

lpm_rom_component1 : lpm_rom
generic map (
lpm_width => 16,
lpm_widthad => 8,
lpm_address_control => "UNREGISTERED",
lpm_indata => "UNREGISTERED",
lpm_outdata => "UNREGISTERED",
lpm_file => "C:\Users\5E405-01\Documents\2018_12_06\con_data.mif"
)
port map (con_int, con_vec);

process(clk)
variable cnt : integer range 0 to 4999;
begin
if clk'event and clk='1' then
cnt := cnt + 1;
if cnt = 4999 then
wr <= not wr;
end if;
end if;
end process;

process(clk)
variable cnt : integer range 0 to 1;
begin
if clk'event and clk='1' then
cnt := cnt + 1;
case cnt is
when 0 =>
con_int <= ad_in;
sega <= con_vec;
when 1 =>
con_int <= tmp;
seg <= con_vec;
when others =>
end case;
end if;
end process;

process(clk) -- 7-segment driver
variable cnt : integer range 0 to 7;
begin
if clk='1' and clk'event then
cnt := cnt + 1;
case cnt is
when 0 =>
sel_seg <= "01111111";
dis_seg <= dis(seg(15 downto 12)) & '0';
when 1 =>
sel_seg <= "10111111";
dis_seg <= dis(seg(11 downto 8)) & '0';
when 2 =>
sel_seg <= "11011111";
dis_seg <= dis(seg(7 downto 4)) & '1';
when 3 =>
sel_seg <= "11101111";
dis_seg <= dis(seg(3 downto 0)) & '0';
when 4 =>
sel_seg <= "11110111";
dis_seg <= dis(sega(15 downto 12)) & '0';
when 5 =>
sel_seg <= "11111011";
dis_seg <= dis(sega(11 downto 8)) & '0';
when 6 =>
sel_seg <= "11111101";
dis_seg <= dis(sega(7 downto 4)) & '1';
when 7 =>
sel_seg <= "11111110";
dis_seg <= dis(sega(3 downto 0)) & '0';
when others =>
sel_seg <= "11111111";
end case;
end if;
end process;
process(set) -- set toggle block
begin
if set='1' and set'event then
tg_set <= not tg_set;
end if;
led_set <= tg_set;
end process;

process(clk) -- set number up/down count.
variable start : std_logic;
variable cnt: integer range 0 to 249999;
begin
if clk='1' and clk'event then
k_clk <= up or dn;
if k_clk = '1' then
cnt := cnt + 1;
else
cnt := 0;
end if;
if cnt = 249999 or k_clk = '0' then
if start='0' then
tmp <= "01101000";
start := '1';
elsif start='1' then
if tg_set = '1' then
if up = '1' then
tmp <= tmp - 1;
elsif dn = '1' then
tmp <= tmp + 1;
end if;
end if;
end if;
end if;
end if;
end process;

process(clk)-- comparator block
begin
if clk='1' and clk'event then
if ad_in <= tmp then
led_fan <= '1';
fan_run <= '1';
else
led_fan <= '0';
fan_run <= '0';
end if;
end if;
end process;
end hb;