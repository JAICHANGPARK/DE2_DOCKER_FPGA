ENTITY mux_2ch IS
	PORT(
		s	: IN	BIT;
		d	: IN	BIT_VECTOR (1 downto 0);
		y	: OUT	BIT);
END mux_2ch;

ARCHITECTURE a OF mux_2ch IS
BEGIN
	--  Selected Signal Assignment
MUX2:	WITH s SELECT
		y 	<= 	d(0) WHEN '0',
				d(1) WHEN '1';
			
END a;
