LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;

ENTITY sad IS
	GENERIC (
		B : POSITIVE := 8 -- número de bits por amostra
	);
	PORT (
		  clk : IN STD_LOGIC; -- sinal de clock
        enable : IN STD_LOGIC; -- sinal de habilitação/inicialização
        reset : IN STD_LOGIC; -- sinal de reset
        sample_ori : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- amostra original
        sample_can : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- amostra candidata
        read_mem : OUT STD_LOGIC; -- sinal de leitura da memória
        address : OUT STD_LOGIC_VECTOR ((integer(log2(real(64))))-1 DOWNTO 0); -- endereço de memória
        sad_value : OUT STD_LOGIC_VECTOR ((B+integer(log2(real(64))))-1 DOWNTO 0); -- valor de SAD 
        done: OUT STD_LOGIC 
		  );
		  
END ENTITY; 

ARCHITECTURE arch OF sad IS
  --signals
  signal menor_in: std_logic;
  signal zi_out: std_logic;
  signal ci_out: std_logic;
  signal cpA_out: std_logic;
  signal cpB_out: std_logic;
  signal zsoma_out: std_logic;
  signal csoma_out: std_logic;
  signal csad_reg_out: std_logic;
  
begin
  --componentes 
  -- bloco de controle
  sad_controle: entity work.sad_controle(behavior)
    port map(
      clk => clk,
      rst => reset,
		iniciar => enable,
		menor => menor_in,
		pronto => done,
		zi => zi_out,
		ci => ci_out,
		zsoma => zsoma_out,
		csoma => csoma_out,
		cpA => cpA_out,
		cpB => cpB_out,
		csad_reg => csad_reg_out
    );


-- bloco operativo cálculo sad
sad_operativo_calculo: entity work.sad_operativo_calculo(arc_bo)
port map(
clk => clk,
rst => reset,
zsoma => zsoma_out,
csoma => csoma_out,
cpA => cpA_out,
cpB => cpB_out,
csad_reg => csad_reg_out,
mem_A => sample_ori,
mem_B => sample_can,
sad => sad_value
);

-- bloco operativo cálculo end
sad_operativo_end: entity work.sad_operativo_end(arc_bo)

port map(
clk => clk,
rst => reset,
zi => zi_out,
ci => ci_out,
endereco => address,
menor => menor_in
);
	-- descrever
	-- usar sad_bo e sad_bc (sad_operativo e sad_controle)
	-- não codifiquem toda a arquitetura apenas neste arquivo
	-- modularizem a descrição de vocês...
	
END ARCHITECTURE; -- arch