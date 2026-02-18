LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_rolled_Encryption_v2 IS
END ENTITY tb_rolled_Encryption_v2;

ARCHITECTURE behavior OF tb_rolled_Encryption_v2 IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT rolled_Encryption_v2
    PORT(
        clk            : IN  STD_LOGIC;
        rst            : IN  STD_LOGIC;
        pt_input       : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        R_i            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
        key            : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
        start_enc      : IN  STD_LOGIC;
        ct_output      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        R_o            : OUT STD_LOGIC_VECTOR (127 DOWNTO 0)
    );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk        : STD_LOGIC := '0';
    SIGNAL rst        : STD_LOGIC := '0';
    SIGNAL pt_input   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R_i        : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL start_enc  : STD_LOGIC;
    SIGNAL key        : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ct_output  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R_o        : STD_LOGIC_VECTOR(127 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 20 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT) (If we want to test the unrolled architecture then we use the entity: Encryption_v2)
    uut: rolled_Encryption_v2 PORT MAP (
        clk => clk,
        rst => rst,
        pt_input => pt_input,
        R_i => R_i,
        start_enc => start_enc,
        key => key,
        ct_output => ct_output,
        R_o => R_o
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Reset the system
        rst <= '1';
        WAIT FOR 20 ns;
        rst <= '0';

        -- Apply the key
        key <= X"23016745AB89EFCDDCFE98BA54761032";

        -- Apply test vectors for R1-R8 from IV = 12 34 56 78 9A BC DE F0
        R_i <= X"1E79BF559C6DB22F1D82F9E2A6C8F577";

        -- Apply plaintext blocks from PT = 00 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF
        pt_input <= x"1100"; 
        start_enc <= '1';
        WAIT FOR clk_period;
        start_enc <= '0';


        -- Check the ciphertext output (expected: 63 66 F6 CB 60 0F A4 CE 52 78 D8 A8 5B 39 E2 B3)
        -- Example of checking the first part of the ciphertext
        assert ct_output = x"6663" report "Ciphertext mismatch in the first block!" severity error;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
