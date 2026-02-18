LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_rolled_chi_nu IS
END ENTITY;

ARCHITECTURE behavior OF tb_rolled_chi_nu IS

    -- Signals for DUT (Device Under Test)
    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL rst    : STD_LOGIC := '0';
    SIGNAL x_in   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL key    : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL start  : STD_LOGIC := '0';
    SIGNAL done   : STD_LOGIC;
    SIGNAL y_out  : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period
    CONSTANT clk_period : TIME := 20 ns;

    -- Component Declaration
    COMPONENT rolled_chi_nu
    PORT(
        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        key    : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
        start  : IN  STD_LOGIC;
        done   : OUT STD_LOGIC;
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;

BEGIN

    -- DUT instance
    uut: rolled_chi_nu
        PORT MAP(
            clk    => clk,
            rst    => rst,
            x_in   => x_in,
            key    => key,
            start  => start,
            done   => done,
            y_out  => y_out
        );

    -- Clock generation process
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
        -- Initialize inputs
        rst <= '1';
        start <= '0';
        x_in <= (OTHERS => '0');
        key <= X"0123456789ABCDEF";
        WAIT FOR 20 ns;
        
        -- Release reset
        rst <= '0';
        WAIT FOR 20 ns;

        -- Apply test vector
        x_in <= X"0000";  -- Input x
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';

        -- Wait for done signal to be asserted
        WAIT UNTIL done = '1';

        -- Wait for 100 ns for the next test
        WAIT FOR 100 ns;

        -- Add additional test vectors if needed...

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
