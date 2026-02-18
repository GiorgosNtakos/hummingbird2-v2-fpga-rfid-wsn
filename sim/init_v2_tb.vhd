LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_Initialization_v2 IS
END ENTITY tb_Initialization_v2;

ARCHITECTURE behavior OF tb_Initialization_v2 IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT Initialization_v2
    PORT(
        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        iv     : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
        key    : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
        R1     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R2     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R3     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R4     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R5     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R6     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R7     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        R8     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL rst    : STD_LOGIC := '0';
    SIGNAL iv     : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL key    : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R1     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R2     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R3     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R4     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R5     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R6     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R7     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL R8     : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: Initialization_v2 PORT MAP (
        clk => clk,
        rst => rst,
        iv => iv,
        key => key,
        R1 => R1,
        R2 => R2,
        R3 => R3,
        R4 => R4,
        R5 => R5,
        R6 => R6,
        R7 => R7,
        R8 => R8
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

        -- Apply test vectors
        -- KEY = 01 23 45 67 89 AB CD EF FE DC BA 98 76 54 32 10
        -- IV  = 12 34 56 78 9A BC DE F0
        iv <= X"34127856BC9AF0DE";
        key <= X"23016745AB89EFCDDCFE98BA54761032";

        -- Wait for a few clock cycles for initialization to complete

        -- Check the output values (optional, compare with expected values if available)
        -- Expected values would typically be verified here using assert statements
        -- Example (if you know the expected output for R1):
        -- assert R1 = x"expected_value" report "R1 mismatch!" severity error;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
