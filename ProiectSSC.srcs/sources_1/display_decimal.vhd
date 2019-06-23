library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity display_decimal is
  Port ( D_in  : in  STD_LOGIC_VECTOR (31 downto 0);
         Q_out : out STD_LOGIC_VECTOR (31 downto 0));
end display_decimal;

architecture Behavioral of display_decimal is
signal NumarIntreg : integer := 0;
signal NumarVector : STD_LOGIC_VECTOR (31 downto 0);

begin

    Q_out       <= NumarVector;
    NumarIntreg <= conv_integer(D_in);
    
    NumarVector(3 downto 0)   <= conv_std_logic_vector((NumarIntreg mod 10) / 1, 4);
    NumarVector(7 downto 4)   <= conv_std_logic_vector((NumarIntreg mod 100) / 10, 4);
    NumarVector(11 downto 8)  <= conv_std_logic_vector((NumarIntreg mod 1000) / 100, 4);
    NumarVector(15 downto 12) <= conv_std_logic_vector((NumarIntreg mod 10000) / 1000, 4);
    NumarVector(31 downto 16) <= x"FFFF";

end Behavioral;
