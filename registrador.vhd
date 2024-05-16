LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador IS
    GENERIC (
        N : INTEGER);
    PORT (
        clk, rst, sel : IN STD_LOGIC;
        D : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0)
    );
END registrador;

ARCHITECTURE rtl OF registrador IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
				IF (sel = '1') THEN
                Q <= D;

		      END IF;
		  END IF;
	 END PROCESS;
END rtl;