library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity puzzle is
	port(
		clk				: in std_logic;
		up_k			: in std_logic;  -- up_side key in 
		down_k			: in std_logic;  -- down_side key in
		left_k			: in std_logic; -- left_side key in
		right_k			: in std_logic;  -- right_side key in
		start_k			: in std_logic;  -- alone mode start, initialize puzzle, randum start

		data			: buffer std_logic_vector(7 downto 0); -- display data, 
--		decode			: buffer std_logic_vector(3 downto 0);  -- each 7 segment led selector, 4x16 decoder 
		verify			: buffer std_logic_vector(15 downto 0);
		pin_s 			: out std_logic_vector(15 downto 0)

	);
end puzzle;

architecture sample1 of puzzle is

signal		data0		: std_logic_vector(3 downto 0);		-- 0 
signal		data1		: std_logic_vector(3 downto 0);		-- 1
signal		data2		: std_logic_vector(3 downto 0);		-- 2
signal		data3		: std_logic_vector(3 downto 0);		-- 3
signal		data4		: std_logic_vector(3 downto 0);		-- 4
signal		data5		: std_logic_vector(3 downto 0);		-- 5
signal		data6		: std_logic_vector(3 downto 0);		-- 6
signal		data7		: std_logic_vector(3 downto 0);		-- 7
signal		data8		: std_logic_vector(3 downto 0);		-- 8
signal		data9		: std_logic_vector(3 downto 0);		-- 9
signal		dataA		: std_logic_vector(3 downto 0);		-- A
signal		dataB		: std_logic_vector(3 downto 0);		-- B
signal		dataC		: std_logic_vector(3 downto 0);		-- C
signal		dataD		: std_logic_vector(3 downto 0);		-- D
signal		dataE		: std_logic_vector(3 downto 0);		-- E
signal		dataF		: std_logic_vector(3 downto 0);		-- F

signal 		decode		: std_logic_vector(3 downto 0);
signal displ_e		: std_logic;



begin

	process(clk)
	variable temp_up : std_logic_vector (1 downto 0);
	variable temp_dn : std_logic_vector (1 downto 0);
	variable temp_all	: std_logic_vector (3 downto 0);
	variable r_cnt 		: std_logic_vector(3 downto 0);
	variable start_ran	: std_logic;
	variable veri		: std_logic;
	variable key_in	: std_logic;
	variable key_in_m	: std_logic;
	variable unable	: std_logic;
	variable init		: std_logic;
	variable mak_ran	: integer range 0 to 3;
	variable end_ran_m	: integer range 0 to 3;
	variable strobe_ran : std_logic;
	variable cnt		: integer range 0 to 3;
	variable cnt_ex		: integer range 0 to 4;
	variable p_cnt		: std_logic_vector(4 downto 0);

	variable ena_veri	: std_logic;
	begin
		if (clk='1' and clk'event) then

------ start start button module

			if start_k='1' then
				start_ran := '1';
			else
				start_ran := '0';	
			end if;

-------end start button module;


-------start random data generator 



			if  start_ran = '1' then
					key_in_m := '1';
				if init = '1' and cnt =0 then
					data0 <= "0100";
					data1 <= "0101";
					data2 <= "1111";
					data3 <= "1001";
					data4 <= "1011";
					data5 <= "0011";
					data6 <= "0110";
					data7 <= "0111";
					data8 <= "0000";
					data9 <= "0001";
					dataA <= "1010";
					dataB <= "1110";
					dataC <= "1100";
					dataD <= "1000";
					dataE <= "1101";
					dataF <= "0010";
					init := '0';
					cnt := 1;
					strobe_ran  := '1';
				elsif  cnt=1 and strobe_ran = '1' and mak_ran = 0 then
					data0 <= data4;
					data4 <= data0;
					data1 <= data6;
					data6 <= data1;
					data2 <= data5;
					data5 <= data2;
					data3 <= data9;
					data9 <= data3;
					data7 <= dataE;
					dataE <= data7;
					data8 <= dataB;
					dataB <= data8;
					dataA <= dataD;
					dataD <= dataA;
					dataC <= dataF;
					dataF <= dataC;
					strobe_ran := '0';
					cnt := 2;
				elsif  cnt=1 and strobe_ran = '1' and mak_ran = 1 then
					data0 <= dataF;
					dataF <= data0;
					data1 <= data6;
					data6 <= data1;
					data2 <= dataA;
					dataA <= data2;
					data3 <= data5;
					data5 <= data3;
					data4 <= dataD;
					dataD <= data4;
					data7 <= dataB;
					dataB <= data7;
					data8 <= dataC;
					dataC <= data8;
					data9 <= dataE;
					dataE <= data9;
					strobe_ran := '0';
					cnt := 2;
				elsif  cnt=1 and strobe_ran = '1' and mak_ran = 2 then
					data0 <= data7;
					data7 <= data0;
					data1 <= data4;
					data4 <= data1;
					data2 <= data9;
					data9 <= data2;
					data3 <= dataF;
					dataF <= data3;
					data5 <= dataC;
					dataC <= data5;
					data6 <= dataD;
					dataD <= data6;
					data8 <= dataB;
					dataB <= data8;
					dataA <= dataE;
					dataE <= dataA;
					strobe_ran := '0';
					cnt := 2;
				elsif cnt = 2 then
					data0 <= data0 + 1;
					data1 <= data1 + 1;
					data2 <= data2 + 1;
					data3 <= data3 + 1;
					data4 <= data4 + 1;
					data5 <= data5 + 1;
					data6 <= data6 + 1;
					data7 <= data7 + 1;
					data8 <= data8 + 1;
					data9 <= data9 + 1;	
					dataA <= dataA + 1;
					dataB <= dataB + 1;
					dataC <= dataC + 1;
					dataD <= dataD + 1;
					dataE <= dataE + 1;
					dataF <= dataF + 1;
					cnt := 1;
					strobe_ran := '1';
				end if;
				if mak_ran = 2 then
					mak_ran := 0;
				else
					if end_ran_m =3 then
						end_ran_m := 0;
						mak_ran := mak_ran + 1;
					else
						end_ran_m := end_ran_m + 1;
					end if;
				end if;	
			else
				strobe_ran := '0';
				cnt := 0;
				init := '1';
				key_in_m := '0';		
			end if;


------ end random data generator

------ start  key In watchdog & signal return						

			if start_k ='0' then	
				if up_k='1' or down_k='1' or left_k='1' or right_k = '1' then
					key_in := '1';
					displ_e <= '1';
				else
					displ_e <= '1';
					key_in := '0';
				end if;
			end if;
		
------ end  'key In watchdog & signal return


------start 'data position exchanger from one to one


			if key_in = '1' then
				if cnt_ex = 0 then

					if up_k='1'  then
						if dataF(3 downto 2)="11" then
							unable := '1';   -- can't move anywhere
						else
							temp_up := dataF(3 downto 2);
							cnt_ex := cnt_ex + 1;
							unable := '0';
						end if;	
					end if;
					if down_k='1' then
						if dataF(3 downto 2)="00" then
							unable := '1';   -- can't move anywhere
						else
							temp_up := dataF(3 downto 2);
							cnt_ex := cnt_ex + 1;
							unable := '0';
						end if;	
					end if;

					if left_k='1' then
						if dataF(1 downto 0)="11"  then
							unable := '1';   -- can't move anywhere

						else
							temp_dn := dataF(1 downto 0);
							cnt_ex := cnt_ex + 1;
							unable := '0';
						end if;	
					end if;
					if  right_k='1'  then
						if dataF(1 downto 0)="00"  then
							unable := '1';   -- can't move anywhere

						else
							temp_dn := dataF(1 downto 0);
							cnt_ex := cnt_ex + 1;
							unable := '0';
						end if;	
					end if;

				elsif cnt_ex=1 and unable ='0' then
						
					if up_k ='1' then
						temp_up := temp_up + 1;
					end if;

					if down_k ='1' then
						temp_up := temp_up - 1;
					end if;

					if left_k ='1' then
						temp_dn := temp_dn + 1;
					end if;

					if right_k ='1' then
						temp_dn := temp_dn - 1;
					end if;
					cnt_ex := cnt_ex + 1;

				elsif cnt_ex=2 then

					if up_k ='1' or down_k = '1' then
						temp_all(3 downto 2) := temp_up;
						temp_all(1 downto 0) := dataF(1 downto 0); 
					end if;

					if left_k = '1' or right_k = '1' then
						temp_all(3 downto 2) := dataF(3 downto 2);
						temp_all(1 downto 0) := temp_dn;
					end if;
					cnt_ex := cnt_ex + 1;

				elsif cnt_ex=3  then 
					if temp_all=data0 then
						dataF <= data0;
						data0 <= dataF;
					elsif temp_all = data1 then
						dataF <= data1;
						data1 <= dataF;
					elsif temp_all = data2 then
						dataF <= data2;
						data2 <= dataF;
					elsif temp_all = data3 then
						dataF <= data3;
						data3 <= dataF;
					elsif temp_all = data4 then
						dataF <= data4;
						data4 <= dataF;
					elsif temp_all = data5 then
						dataF <= data5;
						data5 <= dataF;
					elsif temp_all = data6 then
						dataF <= data6;
						data6 <= dataF;
					elsif temp_all = data7 then
						dataF <= data7;
						data7 <= dataF;
					elsif temp_all = data8 then
						dataF <= data8;
						data8 <= dataF;

					elsif temp_all = data9 then
						dataF <= data9;
						data9 <= dataF;

					elsif temp_all = dataA then
						dataF <= dataA;
						dataA <= dataF;

					elsif temp_all = dataB then
						dataF <= dataB;
						dataB <= dataF;

					elsif temp_all = dataC then
						dataF <= dataC;
						dataC <= dataF;
					elsif temp_all = dataD then
						dataF <= dataD;
						dataD <= dataF;

					elsif temp_all = dataE then
						dataF <= dataE;
						dataE <= dataF;

					end if;
					cnt_ex := 4 ;
					ena_veri := '1';	
				end if;
			
			else
				ena_veri := '0'; 
				cnt_ex := 0;
				temp_all := "0000";
				unable := '0';
			end if;		

			if ena_veri='1' then

				if data0="0000" then
					verify(0) <= veri;
					--pin_s <= "0111111111111111";	
					--pin_s(0) <= veri;
				end if;
				if data1="0001" then
					verify(1) <= veri;
					--pin_s(1) <= veri;
				end if;
				if data2="0010" then
					verify(2) <= veri;
					--pin_s(2) <= veri;
				end if;
				if data3="0011" then
					verify(3) <= veri;
					--pin_s(3) <= veri;
				end if;
				if data4="0100" then
					verify(4) <= veri;
					--pin_s(4) <= veri;
				end if;
				if data5="0101" then
					verify(5) <= veri;
					--pin_s(5) <= veri;
				end if;
				if data6="0110" then
					verify(6) <= veri;
					--pin_s(6) <= veri;
				end if;
				if data7="0111" then
					verify(7) <= veri;
					--pin_s(7) <= veri;
				end if;
				if data8="1000" then
					verify(8) <= veri;
					--pin_s(8) <= veri;
				end if;
				if data9="1001" then
					verify(9) <= veri;
					--pin_s(9) <= veri;
				end if;
				if dataA="1010" then
					verify(10) <= veri;
					--pin_s(10) <= veri;
				end if;
				if dataB="1011" then
					verify(11) <= veri;
					--pin_s(11) <= veri;
				end if;
				if dataC="1100" then
					verify(12) <= veri;
					--pin_s(12) <= veri;
				end if;
				if dataD="1101" then
					verify(13) <= veri;
					--pin_s(13) <= veri;
				end if;
				if dataE="1110" then
					verify(14) <= veri;
					--pin_s(14) <= veri;
				end if;
				if dataF="1111" then
					verify(15) <= veri;
					--pin_s(15) <= veri;
				end if;
			else
				veri := '1';
				verify <="0000000000000000";

			end if;

--- display module block
			if displ_e = '1' then 
					if p_cnt = 31 then
						r_cnt := r_cnt + 1;
						p_cnt := "00000";
					elsif r_cnt=data0 then
						decode <= r_cnt;
						data <= "00111111";
						p_cnt := p_cnt +1;
					elsif r_cnt=data1 then
						decode <= r_cnt;
						data <= "00000110"; 
						p_cnt := p_cnt + 1;
					elsif r_cnt=data2 then
						decode <= r_cnt;
						data <= "01011011";
						p_cnt := p_cnt +1;
					elsif r_cnt=data3 then
						decode <= r_cnt;
						data <= "01001111";
						p_cnt := p_cnt +1;
					elsif r_cnt=data4 then
						decode <= r_cnt;
						data <= "01100110";
						p_cnt := p_cnt +1;
					elsif r_cnt=data5 then
						decode <= r_cnt;
						data <= "01101101";
						p_cnt := p_cnt +1;
					elsif r_cnt=data6 then
						decode <= r_cnt;
						data <= "01111101";
						p_cnt := p_cnt +1;
					elsif r_cnt=data7 then
						decode <= r_cnt;
						data <= "00100111";
						p_cnt := p_cnt +1;
					elsif r_cnt=data8 then
						decode <= r_cnt;
						data <= "01111111";
						p_cnt := p_cnt +1;
					elsif r_cnt=data9 then
						decode <= r_cnt;
						data <= "01101111";
						p_cnt := p_cnt + 1;
					elsif r_cnt = dataA then
						decode <= r_cnt;
						data <= "01110111";
						p_cnt := p_cnt + 1;
					elsif r_cnt = dataB then
						decode <= r_cnt;
						data <= "01111100";
						p_cnt := p_cnt + 1;
					elsif r_cnt = dataC then
						decode <= r_cnt;
						data <= "00111001";
						p_cnt := p_cnt + 1;
					elsif r_cnt = dataD then
						decode <= r_cnt;
						data <= "01011110";
						p_cnt := p_cnt + 1;
					elsif r_cnt=dataE then
						decode <= r_cnt;
						data <= "01111001";
						p_cnt := p_cnt + 1;
					elsif r_cnt = dataF then
						decode <= r_cnt;
						data <= "00000000";
						p_cnt := p_cnt + 1;
					end if;
			
			else
				p_cnt := "00000";
				r_cnt := "0000";
			end if;

------ end display module 



		end if;
	end process;	
	process(clk)
	begin
	
	if clk'event and clk ='1' then
		case decode is
			when "0000" =>
				pin_s <= "0111111111111111";	
			when "0001" =>
				pin_s <= "1011111111111111";
			when "0010" =>
				pin_s <= "1101111111111111";
			when "0011" =>
				pin_s <= "1110111111111111";	
			when "0100" =>
				pin_s <= "1111011111111111";
			when "0101" =>
				pin_s <= "1111101111111111";
			when "0110" =>
				pin_s <= "1111110111111111";	
			when "0111" =>
				pin_s <= "1111111011111111";
			when "1000" =>
				pin_s <= "1111111101111111";
			when "1001" =>
				pin_s <= "1111111110111111";	
			when "1010" =>
				pin_s <= "1111111111011111";
			when "1011" =>
				pin_s <= "1111111111101111";
			when "1100" =>
				pin_s <= "1111111111110111";	
			when "1101" =>
				pin_s <= "1111111111111011";
			when "1110" =>
				pin_s <= "1111111111111101";
			when "1111" =>
				pin_s <= "1111111111111110";
			when others => null;
		end case;
	end if;
end process;	
				
end sample1;