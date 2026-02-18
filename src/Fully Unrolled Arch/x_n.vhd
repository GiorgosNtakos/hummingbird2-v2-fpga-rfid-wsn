LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY chi_nu IS

    PORT(

        clk    : IN  STD_LOGIC;                   -- Σήμα ρολογιού
        rst    : IN  STD_LOGIC;                   -- Σήμα επαναφοράς
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0); -- 16-bit κλειδί 1
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- 16-bit έξοδος δεδομένων

    );

END ENTITY chi_nu;

ARCHITECTURE Behavioral OF chi_nu IS

    SIGNAL t1, t2, t3, t4, t5, t6, t7, t8 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL g_out_1, g_out_2, g_out_3, g_out_4, g_out_5, g_out_6, g_out_7, g_out_8 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xf_in_temp_1, xf_in_temp_2, xf_in_temp_3, xf_in_temp_4, xf_in_temp_5, xf_in_temp_6, xf_in_temp_7, xf_in_temp_8 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL xg_in_temp_1, xg_in_temp_2, xg_in_temp_3, xg_in_temp_4, xg_in_temp_5, xg_in_temp_6, xg_in_temp_7, xg_in_temp_8 : STD_LOGIC_VECTOR(15 DOWNTO 0);

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
    -- Apply the χν steps
    -- t1 = f(g(x ⊕ k1) ⊕ 4D71)
    xg_in_temp_1 <= x_in XOR key(63 DOWNTO 48);
    g1: g_function PORT MAP(x_in => xg_in_temp_1, g_out => g_out_1);
    xf_in_temp_1 <= g_out_1 XOR X"4D71";
    f1: f_function PORT MAP(x_in => xf_in_temp_1, f_out => t1);

    -- t2 = f(g(t1 ⊕ k2) ⊕ 0F65)
    xg_in_temp_2 <= t1 XOR key(47 DOWNTO 32);
    g2: g_function PORT MAP(x_in => xg_in_temp_2, g_out => g_out_2);
    xf_in_temp_2 <= g_out_2 XOR X"0F65";
    f2: f_function PORT MAP(x_in => xf_in_temp_2, f_out => t2);

    -- t3 = f(g(t2 ⊕ k3) ⊕ 2746)
    xg_in_temp_3 <= t2 XOR key(31 DOWNTO 16);
    g3: g_function PORT MAP(x_in => xg_in_temp_3, g_out => g_out_3);
    xf_in_temp_3 <= g_out_3 XOR X"2746";
    f3: f_function PORT MAP(x_in => xf_in_temp_3, f_out => t3);

    -- t4 = f(g(t3 ⊕ k4) ⊕ 0B7C)
    xg_in_temp_4 <= t3 XOR key(15 DOWNTO 0);
    g4: g_function PORT MAP(x_in => xg_in_temp_4, g_out => g_out_4);
    xf_in_temp_4 <= g_out_4 XOR X"0B7C";
    f4: f_function PORT MAP(x_in => xf_in_temp_4, f_out => t4);

    -- t5 = f(g(t4 ⊕ k1) ⊕ CFD5)
    xg_in_temp_5 <= t4 XOR key(63 DOWNTO 48);
    g5: g_function PORT MAP(x_in => xg_in_temp_5, g_out => g_out_5);
    xf_in_temp_5 <= g_out_5 XOR X"CFD5";
    f5: f_function PORT MAP(x_in => xf_in_temp_5, f_out => t5);

    -- t6 = f(g(t5 ⊕ k3) ⊕ 8E45)
    xg_in_temp_6 <= t5 XOR key(31 DOWNTO 16);
    g6: g_function PORT MAP(x_in => xg_in_temp_6, g_out => g_out_6);
    xf_in_temp_6 <= g_out_6 XOR X"8E45";
    f6: f_function PORT MAP(x_in => xf_in_temp_6, f_out => t6);

    -- t7 = f(g(t6 ⊕ k2) ⊕ 40DA)
    xg_in_temp_7 <= t6 XOR key(47 DOWNTO 32);
    g7: g_function PORT MAP(x_in => xg_in_temp_7, g_out => g_out_7);
    xf_in_temp_7 <= g_out_7 XOR X"40DA";
    f7: f_function PORT MAP(x_in => xf_in_temp_7, f_out => t7);

    -- y = f(g(t7 ⊕ k4) ⊕ 62F0)
    xg_in_temp_8 <= t7 XOR key(15 DOWNTO 0);
    g8: g_function PORT MAP(x_in => xg_in_temp_8, g_out => g_out_8);
    xf_in_temp_8 <= g_out_8 XOR X"62F0";
    f8: f_function PORT MAP(x_in => xf_in_temp_8, f_out => t8);

    PROCESS(clk,rst)
    BEGIN

        IF rst = '1' THEN

            y_out <= (OTHERS => '0');

        ELSIF RISING_EDGE(clk) THEN

            y_out <= t8;

        END IF;
        
    END PROCESS;

END ARCHITECTURE Behavioral;
