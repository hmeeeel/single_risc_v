library ieee;
use ieee.std_logic_1164.all;

entity decoder is
    port (
    immsrc, resSrc : out std_logic_vector(1 downto 0);
    aluA, aluB, MemWr, RegWr, PCSrc : out  std_logic;
    op : in std_logic_vector (6 downto 0));
end;

architecture beh of decoder is
begin

    process(op)
    variable res : std_logic_vector(8 downto 0);
    begin
        case op is

        -- LW
        --when "0000011" => res := "100001010";
        when "0000011" => res := '1' & '0' & "00" & '0' & '1' & "01" & '0';

        --SW
        when "0100011" => res := '0' & '1' & "01" & '0' & '1' & "--" & '0';

        --LUI
        when "0110111" => res := '1' & '0' & "10" & '1' & '1' & "00" & '0';

        --JAL
        when "1101111" => res := '1' & '0' & "11" & '-' & '-' & "10" & '1';
        
        when others => res := "---------";

        end case;

        RegWr <= res(8);
        MemWr <= res(7);
        immsrc <= res(6 downto 5);
        aluA <= res(4);
        aluB <= res(3);
        resSrc <= res(2 downto 1);
        PCsrc <= res(0);

    end process;
end;