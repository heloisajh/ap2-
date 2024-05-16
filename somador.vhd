LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY somador IS
	GENERIC (
		N : INTEGER);
	PORT (
		add1 : IN signed(N-1 DOWNTO 0);
		add2 : IN signed(N-1 DOWNTO 0);
		sum : OUT signed(N DOWNTO 0));
END somador;

ARCHITECTURE rtl OF somador IS
BEGIN
	sum <= resize(add1, N + 1) + resize(add2, N + 1);
END rtl;
