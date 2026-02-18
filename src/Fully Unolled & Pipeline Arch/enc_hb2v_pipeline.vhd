-- This module handles the encryption process using a block cipher.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Encryption_v2_pipeline IS
PORT(

    clk            : IN  STD_LOGIC; -- Clock signal
    rst            : IN  STD_LOGIC; -- Reset signal (active high)
    pt_input       : IN  STD_LOGIC_VECTOR ( 15 DOWNTO 0); -- 16-bit plaintext input
    R_i            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0); -- 15-bit R1 internal state
    key            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0); -- 128-bit key
    ct_output      : OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0); -- 16-bit ciphertext output
    R_o            : OUT STD_LOGIC_VECTOR (127 DOWNTO 0) -- 15-bit R1 internal state output

);

END Encryption_v2_pipeline;

ARCHITECTURE Behavioral OF Encryption_v2_pipeline IS

-- Signals for wd_16 inputs, outputs, and intermediate results
    SIGNAL y1, y2, y3, y4       :                       STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL KxR_1, KxR_2         : STD_LOGIC_VECTOR(63 DOWNTO 0);

    SIGNAL add_result1, add_result2, add_result3, add_result4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mod_result1, mod_result2, mod_result3, mod_result4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    

    SIGNAL xn_input_1, xn_input_2, xn_input_3, xn_input_4 : STD_LOGIC_VECTOR (15  DOWNTO 0);

    COMPONENT chi_nu_pipeline

    PORT(

        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

    END COMPONENT;


    BEGIN

        KxR_1 <= key(63 DOWNTO 0) XOR R_i(63 DOWNTO 0);


        KxR_2 <= key(127 DOWNTO 64) XOR R_i(63 DOWNTO 0);

        -- Process to handle wd_input signals based on R_input and plaintext input
        process_reg_wd_inputs : PROCESS(clk, rst)
        BEGIN
            
            IF rst = '1' THEN
    -- Reset all wd_input values on reset

                xn_input_1    <= (OTHERS => '0');
                xn_input_2    <= (OTHERS => '0');
                xn_input_3    <= (OTHERS => '0');
                xn_input_4    <= (OTHERS => '0');
                

            ELSIF RISING_EDGE(clk) THEN
    -- Calculate wd_input values using R_input and t outputs

                        xn_input_1 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(pt_input)) MOD 65536);
                        xn_input_2 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(111 DOWNTO  96)) + UNSIGNED(y1)) MOD 65536);
                        xn_input_3 <= STD_LOGIC_VECTOR((UNSIGNED(R_i( 95 DOWNTO  80)) + UNSIGNED(y2)) MOD 65536);
                        xn_input_4 <= STD_LOGIC_VECTOR((UNSIGNED(R_i( 79 DOWNTO  64)) + UNSIGNED(y3)) MOD 65536);

            END IF;

        END PROCESS;


        --xn_input_1 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(pt_input)) MOD 65536);
        y1_out: chi_nu_pipeline PORT MAP(clk => clk, rst => rst, x_in => xn_input_1, key => key(127 DOWNTO 64), y_out => y1);

        --xn_input_2 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(111 DOWNTO 96)) + UNSIGNED(y1)) MOD 65536);
        y2_out: chi_nu_pipeline PORT MAP(clk => clk, rst => rst, x_in => xn_input_2, key => KxR_1, y_out => y2);

        --xn_input_3 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(95 DOWNTO 80)) + UNSIGNED(y2)) MOD 65536);
        y3_out: chi_nu_pipeline PORT MAP(clk => clk, rst => rst, x_in => xn_input_3, key => KxR_2, y_out => y3);

        --xn_input_4 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(79 DOWNTO 64)) + UNSIGNED(y3)) MOD 65536);
        y4_out: chi_nu_pipeline PORT MAP(clk => clk, rst => rst, x_in => xn_input_4, key => key(63 DOWNTO 0), y_out => y4);

        process_additions : PROCESS(clk, rst)
        BEGIN

            IF rst = '1' THEN
 -- Reset addition results on reset

                add_result1 <= (OTHERS => '0');
                add_result2 <= (OTHERS => '0');
                add_result3 <= (OTHERS => '0');
                add_result4 <= (OTHERS => '0');

                mod_result1 <= (OTHERS => '0');
                mod_result2 <= (OTHERS => '0');
                mod_result3 <= (OTHERS => '0');
                mod_result4 <= (OTHERS => '0');

            ELSIF RISING_EDGE(clk) THEN
-- Perform addition operations for each R_input segment and t outputs

                add_result1 <= STD_LOGIC_VECTOR(UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(y3));
                add_result2 <= STD_LOGIC_VECTOR(UNSIGNED(R_i(111 DOWNTO 96)) + UNSIGNED(y1));
                add_result3 <= STD_LOGIC_VECTOR(UNSIGNED(R_i(95 DOWNTO 80)) + UNSIGNED(y2));
                add_result4 <= STD_LOGIC_VECTOR(UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(R_i(79 DOWNTO 64)) + UNSIGNED(y1) + UNSIGNED(y3));

                mod_result1 <= STD_LOGIC_VECTOR(UNSIGNED(add_result1) MOD 65536);
                mod_result2 <= STD_LOGIC_VECTOR(UNSIGNED(add_result2) MOD 65536);
                mod_result3 <= STD_LOGIC_VECTOR(UNSIGNED(add_result3) MOD 65536);
                mod_result4 <= STD_LOGIC_VECTOR(UNSIGNED(add_result4) MOD 65536);

            END IF;

        END PROCESS;

        R_o(127 DOWNTO 112) <= mod_result1;
        R_o(111 DOWNTO  96) <= mod_result2;
        R_o( 95 DOWNTO  80) <= mod_result3;
        R_o( 79 DOWNTO  64) <= mod_result4;

        R_o( 63 DOWNTO  48) <= R_i( 63 DOWNTO  48) XOR mod_result1; 
        R_o( 47 DOWNTO  32) <= R_i( 47 DOWNTO  32) XOR mod_result2; 
        R_o( 31 DOWNTO  16) <= R_i( 31 DOWNTO  16) XOR mod_result3; 
        R_o( 15 DOWNTO   0) <= R_i( 15 DOWNTO   0) XOR mod_result4;
        
        ct_output <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(y4)) MOD 65536);
        
END Behavioral;