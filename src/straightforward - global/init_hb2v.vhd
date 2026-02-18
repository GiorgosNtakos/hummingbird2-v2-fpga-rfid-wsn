-- This entity defines the initialization process in the cryptographic algorithm.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Initialization_v2 IS

	PORT(

		clk 		   : IN  STD_LOGIC; -- Clock signal
		rst		       : IN  STD_LOGIC; -- Reset signal (active high)
		iv    		   : IN  STD_LOGIC_VECTOR ( 63  DOWNTO 0); -- Initialization vector (64 bits)
		key 		   : IN  STD_LOGIC_VECTOR (127  DOWNTO 0); -- Secret key (128 bits)
		R1             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R2             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R3             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R4             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R5             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R6             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R7             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0); -- Output of the initialization
        R8             : OUT STD_LOGIC_VECTOR (15  DOWNTO 0) -- Output of the initialization

	);

END Initialization_v2;

ARCHITECTURE Behavioral OF Initialization_v2 IS


-- Signals to hold intermediate and pipeline results during initialization
    SIGNAL R1_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R5_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R6_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R7_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R8_in     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL R1_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R5_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R6_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R7_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R8_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL R1_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R5_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R6_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R7_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R8_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL R1_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R5_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R6_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R7_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R8_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL R1_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R5_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R6_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R7_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R8_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL R1_rnd_1_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_1_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_1_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_1_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R1_rnd_2_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_2_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_2_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_2_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R1_rnd_3_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_3_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_3_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_3_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R1_rnd_4_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R2_rnd_4_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R3_rnd_4_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL R4_rnd_4_temp     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL y1_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y2_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y3_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y4_rnd_1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y1_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y2_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y3_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y4_rnd_2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y1_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y2_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y3_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y4_rnd_3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y1_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y2_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y3_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL y4_rnd_4     : STD_LOGIC_VECTOR (15  DOWNTO 0);

    SIGNAL K1     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K2     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K3     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K4     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K5     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K6     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K7     : STD_LOGIC_VECTOR (15  DOWNTO 0);
    SIGNAL K8     : STD_LOGIC_VECTOR (15  DOWNTO 0);

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

BEGIN

    R1_in <= iv(63 DOWNTO 48);
    R2_in <= iv(47 DOWNTO 32);
    R3_in <= iv(31 DOWNTO 16);    
    R4_in <= iv(15 DOWNTO  0);
    R5_in <= iv(63 DOWNTO 48);
    R6_in <= iv(47 DOWNTO 32);
    R7_in <= iv(31 DOWNTO 16);    
    R8_in <= iv(15 DOWNTO  0);

    K1 <= key(127 DOWNTO 112); 
    K2 <= key(111 DOWNTO  96); 
    K3 <= key( 95 DOWNTO  80); 
    K4 <= key( 79 DOWNTO  64); 
    K5 <= key( 63 DOWNTO  48); 
    K6 <= key( 47 DOWNTO  32); 
    K7 <= key( 31 DOWNTO  16); 
    K8 <= key( 15 DOWNTO   0);
    
    --ROUND 1
    y1_r1: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R1_in) + UNSIGNED(TO_UNSIGNED(0, 16))) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y1_rnd_1);
    y2_r1: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R2_in) + UNSIGNED(y1_rnd_1)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y2_rnd_1);
    y3_r1: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R3_in) + UNSIGNED(y2_rnd_1)) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y3_rnd_1);
    y4_r1: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R4_in) + UNSIGNED(y3_rnd_1)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y4_rnd_1);

    --ROUND 2
    y1_r2: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_1) + UNSIGNED(TO_UNSIGNED(1, 16))) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y1_rnd_2);
    y2_r2: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_1) + UNSIGNED(y1_rnd_2)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y2_rnd_2);
    y3_r2: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_1) + UNSIGNED(y2_rnd_2)) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y3_rnd_2);
    y4_r2: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_1) + UNSIGNED(y3_rnd_2)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y4_rnd_2);

    --ROUND 3
    y1_r3: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_2) + UNSIGNED(TO_UNSIGNED(2, 16))) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y1_rnd_3);
    y2_r3: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_2) + UNSIGNED(y1_rnd_3)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y2_rnd_3);
    y3_r3: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_2) + UNSIGNED(y2_rnd_3)) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y3_rnd_3);
    y4_r3: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_2) + UNSIGNED(y3_rnd_3)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y4_rnd_3);

    --ROUND 4
    y1_r4: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_3) + UNSIGNED(TO_UNSIGNED(3, 16))) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y1_rnd_4);
    y2_r4: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_3) + UNSIGNED(y1_rnd_4)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y2_rnd_4);
    y3_r4: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_3) + UNSIGNED(y2_rnd_4)) MOD 65536)), k1 => K1, k2 => K2, k3 => K3, k4 => K4, y_out => y3_rnd_4);
    y4_r4: chi_nu PORT MAP(clk => clk, rst => rst, x_in => (STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_3) + UNSIGNED(y3_rnd_4)) MOD 65536)), k1 => K5, k2 => K6, k3 => K7, k4 => K8, y_out => y4_rnd_4);

    --ROUND 1 calculate R1-R8 for ROUND 2 
    R1_rnd_1_temp <= STD_LOGIC_VECTOR((UNSIGNED(R1_in) + UNSIGNED(y4_rnd_1))MOD 65536);
    R2_rnd_1_temp <= STD_LOGIC_VECTOR((UNSIGNED(R2_in) + UNSIGNED(y1_rnd_1))MOD 65536);
    R3_rnd_1_temp <= STD_LOGIC_VECTOR((UNSIGNED(R3_in) + UNSIGNED(y2_rnd_1))MOD 65536);
    R4_rnd_1_temp <= STD_LOGIC_VECTOR((UNSIGNED(R4_in) + UNSIGNED(y3_rnd_1))MOD 65536);
    R1_rnd_1 <= R1_rnd_1_temp(12 DOWNTO 0) & R1_rnd_1_temp(15 DOWNTO 13);
    R2_rnd_1 <= R2_rnd_1_temp(0) & R2_rnd_1_temp(15 DOWNTO 1);
    R3_rnd_1 <= R3_rnd_1_temp(7 DOWNTO 0) & R3_rnd_1_temp(15 DOWNTO 8);
    R4_rnd_1 <= R4_rnd_1_temp(14 DOWNTO 0) & R4_rnd_1_temp(15);
    R5_rnd_1 <= R5_in XOR R1_rnd_1;
    R6_rnd_1 <= R6_in XOR R2_rnd_1;
    R7_rnd_1 <= R7_in XOR R3_rnd_1;
    R8_rnd_1 <= R8_in XOR R4_rnd_1;

    --ROUND 2 calculate R1-R8 for ROUND 3 
    R1_rnd_2_temp <= STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_1) + UNSIGNED(y4_rnd_2))MOD 65536);
    R2_rnd_2_temp <= STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_1) + UNSIGNED(y1_rnd_2))MOD 65536);
    R3_rnd_2_temp <= STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_1) + UNSIGNED(y2_rnd_2))MOD 65536);
    R4_rnd_2_temp <= STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_1) + UNSIGNED(y3_rnd_2))MOD 65536);
    R1_rnd_2 <= R1_rnd_2_temp(12 DOWNTO 0) & R1_rnd_2_temp(15 DOWNTO 13);
    R2_rnd_2 <= R2_rnd_2_temp(0) & R2_rnd_2_temp(15 DOWNTO 1);
    R3_rnd_2 <= R3_rnd_2_temp(7 DOWNTO 0) & R3_rnd_2_temp(15 DOWNTO 8);
    R4_rnd_2 <= R4_rnd_2_temp(14 DOWNTO 0) & R4_rnd_2_temp(15);
    R5_rnd_2 <= R5_rnd_1 XOR R1_rnd_2;
    R6_rnd_2 <= R6_rnd_1 XOR R2_rnd_2;
    R7_rnd_2 <= R7_rnd_1 XOR R3_rnd_2;
    R8_rnd_2 <= R8_rnd_1 XOR R4_rnd_2;

    --ROUND 3 calculate R1-R8 for ROUND 4 
    R1_rnd_3_temp <= STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_2) + UNSIGNED(y4_rnd_3))MOD 65536);
    R2_rnd_3_temp <= STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_2) + UNSIGNED(y1_rnd_3))MOD 65536);
    R3_rnd_3_temp <= STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_2) + UNSIGNED(y2_rnd_3))MOD 65536);
    R4_rnd_3_temp <= STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_2) + UNSIGNED(y3_rnd_3))MOD 65536);
    R1_rnd_3 <= R1_rnd_3_temp(12 DOWNTO 0) & R1_rnd_3_temp(15 DOWNTO 13);
    R2_rnd_3 <= R2_rnd_3_temp(0) & R2_rnd_3_temp(15 DOWNTO 1);
    R3_rnd_3 <= R3_rnd_3_temp(7 DOWNTO 0) & R3_rnd_3_temp(15 DOWNTO 8);
    R4_rnd_3 <= R4_rnd_3_temp(14 DOWNTO 0) & R4_rnd_3_temp(15);
    R5_rnd_3 <= R5_rnd_2 XOR R1_rnd_3;
    R6_rnd_3 <= R6_rnd_2 XOR R2_rnd_3;
    R7_rnd_3 <= R7_rnd_2 XOR R3_rnd_3;
    R8_rnd_3 <= R8_rnd_2 XOR R4_rnd_3;

    --ROUND 4 calculate R1-R8 for initialization
    R1_rnd_4_temp <= STD_LOGIC_VECTOR((UNSIGNED(R1_rnd_3) + UNSIGNED(y4_rnd_4))MOD 65536);
    R2_rnd_4_temp <= STD_LOGIC_VECTOR((UNSIGNED(R2_rnd_3) + UNSIGNED(y1_rnd_4))MOD 65536);
    R3_rnd_4_temp <= STD_LOGIC_VECTOR((UNSIGNED(R3_rnd_3) + UNSIGNED(y2_rnd_4))MOD 65536);
    R4_rnd_4_temp <= STD_LOGIC_VECTOR((UNSIGNED(R4_rnd_3) + UNSIGNED(y3_rnd_4))MOD 65536);
    R1_rnd_4 <= R1_rnd_4_temp(12 DOWNTO 0) & R1_rnd_4_temp(15 DOWNTO 13);
    R2_rnd_4 <= R2_rnd_4_temp(0) & R2_rnd_4_temp(15 DOWNTO 1);
    R3_rnd_4 <= R3_rnd_4_temp(7 DOWNTO 0) & R3_rnd_4_temp(15 DOWNTO 8);
    R4_rnd_4 <= R4_rnd_4_temp(14 DOWNTO 0) & R4_rnd_4_temp(15);
    R5_rnd_4 <= R5_rnd_3 XOR R1_rnd_4;
    R6_rnd_4 <= R6_rnd_3 XOR R2_rnd_4;
    R7_rnd_4 <= R7_rnd_3 XOR R3_rnd_4;
    R8_rnd_4 <= R8_rnd_3 XOR R4_rnd_4;

    R1 <= R1_rnd_4; 
    R2 <= R2_rnd_4;    
    R3 <= R3_rnd_4;
    R4 <= R4_rnd_4;
    R5 <= R5_rnd_4;
    R6 <= R6_rnd_4;
    R7 <= R7_rnd_4;
    R8 <= R8_rnd_4;    

END ARCHITECTURE Behavioral;