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

begin
    shamt <= to_integer(unsigned(b(4 downto 0)));
    slt_s <= X"00000001" when signed(a) < signed(b) else X"00000000";
    slt_u <= X"00000001" when unsigned(a) < unsigned(b) else X"00000000";
    
    with ALUControl select
        res <= std_logic_vector(unsigned(a) + unsigned(b))    when "0000",
            std_logic_vector(unsigned(a) - unsigned(b))       when "0001",
            std_logic_vector(shift_left(unsigned(a), shamt))  when "0010",
            slt_s                                             when "0011",
            slt_u                                             when "0100",
            a xor b                                           when "0101",
            std_logic_vector(shift_right(signed(a), shamt))   when "0110",
            std_logic_vector(shift_right(unsigned(a), shamt)) when "0111",
            a or b                                            when "1000",
            a and b                                           when "1001",
            (others => '0')                                   when others;

    result <= res;
    zero   <= '1' when res = X"00000000" else '0';
end;
