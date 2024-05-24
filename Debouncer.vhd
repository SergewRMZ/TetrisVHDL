LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Debouncer IS
    PORT (
        clk : IN STD_LOGIC;
        input_signal : IN STD_LOGIC;
        debounced_output : OUT STD_LOGIC
    );
END ENTITY Debouncer;

ARCHITECTURE behavior OF Debouncer IS
    SIGNAL shift_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            shift_reg <= shift_reg(1 DOWNTO 0) & input_signal;
        END IF;
    END PROCESS;

    debounced_output <= '1' WHEN shift_reg = "111" ELSE '0';
END ARCHITECTURE behavior;
