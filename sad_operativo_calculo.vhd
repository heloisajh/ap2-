LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;

entity sad_operativo_calculo is
GENERIC (
		B : POSITIVE := 8 -- número de bits por amostra
	);
  port (
    clk, rst: in std_logic;
	 zsoma, csoma, cpA, cpB, csad_reg: in std_logic;
    mem_A, mem_B: in std_logic_vector(B-1 downto 0);
    sad: out std_logic_vector((B+integer(log2(real(64))))-1 DOWNTO 0)
  );
end entity sad_operativo_calculo;

architecture arc_bo of sad_operativo_calculo is
  --signals
  -- A
  signal mem_A_reg: std_logic_vector(B-1 downto 0);
  signal mem_A_reg_signed: signed(B-1 downto 0);
  -- B
  signal mem_B_reg: std_logic_vector(B-1 downto 0);
  signal mem_B_reg_signed: signed (B-1 downto 0);
  -- resultado A-B
  signal resultAB: std_logic_vector (B downto 0);
  signal resultAB_signed: signed (B downto 0);
  signal resultAB_abs: signed(B downto 0);
  signal resultAB_8: std_logic_vector(B-1 downto 0);
  -- cargas A e B
  -- resultado A-B concatenado com 0
  signal resultAB_14b: std_logic_vector ((B+integer(log2(real(64))))-1 DOWNTO 0); 
  signal resultAB_14b_signed: signed ((B+integer(log2(real(64))))-1 DOWNTO 0);
  -- soma do resultado com ele mesmo 
  signal soma_signed: signed (B+integer(log2(real(64))) DOWNTO 0);
  signal soma: std_logic_vector (B+integer(log2(real(64))) DOWNTO 0);
  signal soma_14: std_logic_vector ((B+integer(log2(real(64))))-1 DOWNTO 0);
  signal soma_mux: std_logic_vector ((B+integer(log2(real(64))))-1 DOWNTO 0);
  -- registrador soma
  signal soma_reg: std_logic_vector ((B+integer(log2(real(64))))-1 DOWNTO 0);
  signal soma_reg_signed: signed ((B+integer(log2(real(64))))-1 DOWNTO 0);
  -- registrador sad
  
begin
  --componentes 
  -- registrador para memória A
  pA: entity work.registrador(rtl)
  generic map(n => B
  )
    port map(
      clk => clk,
      rst => rst,
      sel => cpA,
      D => mem_A,
      Q => mem_A_reg
    );

-- registrador para memória B
pb: entity work.registrador(rtl)
generic map(n => B
)
port map(
clk => clk,
rst => rst,
sel => cpB,
D => mem_B,
Q => mem_B_reg
);

-- converter vetor de bits para signed 
mem_A_reg_signed <= signed(mem_A_reg);
mem_B_reg_signed <= signed(mem_B_reg);

-- subtrator 1 (A-B)
subtrator1: entity work.subtrator(rtl)
generic map(n => B
)
port map(
sub1 => mem_A_reg_signed,
sub2 => mem_B_reg_signed,
subtraction => resultAB_signed
);

-- módulo ABS 
resultAB_abs <= abs(resultAB_signed);

-- converter signed para vetor de bits
resultAB <= std_logic_vector(resultAB_abs);
resultAB_8 <= resultAB(B-1 downto 0);

-- concatenar n '0's com resultAB em vetor de bits
resultAB_14b <= ((B+(integer(log2(real(64)))))-1 downto resultAB_8'length => '0') & resultAB_8;

-- converter resultAB_14b para signed
resultAB_14b_signed <= signed(resultAB_14b);

-- somar resultAB_14b com soma_reg

somador1: entity work.somador(rtl)
generic map(n => B+(integer(log2(real(64))))
)
port map(
add1 => resultAB_14b_signed,
add2 => soma_reg_signed,
sum => soma_signed
);

-- converter soma para vetor de bits
soma <= std_logic_vector(soma_signed);
soma_14 <= soma((B+integer(log2(real(64))))-1 DOWNTO 0);

--mux 2 para 1
mux: entity work.mux2para1(rtl)
generic map(n => B+(integer(log2(real(64))))
)
port map(
sel => zsoma,
a => soma_14,
b => (others => '0'),
y => soma_mux
);

-- registrador soma
soma_component: entity work.registrador(rtl)
generic map(n => B+(integer(log2(real(64))))
)
port map(
clk => clk,
rst => rst,
sel => csoma,
D => soma_mux,
Q => soma_reg
);

-- converter soma_reg para signed para o somador1
soma_reg_signed <= signed(soma_reg);

-- registrador sad - resultado final
SAD_reg: entity work.registrador(rtl)
generic map(n => B+(integer(log2(real(64))))
)
port map(
clk => clk,
rst => rst,
sel => csad_reg,
D => soma_reg,
Q => sad
);


end architecture arc_bo;







