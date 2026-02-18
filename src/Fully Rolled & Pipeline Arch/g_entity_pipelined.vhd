LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY g_function_pipeline IS

    PORT(

        clk    : IN STD_LOGIC;
        rst    : IN STD_LOGIC;
        start  : IN STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        g_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- 16-bit έξοδος δεδομένων μετά την εφα�?μογή της συνά�?τησης g
        done   : OUT STD_LOGIC

    );

END ENTITY g_function_pipeline;

ARCHITECTURE Behavioral OF g_function_pipeline IS

    -- Signals για pipeline stages
    SIGNAL s1_rol4, s1_rol8, s1_rol12, s1_x_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s2_out, s2_rol8            : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Valid Pipeline
    SIGNAL valid : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL valid_prev_1 : STD_LOGIC := '0';

BEGIN

    PROCESS(clk, rst)
    BEGIN
        IF rst = '1' THEN

            -- Αρχικοποίηση των ενδιάμεσων σημάτων
            s1_rol4  <= (OTHERS => '0');
            s1_rol8  <= (OTHERS => '0');
            s1_rol12 <= (OTHERS => '0');
            s1_x_in  <= (OTHERS => '0');
            s2_out   <= (OTHERS => '0');
            s2_rol8  <= (OTHERS => '0');
            valid    <= (OTHERS => '0');
            g_out    <= (OTHERS => '0');
            done     <= '0';

        ELSIF rising_edge(clk) THEN

            done <= '0';
            
            IF start = '1' THEN

                -- Stage 1: Υπολογισμος shifts
                s1_x_in  <= x_in;
                s1_rol4  <= x_in ROL  4; -- ROL 4
                s1_rol8  <= x_in ROL  8;  -- ROL 8
                s1_rol12 <= x_in ROL 12;  -- ROL 12
                valid(0) <= '1';

            ELSE 

                valid(0) <= '0';

            END IF;

            -- Stage 2: Υπολογισμος NOR και AND
            s2_out   <= (s1_rol12 NOR s1_x_in) AND s1_rol4;
            s2_rol8  <= s1_rol8;
            valid(1) <= valid(0);


            -- Stage 3: Υπολογισμος XOR
            g_out   <= s2_out XOR s2_rol8; -- AND XOR ROL 8
            -- DONE only when valid(1) has rising edge
            IF valid(1) = '1' AND valid_prev_1 = '0' THEN
                done <= '1';
            END IF;

            -- Keep previous state
            valid_prev_1 <= valid(1);
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;
