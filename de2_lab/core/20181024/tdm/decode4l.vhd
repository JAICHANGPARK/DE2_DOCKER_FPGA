ENTITY decode4l IS
PORT(
	d1, d0 : IN BIT;
	y0, y1, y2, y3: OUT BIT);
END decode4l;

ARCHITECTURE a of decode4l IS
	SIGNAL inputs : BIT_VECTOR(1 downto 0);
	SIGNAL outputs: BIT_VECTOR(0 to 3);
BEGIN
	inputs <= d1 & d0;
	WITH inputs SELECT
		outputs <=	"0111" WHEN "00",
					"1011" WHEN "01",
					"1101" WHEN "10",
					"1110" WHEN "11";
	y0 <= outputs(0);
	y1 <= outputs(1);
	y2 <= outputs(2);
	y3 <= outputs(3);
end a;