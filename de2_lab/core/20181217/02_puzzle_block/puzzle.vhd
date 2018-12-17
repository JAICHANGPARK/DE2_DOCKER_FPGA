library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity puzzle is
port(
	clk	: in std_logic;  -- 100hz Ŭ��
	bt_start : in std_logic;  -- ������ �����ϰų� ���ӵ��� �ٽ� �����ϵ��� �ϴ� ��ư
	bt_up : in std_logic;  -- ������ ���� �̵���Ű�� ��ư
	bt_down : in std_logic;  -- ������ �Ʒ��� �̵���Ű�� ��ư
	bt_left : in std_logic; -- ������ �������� �̵���Ű�� ��ư
	bt_right : in std_logic;  -- ������ ���������� �̵���Ű�� ��ư

	rom_data : in std_logic_vector (3 downto 0);  -- �ܺ� ������ ���� �д� ���� ������
	rom_address : out std_logic_vector (11 downto 0);  -- �ܺ� �ҿ� ���� ��巹��
	rom_cs : out std_logic;  -- �ܺ� ���� chip enable ��ȣ

-- �� 7segment�� ���� ������ ��, �� ������ ǥ�ô� "1111"�� ����Ѵ�.
	dig_00, dig_01, dig_02, dig_03 : out std_logic_vector (3 downto 0);
	dig_04, dig_05, dig_06, dig_07 : out std_logic_vector (3 downto 0);
	dig_08, dig_09, dig_10, dig_11 : out std_logic_vector (3 downto 0);
	dig_12, dig_13, dig_14, dig_15 : out std_logic_vector (3 downto 0)
);
end puzzle;

architecture a of puzzle is
-- �� 7segment�� ���� ó���ϱ� ���� ���� ����
signal	data_00	: std_logic_vector(3 downto 0);
signal	data_01 : std_logic_vector(3 downto 0);
signal	data_02 : std_logic_vector(3 downto 0);
signal	data_03	: std_logic_vector(3 downto 0);
signal	data_04	: std_logic_vector(3 downto 0);
signal	data_05 : std_logic_vector(3 downto 0);
signal	data_06 : std_logic_vector(3 downto 0);
signal	data_07	: std_logic_vector(3 downto 0);
signal	data_08	: std_logic_vector(3 downto 0);
signal	data_09 : std_logic_vector(3 downto 0);
signal	data_10 : std_logic_vector(3 downto 0);	
signal	data_11	: std_logic_vector(3 downto 0);		
signal	data_12	: std_logic_vector(3 downto 0);	
signal	data_13 : std_logic_vector(3 downto 0);		
signal	data_14 : std_logic_vector(3 downto 0);		
signal	data_15	: std_logic_vector(3 downto 0);

-- puzzle�� ���� ���¸� ��Ÿ���� ���� state (idle : �ʱ���� �Ǵ� �������,
-- address_scan : �ҿ��� �����͸� �б� ���� address�� �����ϴ� ����,
-- load_data : address_scan state���� ������� address�� ������ ������ ���� ������ �ε�,
-- play : ���� ���� ����
type status is (idle, address_scan, load_data, play);
signal puzzle_status : status;

-- ������ ��� ���ڰ� ���߾� �� ��� '1'�� ���� ������.
signal play_done : std_logic;

-- �ҿ� ����� 256������ ������ ��巹��
signal rom_address_msb : integer range 255 downto 0;
-- 256������ �����Ϳ� ���� ������ ���� ��巹��
signal rom_address_lsb : integer range 15 downto 0;

-- ��ư ���� ������ ���� ����, ���� "01"�� ��� �������� ����
signal start, up, down, left, right : std_logic_vector (1 downto 0);

-- ������ ��ġ�� ���� ����
signal position : integer range 15 downto 0;

-- 256������ �����Ϳ� ���� ������ ���� ��巹��
signal address : integer range 15 downto 0;

-- ��ư�� ������ �����ϱ� ���� �������� �����ϴ� ����
-- ���� ��� start�� ���� "01"�ΰ�� Ű�� �������� �ǹ��ϰ�
-- "10"�� ��� ������ ���¿��� ������ ���·� �ٲ��� �ǹ��Ѵ�.
begin
process (clk)
begin
	if clk'event and clk = '1' then
		start(0) <= bt_start;
		start(1) <= start(0);
		up(0) <= bt_up;
		up(1) <= up(0);
		down(0) <= bt_down;
		down(1) <= down(0);
		left(0) <= bt_left;
		left(1) <= left(0);
		right(0) <= bt_right;
		right(1) <= right(0);
	end if;
end process;

-- ������ ���� ���¸� �����ϱ� ���� ����
process (clk)
begin
	if clk'event and clk = '1' then
		case puzzle_status is
			when idle =>
-- start ��ư�� ��������
				if start = "01" then
					puzzle_status <= address_scan;
				end if;
			when address_scan =>
-- start ��ư�� ��������
				if start = "10" then
					puzzle_status <= load_data;
				end if;
			when load_data =>
-- address�� 15�� �Ǹ�(rom���� ���� data load�� �Ϸ�Ǹ�)
				if address = 15 then
					puzzle_status <= play;
				end if;
			when play =>
-- play ���� start�� �������� ���� ����
				if start = "01" then
					puzzle_status <= idle;
-- ��� ���ڰ� ���߾� ���� ���� ����
				elsif play_done = '1' then
					puzzle_status <= idle;
end if;
			when others =>
				puzzle_status <= idle;
		end case;
	end if;
end process;

-- ������ ���� �����Ͱ� �о����� load_data ���¿���
rom_cs <= '0' when puzzle_status = load_data else '1'; 

-- address_scan state�� startŰ�� �������� ���� ���°� �����Ǵµ� �̶� address�� ���� �ݺ����� ī��Ʈ �ϰ� state�� load_data�� ��ȯ�ɶ� ī��Ʈ�� address�� �Ѱ��ְ� �ȴ�. �̷��� �Ͽ� �غ�� 256����
-- �������߿��� ������ �����Ͱ� ���õǵ��� �Ѵ�.
process (clk)
begin
	if clk'event and clk = '1' then
		if puzzle_status = address_scan then
			if rom_address_msb = 255 then
				rom_address_msb <= 0;
			else
				rom_address_msb <= rom_address_msb + 1;
			end if;
		elsif puzzle_status = load_data then
			rom_address(11 downto 4) <= conv_std_logic_vector(rom_address_msb, 8);
		end if;
	end if;
end process;

-- ������ ���õ� ���� �����͸� �б����� ���� ��巹���� �����ϱ� ���� ����
process (clk)
begin
	if clk'event and clk = '1' then
		if puzzle_status = load_data then
			rom_address_lsb <= rom_address_lsb + 1;
		else
			rom_address_lsb <= 0;			
		end if;
		address <= rom_address_lsb;
	end if;
-- conv_std_logic_vector�� integer�� ���¸� std_logic_vector�� ��ȯ�ϱ� ���� function
	rom_address(3 downto 0) <= conv_std_logic_vector(rom_address_lsb,4);
	
end process;

process (clk)
begin
	if clk'event and clk = '1' then
-- ������ ���� �о��� �����Ϳ��� ����("1111")��ġ�� ã�´�.
		if puzzle_status = load_data then
				if rom_data = "1111" then
					position <= address;
				end if;
		elsif puzzle_status = play then
-- ����Ű�� �������� ���� ������ ��ġ�� �����Ѵ�.
			if up = "01" then
-- ������ ��ġ�� ���� ���� �ٿ� ��ġ�� ��� ���̻� ������ �̵��� �Ұ� �ϹǷ�
-- ��ġ �̵��� ������ �̿��� ���ǿ����� ������ġ���� 4�� ���� ���� ��ġ�� �����Ѵ�.
				if position >= 4 then
					position <= position - 4;
				end if;
			elsif down = "01" then
-- ������ ��ġ�� ���� �Ʒ��� �ٿ� ��ġ�� ��� ���̻� �Ʒ����� �̵��� �Ұ� �ϹǷ�
-- ��ġ �̵��� ������ �̿��� ���ǿ����� ������ġ���� 4�� ���ؼ� ���� ��ġ�� �����Ѵ�.
				if position <= 11 then
					position <= position + 4;
				end if;
			elsif left = "01" then
-- ������ ��ġ�� ���� ������ �ٿ� ��ġ�� ��� ���̻� ���������� �̵��� �Ұ� �ϹǷ�
-- ��ġ �̵��� ������ �̿��� ���ǿ����� ������ġ���� 1�� ���� ���� ��ġ�� �����Ѵ�.
				if position /= 0 and position /= 4 and position /= 8 and position /= 12 then
					position <= position - 1;
				end if;
			elsif right = "01" then
-- ������ ��ġ�� ���� �������� �ٿ� ��ġ�� ��� ���̻� ������������ �̵��� �Ұ� �ϹǷ�
-- ��ġ �̵��� ������ �̿��� ���ǿ����� ������ġ���� 1�� ���ؼ� ���� ��ġ�� �����Ѵ�.
				if position /= 3 and position /= 7 and position /= 11 and position /= 15 then
					position <= position + 1;
				end if;
			end if;
		end if;
	end if;
end process;

process (clk)
begin
	if clk'event and clk = '1' then
-- ������ ���� ���� �����͸� �о���� ����
		if puzzle_status = load_data then
			case address is
				when 00 => data_00 <= rom_data;
				when 01 => data_01 <= rom_data;
				when 02 => data_02 <= rom_data;
				when 03 => data_03 <= rom_data;
				when 04 => data_04 <= rom_data;
				when 05 => data_05 <= rom_data;
				when 06 => data_06 <= rom_data;
				when 07 => data_07 <= rom_data;
				when 08 => data_08 <= rom_data;
				when 09 => data_09 <= rom_data;
				when 10 => data_10 <= rom_data;
				when 11 => data_11 <= rom_data;
				when 12 => data_12 <= rom_data;
				when 13 => data_13 <= rom_data;
				when 14 => data_14 <= rom_data;
				when 15 => data_15 <= rom_data;
				when others => null;
			end case;
-- �� Ű�� �������� ���� ������ ��ġ�� �����Ͽ� ���� �������� ���� �����Ѵ�.
		elsif puzzle_status = play then
-- ���� ������ ��ġ�� �ι�° ���� ù��°�� ��ġ�� ������ up ��ư�� ������ ��쳪
-- ������ ��ġ�� ù��° ���� ù��°�� ��ġ�� ���¿��� down ��ư�� ������ ���
-- ù°���� ù��° ���� �ι�° ���� ù��°�� ���� ��ȯ�Ѵ�.
			if (up = "01" and position = 04) or (down = "01" and position = 00) then
				data_00 <= data_04;
				data_04 <= data_00;
elsif (left = "01" and position = 01) or (right = "01" and position = 00) then
				data_00 <= data_01;
				data_01 <= data_00;
			end if;
			
			if (up = "01" and position = 05) or (down = "01" and position = 01) then
				data_01 <= data_05;
				data_05 <= data_01;
			elsif (left = "01" and position = 02) or (right = "01" and position = 01) then
				data_01 <= data_02;
				data_02 <= data_01;
			end if;
			
			if (up = "01" and position = 06) or (down = "01" and position = 02) then
				data_02 <= data_06;
				data_06 <= data_02;
			elsif (left = "01" and position = 03) or (right = "01" and position = 02) then
				data_02 <= data_03;
				data_03 <= data_02;
			end if;

			if (up = "01" and position = 07) or (down = "01" and position = 03) then
				data_03 <= data_07;
				data_07 <= data_03;
			end if;

			if (up = "01" and position = 08) or (down = "01" and position = 04) then
				data_04 <= data_08;
				data_08 <= data_04;
			elsif (left = "01" and position = 05) or (right = "01" and position = 04) then
				data_04 <= data_05;
				data_05 <= data_04;
			end if;

			if (up = "01" and position = 09) or (down = "01" and position = 05) then
				data_05 <= data_09;
				data_09 <= data_05;
			elsif (left = "01" and position = 06) or (right = "01" and position = 05) then
				data_05 <= data_06;
				data_06 <= data_05;
			end if;
			
			if (up = "01" and position = 10) or (down = "01" and position = 06) then
				data_06 <= data_10;
				data_10 <= data_06;
			elsif (left = "01" and position = 07) or (right = "01" and position = 06) then
				data_06 <= data_07;
				data_07 <= data_06;
			end if;
			
			if (up = "01" and position = 11) or (down = "01" and position = 07) then
				data_07 <= data_11;
				data_11 <= data_07;
			end if;
			
			if (up = "01" and position = 12) or (down = "01" and position = 08) then
				data_08 <= data_12;
				data_12 <= data_08;
			elsif (left = "01" and position = 09) or (right = "01" and position = 08) then
				data_08 <= data_09;
				data_09 <= data_08;
			end if;
			
			if (up = "01" and position = 13) or (down = "01" and position = 09) then
				data_09 <= data_13;
				data_13 <= data_09;
			elsif (left = "01" and position = 10) or (right = "01" and position = 09) then
				data_09 <= data_10;
				data_10 <= data_09;
			end if;
			
			if (up = "01" and position = 14) or (down = "01" and position = 10) then
				data_10 <= data_14;
				data_14 <= data_10;
			elsif (left = "01" and position = 11) or (right = "01" and position = 10) then
				data_10 <= data_11;
				data_11 <= data_10;
			end if;

			if (up = "01" and position = 15) or (down = "01" and position = 11) then
				data_11 <= data_15;
				data_15 <= data_11;
			end if;

			if (left = "01" and position = 13) or (right = "01" and position = 12) then
				data_12 <= data_13;
				data_13 <= data_12;
			end if;

			if (left = "01" and position = 14) or (right = "01" and position = 13) then
				data_13 <= data_14;
				data_14 <= data_13;
			end if;

			if (left = "01" and position = 15) or (right = "01" and position = 14) then
				data_14 <= data_15;
				data_15 <= data_14;
			end if;
		end if;
	end if;
end process;					

process (clk)
begin
-- ���ڵ��� ��Ȯ�� �ڸ��� ��ġ�� ���� üũ�ϱ� ���� ����
	if clk'event and clk = '1' then
		if data_00 = "0000" and data_01 = "0001" and data_02 = "0010" and 
		data_03 = "0011" and data_04 = "0100" and data_05 = "0101" and 
		data_06 = "0110" and data_07 = "0111" and data_08 = "1000" and 
		data_09 = "1001" and data_10 = "1010" and data_11 = "1011" and 
		data_12 = "1100" and data_13 = "1101" and data_14 = "1110" and 
		data_15 = "1111"  then
			play_done <= '1';
		else
			play_done <= '0';
		end if;
	end if;
end process;

dig_00 <= data_00;
dig_01 <= data_01;
dig_02 <= data_02;
dig_03 <= data_03;
dig_04 <= data_04;
dig_05 <= data_05;
dig_06 <= data_06;
dig_07 <= data_07;
dig_08 <= data_08;
dig_09 <= data_09;
dig_10 <= data_10;
dig_11 <= data_11;
dig_12 <= data_12;
dig_13 <= data_13;
dig_14 <= data_14;
dig_15 <= data_15;
end a;
