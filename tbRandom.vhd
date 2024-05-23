library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tbRandom is
    -- Testbench no tiene puertos
end tbRandom;

architecture Behavioral of tbRandom is
    -- Señales para conectar con la entidad bajo prueba (UUT: Unit Under Test)
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal random_num : STD_LOGIC_VECTOR (2 downto 0);
    
    -- Instancia de la unidad bajo prueba
    component Random
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            enable : in STD_LOGIC;
            random_num : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;
    
begin
    -- Instanciar la unidad bajo prueba (UUT)
    uut: Random port map (
        clk => clk,
        reset => reset,
        enable => enable,
        random_num => random_num
    );
    
    -- Generar señal de reloj
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    -- Estímulos de prueba
    stimulus: process
    begin
        -- Reiniciar la unidad bajo prueba
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Habilitar el generador de números aleatorios
        enable <= '1';
        
        -- Dejar que el LFSR genere números por un tiempo
        wait for 200 ns;
        
        -- Deshabilitar el generador
        enable <= '0';
        
        -- Esperar un poco más y luego detener la simulación
        wait for 50 ns;
        wait;
    end process;
end Behavioral;
