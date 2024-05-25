LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Divider IS
    PORT (
        clk : IN STD_LOGIC;
        clk_divider: OUT STD_LOGIC
    );
END ENTITY Divider;

ARCHITECTURE FrecuencyDivisor OF Divider IS
    CONSTANT DIVIDER : INTEGER := 4;
    SIGNAL counter : INTEGER range 0 to DIVIDER := 0;
    SIGNAL clk_state : STD_LOGIC := '0';

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
          IF counter = DIVIDER THEN 
            counter <= 0;
            clk_state <= not clk_state;
          ELSE 
            counter <= counter + 1;
          END IF;
        END IF;
    END PROCESS;

    clk_divider <= clk_state;
END ARCHITECTURE FrecuencyDivisor;
