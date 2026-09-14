library ieee;
use ieee.std_logic_1164.all;

entity alu_decoder is
    port (funct3 : in  std_logic_vector(2 downto 0);
          funct7b5, op5 : in  std_logic;
          ALUOp : in  std_logic_vector(1 downto 0);
          ALUControl : out std_logic_vector(3 downto 0));
end;

architecture beh of alu_decoder is
    signal sub_case : std_logic;
begin
    sub_case <= funct7b5 and op5;

    process(funct3, sub_case, funct7b5, ALUOp)
    begin
        case ALUOp is

            when "00" => ALUControl <= "0000";  -- add

            when "10" =>
                case funct3 is
                    when "000" =>
                        if sub_case = '1' then ALUControl <= "0001";  -- sub
                        else                   ALUControl <= "0000";  -- add / addi
                        end if;
                    when "001" => ALUControl <= "0010";  -- sll
                    when "010" => ALUControl <= "0011";  -- slt
                    when "011" => ALUControl <= "0100";  -- sltu
                    when "100" => ALUControl <= "0101";  -- xor
                    when "101" =>
                        if funct7b5 = '1' then ALUControl <= "0110";  -- sra
                        else                    ALUControl <= "0111";  -- srl
                        end if;
                    when "110" => ALUControl <= "1000";  -- or
                    when "111" => ALUControl <= "1001";  -- and
                    when others => ALUControl <= "0000";
                end case;

            when "01" =>
                if funct3(2) = '0' then
                    ALUControl <= "0001";  -- sub, beq/bne
                elsif funct3(1) = '0' then
                    ALUControl <= "0011";  -- slt, blt/bge
                else
                    ALUControl <= "0100";  -- sltu, bltu/bgeu
                end if;

            when others => ALUControl <= "0000";
        end case;
    end process;
end;
