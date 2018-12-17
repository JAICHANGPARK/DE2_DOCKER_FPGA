library ieee;
use ieee.std_logic_1164.all;

entity seg_puzzle is
port (
	clk	: in std_logic; -- 10KHz 클럭
	bt_start : in std_logic; -- 게임 시작및 종료 버튼

-- 방향 버튼
	bt_up : in std_logic;  
	bt_down : in std_logic;  
	bt_left : in std_logic; 
	bt_right : in std_logic;  

-- 외부 롬에 대한 데이터 입력
	rom_data : in std_logic_vector (3 downto 0);
-- 외부 롬에 대한 어드레스 출력
	rom_address : out std_logic_vector (9 downto 0);
-- 외부 롬에 대한 chip select 출력
	rom_cs : out std_logic;

-- 7segment 데이터
	seg_out : out std_logic_vector (7 downto 0);
-- 7segment 선택 출력
	common : out std_logic_vector (15 downto 0)
);
end seg_puzzle;

architecture a of seg_puzzle is

component puzzle
port(
	clk	: in std_logic;
	bt_start : in std_logic;  
	bt_up : in std_logic; 
	bt_down : in std_logic;  
	bt_left : in std_logic; 
	bt_right : in std_logic;  

	rom_data : in std_logic_vector (3 downto 0);
	rom_address : out std_logic_vector (9 downto 0);
	rom_cs : out std_logic;

	dig_00, dig_01, dig_02, dig_03 : out std_logic_vector (3 downto 0);
	dig_04, dig_05, dig_06, dig_07 : out std_logic_vector (3 downto 0);
	dig_08, dig_09, dig_10, dig_11 : out std_logic_vector (3 downto 0);
	dig_12, dig_13, dig_14, dig_15 : out std_logic_vector (3 downto 0)
);
end component;

component seg_module
port (
	clk : in std_logic;
	dig_00 : in std_logic_vector (3 downto 0);
	dig_01 : in std_logic_vector (3 downto 0);
	dig_02 : in std_logic_vector (3 downto 0);
	dig_03 : in std_logic_vector (3 downto 0);
	dig_04 : in std_logic_vector (3 downto 0);
	dig_05 : in std_logic_vector (3 downto 0);
	dig_06 : in std_logic_vector (3 downto 0);
	dig_07 : in std_logic_vector (3 downto 0);
	dig_08 : in std_logic_vector (3 downto 0);
	dig_09 : in std_logic_vector (3 downto 0);
	dig_10 : in std_logic_vector (3 downto 0);
	dig_11 : in std_logic_vector (3 downto 0);
	dig_12 : in std_logic_vector (3 downto 0);
	dig_13 : in std_logic_vector (3 downto 0);
	dig_14 : in std_logic_vector (3 downto 0);
	dig_15 : in std_logic_vector (3 downto 0);
	
	seg_out : out std_logic_vector (7 downto 0);
	common : out std_logic_vector (15 downto 0)
);
end component;

signal	dig_00, dig_01, dig_02, dig_03 : std_logic_vector (3 downto 0);
signal	dig_04, dig_05, dig_06, dig_07 : std_logic_vector (3 downto 0);
signal	dig_08, dig_09, dig_10, dig_11 : std_logic_vector (3 downto 0);
signal	dig_12, dig_13, dig_14, dig_15 : std_logic_vector (3 downto 0);

begin

u0 : puzzle
port map( clk, bt_start, bt_up, bt_down, bt_left, bt_right,
			rom_data, rom_address, rom_cs,
			dig_00, dig_01, dig_02, dig_03,
			dig_04, dig_05, dig_06, dig_07,
			dig_08, dig_09, dig_10, dig_11,
			dig_12, dig_13, dig_14, dig_15
);

u1 : seg_module
port map(
	clk, 
	dig_00, dig_01, dig_02, dig_03,
	dig_04, dig_05, dig_06, dig_07,
	dig_08, dig_09, dig_10, dig_11,
	dig_12, dig_13, dig_14, dig_15,
	
	seg_out,
	common
);

end a;
