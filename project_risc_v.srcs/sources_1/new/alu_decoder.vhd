library ieee;
use ieee.std_logic_1164.all;

entity alu_decoder is
    port (funct3 : in  std_logic_vector(2 downto 0);
          funct7b5, op5 : in  std_logic;
          ALUOp : in  std_logic_vector(1 downto 0);
          ALUControl : out std_logic_vector(3 downto 0);
          op : in std_logic_vector (6 downto 0));
end;

architecture beh of alu_decoder is
    signal sub_case : std_logic;
    signal sel : std_logic_vector(9 downto 0); --op & funct3 
    signal control : std_logic_vector(3 downto 0);
begin
    --sub_case <= funct7b5 and op5;

    sel <= op & funct3;

    with sel select 
        control <= 
                   --          0110011 (51) - R   0010011 (19) - I 
                   "0010" when "0110011" & "001" | "0010011" & "001",   -- sll/slli
                   "0011" when "0110011" & "010" | "0010011" & "010",   -- slt/slti
                   "0100" when "0110011" & "011" | "0010011" & "011",   -- sltu/sltiu
                   "0101" when "0110011" & "100" | "0010011" & "100",   -- xor/xori
                   "0111" when "0110011" & "101" | "0010011" & "101",   -- srl/srli
                   "1000" when "0110011" & "110" | "0010011" & "110",   -- or/ori
                   "1001" when "0110011" & "111" | "0010011" & "111",   -- and/andi

                   -- 1100011 (99) - B
                   "0001" when "1100011" & "000" | "1100011" & "001",   -- beq/bne = sub
                   "0011" when "1100011" & "100" | "1100011" & "101",   -- blt/bge = slt
                   "0100" when "1100011" & "110" | "1100011" & "111",   -- bltu/bgeu = sltu
                   "0000" when others;   -- load/store/jalr/lui/auipc/jal, add/addi
    
    
    ALUControl <= "0001" when (op = "0110011" and funct3 = "000" and funct7b5 = '1') else -- sub
                  "0110" when ((op = "0110011" or op = "0010011") and funct3 = "101" and funct7b5 = '1') else -- sra/srai
                  control;
end;
