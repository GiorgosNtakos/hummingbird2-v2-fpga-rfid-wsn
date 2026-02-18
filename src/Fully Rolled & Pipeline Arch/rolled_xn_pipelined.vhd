LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY rolled_pipeline_chi_nu IS

    PORT(

        clk    : IN  STD_LOGIC;                   -- Σήμα ρολογιου
        rst    : IN  STD_LOGIC;                   -- Σήμα επαναφοράς
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0); -- 16-bit κλειδί 1
        start  : IN  STD_LOGIC;
        done   : OUT  STD_LOGIC;
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- 16-bit έξοδος δεδομένων

    );

END ENTITY rolled_pipeline_chi_nu;

ARCHITECTURE BEhavioral OF rolled_pipeline_chi_nu IS

    SIGNAL mux_1_o, mux_2_o, mux_3_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL temp_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xor_1_o, xor_2_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL f_out, g_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL processing : STD_LOGIC := '0';
    SIGNAL cnt : INTEGER RANGE 0 TO 7;

    SIGNAL g_start, g_done : STD_LOGIC := '0';
    SIGNAL f_start, f_done : STD_LOGIC := '0'; 


    COMPONENT f_function_pipeline
    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        f_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        start  : IN  STD_LOGIC;
        done   : OUT STD_LOGIC;
        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC

    );
    END COMPONENT;

    COMPONENT g_function_pipeline
    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        start  : IN  STD_LOGIC;
        done   : OUT STD_LOGIC;
        g_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC

    );
    END COMPONENT;

BEGIN

    WITH cnt SELECT

        mux_1_o <= key(63 DOWNTO 48) WHEN 0,
                   key(47 DOWNTO 32) WHEN 1,
                   key(31 DOWNTO 16) WHEN 2,
                   key(15 DOWNTO  0) WHEN 3,
                   key(63 DOWNTO 48) WHEN 4,
                   key(31 DOWNTO 16) WHEN 5,
                   key(47 DOWNTO 32) WHEN 6,
                   key(15 DOWNTO  0) WHEN 7,
                   (OTHERS => '0') WHEN OTHERS;


    WITH cnt SELECT

        mux_2_o <= x_in WHEN 0,
                   temp_out WHEN 1 TO 7,
                   (OTHERS => '0') WHEN OTHERS;

    WITH cnt SELECT

        mux_3_o <= X"4D71" WHEN 0,
                   X"0F65" WHEN 1,
                   X"2746" WHEN 2,
                   X"0B7C" WHEN 3,
                   X"CFD5" WHEN 4,
                   X"8E45" WHEN 5,
                   X"40DA" WHEN 6,
                   X"62F0" WHEN 7,
                   (OTHERS => '0') WHEN OTHERS;


    xor_1_o <= mux_1_o XOR mux_2_o;
    xor_2_o <= g_out XOR mux_3_o;

    g_entity: g_function_pipeline PORT MAP (x_in => xor_1_o, start => g_start, done => g_done, g_out => g_out, clk => clk, rst => rst);
    f_entity: f_function_pipeline PORT MAP (x_in => xor_2_o, f_out => f_out, start => f_start, done => f_done, clk => clk, rst => rst);

    PROCESS(rst,clk)
    BEGIN

        IF rst = '1' THEN

            temp_out <= (OTHERS => '0');
            processing <= '0';
            cnt <= 0;
            done <= '0';
            g_start <= '0';
            f_start <= '0';
            
        ELSIF RISING_EDGE(clk) THEN

            IF start = '1' AND processing = '0' THEN

                processing <= '1';
                cnt        <=  0 ;
                g_start    <= '1';

            ELSIF processing = '1' THEN

                IF g_done = '1' THEN
                
                    g_start <= '0';
                    f_start <= '1';

                END IF;

                IF f_done = '1' THEN

                    f_start <= '0';
                    temp_out <= f_out;

                    IF cnt < 7 THEN

                        cnt     <= cnt + 1;
                        g_start <= '1';

                    ELSE

                        cnt <= 0;
                        processing <= '0';
                        done <= '1';

                    END IF;

                END IF;

            ELSIF start = '0' THEN

                done <= '0';

            END IF;

        END IF;
    END PROCESS;

    y_out <= temp_out;

END ARCHITECTURE Behavioral;


