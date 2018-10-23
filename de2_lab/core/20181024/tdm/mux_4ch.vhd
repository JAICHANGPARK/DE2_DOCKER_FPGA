ENTITY mux_4ch IS
	PORT(
		s	: IN	BIT_VECTOR (1 downto 0);
		d	: IN	BIT_VECTOR (3 downto 0);
		y	: OUT	BIT);
END mux_4ch;

ARCHITECTURE a OF mux_4ch IS
BEGIN
	--  Selected Signal Assignment
MUX4:	WITH s SELECT
		y 	<= 	d(0) WHEN "00",
				d(1) WHEN "01",
				d(2) WHEN "10",
				d(3) WHEN "11";
END a;

