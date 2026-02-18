LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY f_function_pipeline IS

    PORT(

        clk     : IN STD_LOGIC;
        rst     : IN STD_LOGIC;
        start   : IN STD_LOGIC;
        x_in    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        f_out   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        done    : OUT STD_LOGIC

    );

END ENTITY f_function_pipeline;

ARCHITECTURE Behavioral OF f_function_pipeline IS

    SIGNAL s1_rol1, s1_rol2, s1_ror1, s1_x_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s2_out, s2_x_in                    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL valid                              : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL valid_prev_1  : STD_LOGIC := '0';  -- για edge detection

BEGIN

    PROCESS(clk, rst)
    BEGIN

        IF rst = '1' THEN

            s1_rol1 <= (OTHERS => '0');
            s1_rol2 <= (OTHERS => '0');
            s1_ror1 <= (OTHERS => '0');
            s1_x_in <= (OTHERS => '0');
            s2_out  <= (OTHERS => '0');
            s2_x_in <= (OTHERS => '0');
            f_out   <= (OTHERS => '0');
            done    <= '0';

        ELSIF rising_edge(clk) THEN

            done <= '0';

            IF start = '1' THEN

                -- Stage 1: Υπολογισμος shifts
                s1_rol2 <= x_in ROL 2;
                s1_rol1 <= x_in ROL 1;
                s1_ror1 <= x_in ROR 1;
                s1_x_in <= x_in;
                valid(0) <= '1';

            ELSE 

                valid(0) <= '0';

            END IF;

            -- Stage 2: Υπολογισμος AND
            s2_out   <= (s1_rol2 AND NOT(s1_rol1)) AND s1_ror1;
            s2_x_in  <= s1_x_in;
            valid(1) <= valid(0);

            -- Stage 3: Υπολογισμος XOR
            f_out       <= s2_out XOR s2_x_in;
            -- DONE only when valid(1) has rising edge
            IF valid(1) = '1' AND valid_prev_1 = '0' THEN
                done <= '1';
            END IF;

            -- Keep previous state
            valid_prev_1 <= valid(1);
            
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;
