LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY g_function IS

    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        g_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- 16-bit έξοδος δεδομένων μετά την εφα�?μογή της συνά�?τησης g

    );

END ENTITY g_function;

ARCHITECTURE Behavioral OF g_function IS
BEGIN

           
            -- g(x) = NOT(x) AND (x << 4) AND NOT(x << 12) XOR (x << 8)

            g_out <= ((x_in NOR (x_in ROL 12)) AND (x_in ROL 4)) XOR (x_in ROL 8);

END ARCHITECTURE Behavioral;
