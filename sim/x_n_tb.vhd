LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_chi_nu IS
END ENTITY tb_chi_nu;

ARCHITECTURE behavior OF tb_chi_nu IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT chi_nu

    PORT(

        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        k1     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        k2     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        k3     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        k4     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        y_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

    END COMPONENT;

    -- Signals for Stimuli
    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL rst    : STD_LOGIC := '0';
    SIGNAL x_in   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL k1     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL k2     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL k3     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL k4     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y_out  : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: chi_nu PORT MAP (

        clk => clk,
        rst => rst,
        x_in => x_in,
        k1 => k1,
        k2 => k2,
        k3 => k3,
        k4 => k4,
        y_out => y_out

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

        -- Apply first test vector: χν(0000, 0000, 0000, 0000, 0000) = FECB
        x_in <= x"0000";
        k1 <= x"0000";
        k2 <= x"0000";
        k3 <= x"0000";
        k4 <= x"0000";
        WAIT FOR 16*clk_period;

        -- Check the result (expected: FECB)
        assert y_out = x"FECB"
        report "Test vector 1 failed"
        severity error;

        -- Apply second test vector: χν(1234, 5555, 5555, 5555, 5555) = 18E6
        x_in <= x"1234";
        k1 <= x"5555";
        k2 <= x"5555";
        k3 <= x"5555";
        k4 <= x"5555";
        WAIT FOR 16*clk_period;

        -- Check the result (expected: 18E6)
        assert y_out = x"18E6"
        report "Test vector 2 failed"
        severity error;

        -- Apply third test vector: χν(0000, 0123, 4567, 89AB, CDEF) = 3286
        x_in <= x"0000";
        k1 <= x"0123";
        k2 <= x"4567";
        k3 <= x"89AB";
        k4 <= x"CDEF";
        WAIT FOR 16*clk_period;

        -- Check the result (expected: 3286)
        assert y_out = x"3286"
        report "Test vector 3 failed"
        severity error;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
