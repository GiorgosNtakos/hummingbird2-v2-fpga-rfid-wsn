LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY f_function IS

    PORT(

        x_in   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- 16-bit είσοδος δεδομένων
        f_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- 16-bit έξοδος δεδομένων μετά την εφα�?μογή της συνά�?τησης f

    );

END ENTITY f_function;

ARCHITECTURE Behavioral OF f_function IS
BEGIN



            -- f(x) = (x << 2) AND NOT(x << 1) AND (x >> 1) XOR x
            f_out <= ((x_in ROL 2) AND NOT(x_in ROL 1) AND (x_in ROR 1)) XOR x_in;


END ARCHITECTURE Behavioral;