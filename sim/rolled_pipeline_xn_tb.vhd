-- Testbench for rolled_pipeline_chi_nu
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_rolled_pipeline_chi_nu IS
END ENTITY;

ARCHITECTURE behavior OF tb_rolled_pipeline_chi_nu IS

    COMPONENT rolled_pipeline_chi_nu
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

    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL rst     : STD_LOGIC := '1';
    SIGNAL x_in    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL key     : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL start   : STD_LOGIC := '0';
    SIGNAL done    : STD_LOGIC;
    SIGNAL y_out   : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

    SIGNAL cycle_counter : INTEGER := 0;

BEGIN
    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Unit under test
    uut: rolled_pipeline_chi_nu
        PORT MAP (
            clk   => clk,
            rst   => rst,
            x_in  => x_in,
            key   => key,
            start => start,
            done  => done,
            y_out => y_out
        );

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initial reset
        WAIT FOR 20 ns;
        rst <= '0';

        -- Test vector 1
        x_in <= x"0000";
        key <= x"0123456789ABCDEF";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        cycle_counter <= 0;
        WHILE y_out /= x"3286" LOOP
            WAIT UNTIL rising_edge(clk);
            cycle_counter <= cycle_counter + 1;
        END LOOP;
        REPORT "Encryption completed in " & INTEGER'image(cycle_counter) & " cycles";
        WAIT UNTIL done = '1';
        --WAIT FOR clk_period;

       /* -- Test vector 2
        x_in <= x"1234";
        key <= x"5555555555555555";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT UNTIL done = '1';
        WAIT FOR clk_period;

        -- Test vector 3
        x_in <= x"0000";
        key <= x"0123456789ABCDEF";
        start <= '1';
        WAIT FOR clk_period;
        start <= '0';
        WAIT UNTIL done = '1';
        WAIT FOR clk_period;

        -- Finish simulation*/
        WAIT;
    END PROCESS;

END ARCHITECTURE;
