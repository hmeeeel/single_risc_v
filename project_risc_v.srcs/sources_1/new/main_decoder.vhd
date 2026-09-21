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
signal res: std_logic_vector(12 downto 0);
begin

    with op select 
    res <= "000" & "00" & '1' & '1' & '0' & "01" & '0' & '0' & '0' when "0000011",  -- I - rd = mem[rs1+imm]
           "000" & "00" & '1' & '1' & '0' & "00" & '0' & '0' & '0' when "0010011",  -- I - addi/slti/sltiu/xori/ori/andi/slli/srli/srai 
           "000" & "00" & '1' & '1' & '0' & "10" & '1' & '1' & '0' when "1100111",  -- I - jalr - PC=rs1+SignExt(imm), rd = PC + 4 
           "001" & "00" & '1' & '0' & '1' & "--" & '0' & '0' & '0' when "0100011",  -- S - [Address] = rs
           "010" & "01" & '1' & '1' & '0' & "00" & '0' & '0' & '0' when "0110111",  -- U - lui - rd = {upimm, 12?b0}
           "010" & "10" & '1' & '1' & '0' & "00" & '0' & '0' & '0' when "0010111",  -- U - auipc - rd = {upimm, 12'b0} + PC
           "011" & "--" & '-' & '1' & '0' & "10" & '1' & '0' & '0' when "1101111",  -- J - jal - PC=JTA, rd = PC + 4
           "---" & "00" & '0' & '1' & '0' & "00" & '0' & '0' & '0' when "0110011",  -- R - add/sub/sll/slt/sltu/xor/srl/sra/or/and
           "100" & "00" & '0' & '0' & '0' & "--" & '0' & '0' & '1' when "1100011",  -- B - beq/bne/blt/bge/bltu/bgeu
           (others => '-')  when others;

        ImmSrc <= res(12 downto 10);
        ALUSrcA <= res(9 downto 8);
        ALUSrcB <= res(7);
        RegWrite <= res(6);    
        MemWrite <= res(5);
        ResultSrc <= res(4 downto 3);
        Jump <= res(2);
        JumpSrc <= res(1);
        Branch <= res(0);
end;
