library ieee;
use ieee.std_logic_1164.all;

entity decoder is
    port (op           : in  std_logic_vector(6 downto 0);
          funct3       : in  std_logic_vector(2 downto 0);
          funct7b5     : in  std_logic;
          Zero         : in  std_logic;
          ALUResultLSB : in  std_logic;

          RegWrite     : out std_logic;
          ImmSrc       : out std_logic_vector(2 downto 0);
          ALUSrcA      : out std_logic_vector(1 downto 0);
          ALUSrcB      : out std_logic;
          MemWrite     : out std_logic;
          ResultSrc    : out std_logic_vector(1 downto 0);
          JumpSrc      : out std_logic;
          ALUControl   : out std_logic_vector(3 downto 0);
          PCSrc        : out std_logic);
end;

architecture struct of decoder is
    component main_decoder is
    port (op : in  std_logic_vector(6 downto 0);
          RegWrite, MemWrite, ALUSrcB : out std_logic;
          ImmSrc : out std_logic_vector(2 downto 0);
          ALUSrcA, ResultSrc, ALUOp : out std_logic_vector(1 downto 0);
          Branch, Jump, JumpSrc : out std_logic);
    end component;

    component alu_decoder is
    port (funct3 : in  std_logic_vector(2 downto 0);
          funct7b5, op5 : in  std_logic;
          ALUOp : in  std_logic_vector(1 downto 0);
          ALUControl : out std_logic_vector(3 downto 0);
          op : in std_logic_vector (6 downto 0));
    end component;

    signal Branch, Jump        : std_logic;
    signal ALUOp                : std_logic_vector(1 downto 0);
    signal BranchTaken, Taken   : std_logic;

    component mux2 is
    generic (n : natural := 31);
    port (a, b : in std_logic_vector(n downto 0);  
          sel : in std_logic; 
          y : out std_logic_vector(n downto 0) );
    end component;
begin

    md : main_decoder port map (op => op, RegWrite => RegWrite, ImmSrc => ImmSrc,
                            ALUSrcA => ALUSrcA, ALUSrcB => ALUSrcB, MemWrite => MemWrite,
                            ResultSrc => ResultSrc, Branch => Branch, Jump => Jump,
                            JumpSrc => JumpSrc, ALUOp => ALUOp);

    ad : alu_decoder port map (op => op, funct3 => funct3, funct7b5 => funct7b5, op5 => op(5),
                           ALUOp => ALUOp, ALUControl => ALUControl);

    -- beq/bne
    BranchTaken <= Zero when funct3(2) = '0' else ALUResultLSB;

    -- inverts bne, bge, bgeu
    Taken <= BranchTaken xor funct3(0);
    PCSrc <= (Branch and Taken) or Jump;
end;
