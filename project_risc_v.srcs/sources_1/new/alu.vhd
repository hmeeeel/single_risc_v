library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (a, b : in  std_logic_vector(31 downto 0);
          ALUControl : in  std_logic_vector(3 downto 0);
          result : out std_logic_vector(31 downto 0);
          zero : out std_logic);
end;

architecture beh of alu is
    signal shamt : integer range 0 to 31;
    signal res: std_logic_vector(31 downto 0);
    signal slt_s, slt_u : std_logic_vector(31 downto 0);
   -- constant ALU_TRUE : std_logic_vector(31 downto 0) := X"00000001";
   -- constant ALU_FALSE : std_logic_vector(31 downto 0) := X"00000000";
begin
    shamt <= to_integer(unsigned(b(4 downto 0)));
    slt_s <= X"00000001" when signed(a) < signed(b) else X"00000000";
    slt_u <= X"00000001" when unsigned(a) < unsigned(b) else X"00000000";
    
    process(a, b, ALUControl, shamt, slt_s, slt_u)
    begin
        case ALUControl is
            when "0000" => res <= std_logic_vector(unsigned(a) + unsigned(b));
            when "0001" => res <= std_logic_vector(unsigned(a) - unsigned(b));
            when "0010" => res <= std_logic_vector(shift_left(unsigned(a), shamt));
            when "0011" => res <= slt_s;
            when "0100" => res <= slt_u;
            when "0101" => res <= a xor b;
            when "0110" => res <= std_logic_vector(shift_right(signed(a), shamt));
            when "0111" => res <= std_logic_vector(shift_right(unsigned(a), shamt));
            when "1000" => res <= a or b;
            when "1001" => res <= a and b;
            when others => res <= (others => '0');
        end case;
    end process;

    result <= res;
    zero   <= '1' when res = X"00000000" else '0';
end;
