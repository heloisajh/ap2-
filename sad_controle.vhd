LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_controle is
  port (
    clk, rst, iniciar, menor: in std_logic;
    pronto, ler, zi, ci, zsoma, csoma, cpA, cpB, csad_reg: out std_logic
  );
end entity sad_controle;

architecture behavior of sad_controle is
  type Tipo_estado IS (S0, S1, S2, S3, S4, S5);
  signal EA, PE: Tipo_estado;
begin
  process(clk, rst, iniciar, menor, EA)
  begin
    case EA is
      when S0 =>
        if iniciar = '0' then
          PE <= S0;
        else
          PE <= S1;
        end if;
      when S1 =>
        PE <= S2;
      when S2 =>
        if menor = '1' then
          PE <= S3;
        else
          PE <= S5;
        end if;
      when S3 =>
        PE <= S4;
      when S4 => 
        PE <= S2;
      when S5 =>
        PE <= S0;
    end case;
  end process;
  
  process(clk, rst)
  begin
    if rst = '1' then
      EA <= S0;
    elsif rising_edge(clk) then
      EA <= PE;
    end if;
  end process;
  
  pronto <= '1' when EA = S0 else '0';
  ler <= '1' when EA = S3 else '0';
  zi <= '1' when EA = S1 else '0';
  ci <= '1' when EA = S1 or EA = S4 else '0';
  zsoma <= '1' when EA = S1 else '0';
  csoma <= '1' when EA = S1 or EA = S4 else '0'; 
  cpA <= '1' when EA = S3 else '0';
  cpB <= '1' when EA = S3 else '0';
  csad_reg <= '1' when EA = S3 else '0';
  
end behavior;
