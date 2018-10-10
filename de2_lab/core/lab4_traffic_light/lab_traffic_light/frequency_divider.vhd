Library ieee;
USE ieee.std_logic_1164.ALL;

entity frequency_divider is
	port (clock : in std_logic;
		  Fout : inout std_logic);
end frequency_divider;

architecture arc of frequency_divider is
signal Qa, Qb, Qc, Qd, Qe, Qf, Qg, Qh, Qi, I : std_logic;

component jkflipflop is
port(j, k, clock : in std_logic; Q, Qnot: inout std_logic);
end component;

begin 
I <= '1';
FF1: jkflipflop port map( j => I, k=> I, clock => clock, Q => Qa);
FF2: jkflipflop port map( j => I, k=> I, clock => Qa, Q => Qb);
FF3: jkflipflop port map( j => I, k=> I, clock => Qb, Q => Qc);
FF4: jkflipflop port map( j => I, k=> I, clock => Qc, Q => Qd);
FF5: jkflipflop port map( j => I, k=> I, clock => Qd, Q => Qe);
FF6: jkflipflop port map( j => I, k=> I, clock => Qe, Q => Qf);
FF7: jkflipflop port map( j => I, k=> I, clock => Qf, Q => Qg);
FF8: jkflipflop port map( j => I, k=> I, clock => Qg, Q => Qh);
FF9: jkflipflop port map( j => I, k=> I, clock => Qh, Q => Qi);
FF10: jkflipflop port map( j => I, k=> I, clock => Qi, Q => Fout);

end arc;


