-- Testbench for rolled_Encryption_pipeline_v2
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_encryption_pipeline IS
END ENTITY;

ARCHITECTURE behavior OF tb_encryption_pipeline IS

    COMPONENT rolled_Encryption_pipeline_v2
        PORT(
            clk        : IN  STD_LOGIC;
            rst        : IN  STD_LOGIC;
            pt_input   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            R_i        : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
            key        : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
            start_enc  : IN  STD_LOGIC;
            ct_output  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            R_o        : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk        : STD_LOGIC := '0';
    SIGNAL rst        : STD_LOGIC := '1';
    SIGNAL pt_input   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R_i        : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL key        : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL start_enc  : STD_LOGIC := '0';
    SIGNAL ct_output  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R_o        : STD_LOGIC_VECTOR(127 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

    -- Test Vectors (KEY, IV, PT, CT)
    CONSTANT test_key     : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"23016745AB89EFCDDCFE98BA54761032";
    CONSTANT test_pt      : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"1100";
    CONSTANT expected_ct  : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"6663CBF60F60CEA47852A8D8395BB3E2";

BEGIN
    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Instantiate the encryption module
    uut: rolled_Encryption_pipeline_v2
        PORT MAP (
            clk        => clk,
            rst        => rst,
            pt_input   => pt_input,
            R_i        => R_i,
            key        => key,
            start_enc  => start_enc,
            ct_output  => ct_output,
            R_o        => R_o
        );

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Reset
        WAIT FOR 20 ns;
        rst <= '0';

        -- Test vector 1
        pt_input <= test_pt; -- plaintext input
        R_i <= X"1E79BF559C6DB22F1D82F9E2A6C8F577";      -- IV used as the initial R_i state
        key <= test_key;     -- encryption key
        start_enc <= '1';
        WAIT FOR clk_period;
        start_enc <= '0';

        -- End simulation*/
        WAIT;
    END PROCESS;

END ARCHITECTURE;
