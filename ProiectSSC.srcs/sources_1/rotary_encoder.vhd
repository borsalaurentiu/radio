library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rotary_encoder is
    Port ( Clk : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           FWD : out STD_LOGIC;
           REV : out STD_LOGIC);
end rotary_encoder;

architecture Behavioral of rotary_encoder is
signal code      : STD_LOGIC_VECTOR (1 downto 0) := B"00";
signal code_prev : STD_LOGIC_VECTOR (1 downto 0) := B"00";
 
begin

    process(Clk) is
    begin
       if (Clk'event and Clk = '1') then
          code_prev <= code;
          code(0)   <= A;
          code(1)   <= B;
          if (code(0) = '1' and code_prev(0) = '0') then -- A rising edge
              if (B = '0') then -- forward
                 FWD <= '1';
                 REV <= '0';
              elsif (B = '1') then -- reverse
                 FWD <= '0';
                 REV <= '1';
              end if;
          elsif (code(1) = '1' and code_prev(1) = '0') then -- B rising edge
              if (A = '1') then -- forward
                 FWD <= '1';
                 REV <= '0';
              elsif (A = '0') then -- reverse
                 FWD <= '0';
                 REV <= '1';
              end if;
          elsif (code(0) = '0' and code_prev(0) = '1') then -- A falling edge
              if (B = '1') then -- forward
                 FWD <= '1';
                 REV <= '0';
              elsif (B = '0') then -- reverse
                 FWD <= '0';
                 REV <= '1';
              end if;
          elsif (code(1) = '0' and code_prev(1) = '1') then -- B falling edge
              if (A = '0') then -- forward
                 FWD <= '1';
                 REV <= '0';
              elsif (A = '1') then -- reverse
                 FWD <= '0';
                 REV <= '1';
              end if;
          else
              FWD <= '0';
              REV <= '0';
          end if;
       end if;
    end process;
    
end Behavioral;