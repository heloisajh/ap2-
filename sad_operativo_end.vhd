LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;

entity sad_operativo_end is
	GENERIC (
		B : POSITIVE := 8 -- número de bits por amostra
	);
  port (
    zi,ci, clk, rst: in std_logic;
    menor: out std_logic;
	 endereco: out std_logic_vector((integer(log2(real(64))))-1 DOWNTO 0)
  );
end entity sad_operativo_end;

architecture arc_bo of sad_operativo_end is
signal soma: std_logic_vector (integer(log2(real(64))) DOWNTO 0);
signal soma_mux: std_logic_vector (integer(log2(real(64))) DOWNTO 0);
signal soma_mux_reg: std_logic_vector (integer(log2(real(64))) DOWNTO 0);
signal soma_mux_6: std_logic_vector ((integer(log2(real(64))))-1 DOWNTO 0);
signal soma_mux_signed: signed ((integer(log2(real(64))))-1 DOWNTO 0);
signal soma_signed: signed (integer(log2(real(64))) DOWNTO 0);

begin

mux: entity work.mux2para1(rtl)
generic map(n => (integer(log2(real(64))))+1
)
port map(
sel => zi,
a => soma,
b => (others => '0'),
y => soma_mux
);

i: entity work.registrador(rtl)
generic map(n => (integer(log2(real(64))))+1
)
port map(
clk => clk,
rst => rst,
sel => ci,
D => soma_mux,
Q => soma_mux_reg
);

menor <= not(soma_mux_reg(integer(log2(real(64)))));
endereco <= soma_mux_reg((integer(log2(real(64))))-1 DOWNTO 0);

soma_mux_6 <= soma_mux_reg((integer(log2(real(64))))-1 DOWNTO 0);
soma_mux_signed <= signed(soma_mux_6);

somador1: entity work.somador(rtl)
generic map(n => integer(log2(real(64)))
)
port map(
add1 => soma_mux_signed,
add2 => (0 => '1', others => '0'),
sum => soma_signed
);

soma <= std_logic_vector(soma_signed);

end architecture arc_bo;