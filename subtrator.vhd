LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY subtrator IS
	GENERIC (
		N : INTEGER);
	PORT (
		sub1 : IN signed(N-1 DOWNTO 0);
		sub2 : IN signed(N-1 DOWNTO 0);
		subtraction : OUT signed(N DOWNTO 0));
END subtrator;

ARCHITECTURE rtl OF subtrator IS
BEGIN
	subtraction <= resize(sub1, N + 1) - resize(sub2, N + 1);
END rtl;
