library ieee;
use ieee.std_logic_1164.all;

entity main_decoder is
    port (op : in  std_logic_vector(6 downto 0);
          RegWrite, MemWrite, ALUSrcB : out std_logic;
          ImmSrc : out std_logic_vector(2 downto 0);
          ALUSrcA, ResultSrc, ALUOp : out std_logic_vector(1 downto 0);
          Branch, Jump, JumpSrc : out std_logic);
end;

architecture beh of main_decoder is
begin
    process(op)
    variable res : std_logic_vector(14 downto 0);
    begin
        case op is

            -- I - rd = mem[rs1+imm]
            when "0000011" => res:= "000" & "00" & '1' & '1' & '0' & "01" & '0' & '0' & '0' & "00";

            -- I - addi/slti/sltiu/xori/ori/andi/slli/srli/srai
            when "0010011" => res:= "000" & "00" & '1' & '1' & '0' & "00" & '0' & '0' & '0' & "10";

            -- I - jalr - PC=rs1+SignExt(imm), rd = PC + 4 
            when "1100111" => res:= "000" & "00" & '1' & '1' & '0' & "10" & '1' & '1' & '0' & "00";

            -- S - [Address] = rs
            when "0100011" => res:= "001" & "00" & '1' & '0' & '1' & "--" & '0' & '0' & '0' & "00";

            -- U - lui - rd = {upimm, 12?b0}
            when "0110111" => res:= "010" & "01" & '1' & '1' & '0' & "00" & '0' & '0' & '0' & "00";

            -- U - auipc - rd = {upimm, 12'b0} + PC
            when "0010111" => res:= "010" & "10" & '1' & '1' & '0' & "00" & '0' & '0' & '0' & "00";

            -- J - jal - PC=JTA, rd = PC + 4
            when "1101111" => res:= "011" & "--" & '-' & '1' & '0' & "10" & '1' & '0' & '0' & "--";

            -- R - add/sub/sll/slt/sltu/xor/srl/sra/or/and
            when "0110011" => res:= "---" & "00" & '0' & '1' & '0' & "00" & '0' & '0' & '0' & "10";

            -- B - beq/bne/blt/bge/bltu/bgeu
            when "1100011" => res:= "100" & "00" & '0' & '0' & '0' & "--" & '0' & '0' & '1' & "01";

            when others    => res := (others => '-');
        end case;

        ImmSrc <= res(14 downto 12);
        ALUSrcA <= res(11 downto 10);
        ALUSrcB <= res(9);
        RegWrite <= res(8);    
        MemWrite <= res(7);
        ResultSrc <= res(6 downto 5);
        Jump <= res(4);
        JumpSrc <= res(3);
        Branch <= res(2);
        ALUOp <= res(1 downto 0);
    end process;
end;
