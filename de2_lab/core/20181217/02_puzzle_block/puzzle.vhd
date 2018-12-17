library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity puzzle is
port(
	clk	: in std_logic;  -- 100hz 클럭
	bt_start : in std_logic;  -- 퍼즐을 시작하거나 게임도중 다시 시작하도록 하는 버튼
	bt_up : in std_logic;  -- 공백을 위로 이동시키는 버튼
	bt_down : in std_logic;  -- 공백을 아래로 이동시키는 버튼
	bt_left : in std_logic; -- 공백을 왼쪽으로 이동시키는 버튼
	bt_right : in std_logic;  -- 공백을 오른쪽으로 이동시키는 버튼

	rom_data : in std_logic_vector (3 downto 0);  -- 외부 롬으로 부터 읽는 숫자 데이터
	rom_address : out std_logic_vector (11 downto 0);  -- 외부 롬에 대한 어드레스
	rom_cs : out std_logic;  -- 외부 롬의 chip enable 신호

-- 각 7segment에 대한 데이터 값, 단 공백의 표시는 "1111"을 사용한다.
	dig_00, dig_01, dig_02, dig_03 : out std_logic_vector (3 downto 0);
	dig_04, dig_05, dig_06, dig_07 : out std_logic_vector (3 downto 0);
	dig_08, dig_09, dig_10, dig_11 : out std_logic_vector (3 downto 0);
	dig_12, dig_13, dig_14, dig_15 : out std_logic_vector (3 downto 0)
);
end puzzle;

architecture a of puzzle is
-- 각 7segment의 값을 처리하기 위한 내부 변수
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

-- puzzle의 동작 상태를 나타내기 위한 state (idle : 초기상태 또는 종료상태,
-- address_scan : 롬에서 데이터를 읽기 위한 address를 생성하는 상태,
-- load_data : address_scan state에서 만들어진 address를 가지고 롬으로 부터 데이터 로드,
-- play : 실제 동작 상태
type status is (idle, address_scan, load_data, play);
signal puzzle_status : status;

-- 퍼즐의 모든 숫자가 맞추어 질 경우 '1'의 값을 가진다.
signal play_done : std_logic;

-- 롬에 저장된 256가지의 데이터 어드레스
signal rom_address_msb : integer range 255 downto 0;
-- 256가지의 데이터에 대한 각각의 숫자 어드레스
signal rom_address_lsb : integer range 15 downto 0;

-- 버튼 누름 감지를 위한 변수, 값이 "01"일 경우 누름으로 감지
signal start, up, down, left, right : std_logic_vector (1 downto 0);

-- 공백의 위치에 대한 변수
signal position : integer range 15 downto 0;

-- 256가지의 데이터에 대한 각각의 숫자 어드레스
signal address : integer range 15 downto 0;

-- 버튼의 누름을 감지하기 위한 변수값을 생성하는 구문
-- 예를 들어 start의 값이 "01"인경우 키가 눌려짐을 의미하고
-- "10"인 경우 눌러진 상태에서 떼어진 상태로 바뀜을 의미한다.
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

-- 퍼즐의 동작 상태를 제어하기 위한 구문
process (clk)
begin
	if clk'event and clk = '1' then
		case puzzle_status is
			when idle =>
-- start 버튼이 눌러지면
				if start = "01" then
					puzzle_status <= address_scan;
				end if;
			when address_scan =>
-- start 버튼이 떼어지면
				if start = "10" then
					puzzle_status <= load_data;
				end if;
			when load_data =>
-- address가 15가 되면(rom으로 부터 data load가 완료되면)
				if address = 15 then
					puzzle_status <= play;
				end if;
			when play =>
-- play 도중 start가 눌러지면 게임 종료
				if start = "01" then
					puzzle_status <= idle;
-- 모든 숫자가 맞추어 지면 게임 종료
				elsif play_done = '1' then
					puzzle_status <= idle;
end if;
			when others =>
				puzzle_status <= idle;
		end case;
	end if;
end process;

-- 롬으로 부터 데이터가 읽어지는 load_data 상태에서
rom_cs <= '0' when puzzle_status = load_data else '1'; 

-- address_scan state는 start키가 눌려지는 동안 상태가 유지되는데 이때 address를 무한 반복으로 카운트 하고 state가 load_data로 전환될때 카운트된 address를 넘겨주게 된다. 이렇게 하여 준비된 256개의
-- 데이터중에서 임의의 데이터가 선택되도록 한다.
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

-- 롬으로 선택된 숫자 데이터를 읽기위한 하위 어드레스를 생성하기 위한 구문
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
-- conv_std_logic_vector는 integer의 형태를 std_logic_vector로 변환하기 위한 function
	rom_address(3 downto 0) <= conv_std_logic_vector(rom_address_lsb,4);
	
end process;

process (clk)
begin
	if clk'event and clk = '1' then
-- 롬으로 부터 읽어진 데이터에서 공백("1111")위치를 찾는다.
		if puzzle_status = load_data then
				if rom_data = "1111" then
					position <= address;
				end if;
		elsif puzzle_status = play then
-- 방향키가 눌러짐에 따라 공백의 위치를 변경한다.
			if up = "01" then
-- 공백의 위치가 가장 위의 줄에 위치할 경우 더이상 위로의 이동이 불가 하므로
-- 위치 이동이 없으며 이외의 조건에서는 이전위치에서 4를 빼서 다음 위치를 지정한다.
				if position >= 4 then
					position <= position - 4;
				end if;
			elsif down = "01" then
-- 공백의 위치가 가장 아래의 줄에 위치할 경우 더이상 아래로의 이동이 불가 하므로
-- 위치 이동이 없으며 이외의 조건에서는 이전위치에서 4를 더해서 다음 위치를 지정한다.
				if position <= 11 then
					position <= position + 4;
				end if;
			elsif left = "01" then
-- 공백의 위치가 가장 왼쪽의 줄에 위치할 경우 더이상 왼쪽으로의 이동이 불가 하므로
-- 위치 이동이 없으며 이외의 조건에서는 이전위치에서 1를 빼서 다음 위치를 지정한다.
				if position /= 0 and position /= 4 and position /= 8 and position /= 12 then
					position <= position - 1;
				end if;
			elsif right = "01" then
-- 공백의 위치가 가장 오른쪽의 줄에 위치할 경우 더이상 오른쪽으로의 이동이 불가 하므로
-- 위치 이동이 없으며 이외의 조건에서는 이전위치에서 1를 더해서 다음 위치를 지정한다.
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
-- 롬으로 부터 숫자 데이터를 읽어오는 구문
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
-- 각 키의 눌러짐과 현재 공백의 위치를 조합하여 다음 데이터의 값을 변경한다.
		elsif puzzle_status = play then
-- 현재 공백의 위치가 두번째 줄의 첫번째에 위치해 있을때 up 버튼이 눌러진 경우나
-- 공백의 위치가 첫번째 줄의 첫번째에 위치한 상태에서 down 버튼이 눌러진 경우
-- 첫째눌의 첫번째 값과 두번째 줄의 첫번째의 값을 교환한다.
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
-- 숫자들이 정확한 자리에 위치된 것을 체크하기 위한 구문
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
