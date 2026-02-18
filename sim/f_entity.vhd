LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_f_function IS
END ENTITY tb_f_function;

ARCHITECTURE behavior OF tb_f_function IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT f_function

    PORT(

        clk    : IN  STD_LOGIC;
        rst    : IN  STD_LOGIC;
        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        f_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

    END COMPONENT;

    -- Signals for Stimuli
    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL rst    : STD_LOGIC := '0';
    SIGNAL x_in   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL f_out  : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: f_function PORT MAP (

        clk => clk,
        rst => rst,
        x_in => x_in,
        f_out => f_out

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

        -- Test vector 1
        x_in <= x"0000";
        WAIT FOR 20 ns;

        -- Test vector 2
        x_in <= x"5678";
        WAIT FOR 20 ns;

        -- Test vector 3
        x_in <= x"ABCD";
        WAIT FOR 20 ns;

        -- Test vector 4
        x_in <= x"FFFF";
        WAIT FOR 20 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
