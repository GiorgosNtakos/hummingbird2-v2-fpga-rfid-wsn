-- This module handles the encryption process using a block cipher.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY rolled_Encryption_pipeline_v2 IS
PORT(

    clk            : IN  STD_LOGIC; -- Clock signal
    rst            : IN  STD_LOGIC; -- Reset signal (active high)
    pt_input       : IN  STD_LOGIC_VECTOR ( 15 DOWNTO 0); -- 16-bit plaintext input
    R_i            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0); -- 15-bit R1 internal state
    key            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0); -- 128-bit key
    start_enc      : IN  STD_LOGIC;
    ct_output      : OUT STD_LOGIC_VECTOR ( 15 DOWNTO 0); -- 16-bit ciphertext output
    R_o            : OUT STD_LOGIC_VECTOR (127 DOWNTO 0) -- 15-bit R1 internal state output

);

END rolled_Encryption_pipeline_v2;

ARCHITECTURE Behavioral OF rolled_Encryption_pipeline_v2 IS

-- Signals for wd_16 inputs, outputs, and intermediate results
    SIGNAL y1, y2, y3, y4       :                       STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL KxR_1, KxR_2         : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAl done_1, done_2, done_3, done_4 : STD_LOGIC;

    SIGNAL R1_temp : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_temp : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_temp : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_temp : STD_LOGIC_VECTOR (15  DOWNTO 0);
    

    SIGNAL xn_input_1, xn_input_2, xn_input_3, xn_input_4 : STD_LOGIC_VECTOR (15  DOWNTO 0);

    COMPONENT rolled_pipeline_chi_nu

    PORT(

        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        start  : IN  STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        done   : OUT STD_LOGIC

    );

    END COMPONENT;


    BEGIN

        KxR_1 <= key(63 DOWNTO 0) XOR R_i(63 DOWNTO 0);


        KxR_2 <= key(127 DOWNTO 64) XOR R_i(63 DOWNTO 0);


        xn_input_1 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(pt_input)) MOD 65536);
        y1_out: rolled_pipeline_chi_nu PORT MAP(clk => clk, rst => rst, start => start_enc, x_in => xn_input_1, key => key(127 DOWNTO 64), y_out => y1, done => done_1);

        xn_input_2 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(111 DOWNTO 96)) + UNSIGNED(y1)) MOD 65536);
        y2_out: rolled_pipeline_chi_nu PORT MAP(clk => clk, rst => rst, start => done_1, x_in => xn_input_2, key => KxR_1, y_out => y2, done => done_2);

        xn_input_3 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(95 DOWNTO 80)) + UNSIGNED(y2)) MOD 65536);
        y3_out: rolled_pipeline_chi_nu PORT MAP(clk => clk, rst => rst, start => done_2, x_in => xn_input_3, key => KxR_2, y_out => y3, done => done_3);

        xn_input_4 <= STD_LOGIC_VECTOR((UNSIGNED(R_i(79 DOWNTO 64)) + UNSIGNED(y3)) MOD 65536);
        y4_out: rolled_pipeline_chi_nu PORT MAP(clk => clk, rst => rst, start => done_3, x_in => xn_input_4, key => key(63 DOWNTO 0), y_out => y4, done => done_4);

        R1_temp <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(y3)) MOD 65536);
        R2_temp <= STD_LOGIC_VECTOR((UNSIGNED(R_i(111 DOWNTO 96)) + UNSIGNED(y1)) MOD 65536);
        R3_temp <= STD_LOGIC_VECTOR((UNSIGNED(R_i(95 DOWNTO 80)) + UNSIGNED(y2)) MOD 65536);
        R4_temp <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(R_i(79 DOWNTO 64)) + UNSIGNED(y1) + UNSIGNED(y3)) MOD 65536);
        R_o(127 DOWNTO 112) <= R1_temp;
        R_o(111 DOWNTO  96) <= R2_temp;
        R_o( 95 DOWNTO  80) <= R3_temp;
        R_o( 79 DOWNTO  64) <= R4_temp;
        R_o( 63 DOWNTO  48) <= R_i( 63 DOWNTO  48) XOR R1_temp; 
        R_o( 47 DOWNTO  32) <= R_i( 47 DOWNTO  32) XOR R2_temp; 
        R_o( 31 DOWNTO  16) <= R_i( 31 DOWNTO  16) XOR R3_temp; 
        R_o( 15 DOWNTO   0) <= R_i( 15 DOWNTO   0) XOR R4_temp;
        
        ct_output <= STD_LOGIC_VECTOR((UNSIGNED(R_i(127 DOWNTO 112)) + UNSIGNED(y4)) MOD 65536);
        
END Behavioral;