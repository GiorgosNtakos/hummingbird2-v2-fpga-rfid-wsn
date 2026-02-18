LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY rolled_chi_nu IS

    PORT(

        clk    : IN  STD_LOGIC;                   -- Σήμα ρολογιού
        rst    : IN  STD_LOGIC;                   -- Σήμα επαναφοράς
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0); -- 16-bit κλειδί 1
        start  : IN  STD_LOGIC;
        done   : OUT  STD_LOGIC;
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- 16-bit έξοδος δεδομένων

    );

END ENTITY rolled_chi_nu;

ARCHITECTURE BEhavioral OF rolled_chi_nu IS

    SIGNAL mux_1_o, mux_2_o, mux_3_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL temp_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xor_1_o, xor_2_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL f_out, g_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL processing : STD_LOGIC := '0';
    SIGNAL cnt : INTEGER RANGE 0 TO 7;


    COMPONENT f_function
    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        f_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
    END COMPONENT;

    COMPONENT g_function
    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        g_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

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

    g_entity: g_function PORT MAP (x_in => xor_1_o, g_out => g_out);
    f_entity: f_function PORT MAP (x_in => xor_2_o, f_out => f_out);

    PROCESS(rst,clk)
    BEGIN

        IF rst = '1' THEN

            temp_out <= (OTHERS => '0');
            cnt <= 0;
            done <= '0';
            
            
        ELSIF RISING_EDGE(clk) THEN

            IF start = '1' THEN

                processing <= '1';

            ELSIF processing = '1' THEN

                IF cnt < 7 THEN

                    cnt <= cnt + 1;

                ELSE

                    cnt <= 0;
                    processing <= '0';
                    done <= '1';


                END IF;

                temp_out <= f_out;

            ELSIF start = '0' THEN

                done <= '0';

            END IF;
        END IF;
    END PROCESS;

    y_out <= temp_out;

END ARCHITECTURE Behavioral;


