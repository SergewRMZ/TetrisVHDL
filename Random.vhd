library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Random is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable : in STD_LOGIC;
        random_num : out STD_LOGIC_VECTOR (2 downto 0)
    );
end Random;

architecture Behavioral of Random is
    signal lfsr : STD_LOGIC_VECTOR (2 downto 0) := "101"; -- Semilla inicial
    signal feedback : STD_LOGIC;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            lfsr <= "101"; -- Reiniciar el LFSR con la semilla inicial
        elsif rising_edge(clk) then
            if enable = '1' then
                feedback <= lfsr(2) xor lfsr(0); -- Polinomio x^3 + x^1 + 1
                lfsr <= feedback & lfsr(2 downto 1); -- Desplazamiento a la izquierda con retroalimentación
            end if;
        end if;
    end process;
    
    random_num <= lfsr; -- Asignar el valor del LFSR a la salida
end Behavioral;
