-- hex�� 7segment�� ����ϱ� ���� ������ ���ڵ��ϱ� ���� ����
library ieee;
use ieee.std_logic_1164.all;

entity hex2seg is
port (
	hex : in std_logic_vector (3 downto 0); -- ���ڸ��� 16���� �Է�
	segment : out std_logic_vector (7 downto 0)  -- 7segment�� ��ȯ�� ��
);
end hex2seg;

architecture a of hex2seg is
begin
-- ������ ���� ���� 7bit�� ���� ����� ����.
   --     a
--    -- --
--   f|      | b
--    |  g  |
       -- --
--  e|      | c
--   |  d  |
--    -- --
process (hex)
begin
	if hex = "0000" then
		segment <= "00111111";
	elsif hex = "0001" then
	    segment <= "00000110";
	elsif hex = "0010" then
		segment <= "01011011";
	elsif hex = "0011" then
		segment <= "01001111";
	elsif hex = "0100" then
		segment <= "01100110";
	elsif hex = "0101" then
		segment <= "01101101";
	elsif hex = "0110" then
		segment <= "01111101";
	elsif hex = "0111" then
		segment <= "00000111";
	elsif hex = "1000" then
		segment <= "01111111";
	elsif hex = "1001" then
		segment <= "01100111";
	elsif hex = "1010" then
		segment <= "01110111";
	elsif hex = "1011" then
	    segment <= "01111100";
	elsif hex = "1100" then
		segment <= "00111001";
	elsif hex = "1101" then
		segment <= "01011110";
	elsif hex = "1110" then
		segment <= "01111001";
-- "1111"�ΰ�� �������� ó��
	elsif hex = "1111" then
		segment <= "00000000";
	else
		segment <= "00000000";
	end if;
end process;
end a;
