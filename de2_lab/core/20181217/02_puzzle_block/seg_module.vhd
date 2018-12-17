library ieee;
use ieee.std_logic_1164.all;

entity seg_module is
port (
	clk : in std_logic;  -- 10khz Ŭ��
-- 7segment ������ �Է�
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

-- 7segment ���
	seg_out : out std_logic_vector (7 downto 0);
-- 7segment ���÷��� ��ġ ���� ���
	common : out std_logic_vector (15 downto 0)
);
end seg_module;

architecture a of seg_module is

component hex2seg
port (
	hex : in std_logic_vector (3 downto 0);
	segment : out std_logic_vector (7 downto 0)
);
end component;
-- 16���� 7segment�� ����ϹǷ� 0 ~ 15���� ī��Ʈ �ϱ� ���� ���.
signal cnt : integer range 15 downto 0;
signal hexa : std_logic_vector (3 downto 0);
begin

u0 : hex2seg
port map ( hexa, seg_out);

process( clk )
begin
	if clk'event and clk = '1' then
		cnt <= cnt + 1;
		case cnt is
-- common�� '1'�� ��� 7segment�� ���÷��� �ϰ� '0'�� ���
-- ���÷��̸� ���� �ʰ� �ȴ�.
			when 15 =>
				common <= "0111111111111111";
				hexa <= dig_15;
			when 14 =>
				common <= "1011111111111111";
				hexa <= dig_14;
			when 13 =>
				common <= "1101111111111111";
				hexa <= dig_13;
			when 12 =>
				common <= "1110111111111111";
				hexa <= dig_12;
			when 11 =>
				common <= "1111011111111111";
				hexa <= dig_11;
			when 10 =>
				common <= "1111101111111111";
				hexa <= dig_10;
			when 09 =>
				common <= "1111110111111111";
				hexa <= dig_09;
			when 08 =>
				common <= "1111111011111111";
				hexa <= dig_08;
			when 07 =>
				common <= "1111111101111111";
				hexa <= dig_07;
			when 06 =>
				common <= "1111111110111111";
				hexa <= dig_06;
			when 05 =>
				common <= "1111111111011111";
				hexa <= dig_05;
			when 04 =>
				common <= "1111111111101111";
				hexa <= dig_04;
			when 03 =>
				common <= "1111111111110111";
				hexa <= dig_03;
			when 02 =>
				common <= "1111111111111011";
				hexa <= dig_02;
			when 01 =>
				common <= "1111111111111101";
				hexa <= dig_01;
			when 00 =>
				common <= "1111111111111110";
				hexa <= dig_00;
			when others =>
				null;
		end case;
	end if;
end process;
end a;
