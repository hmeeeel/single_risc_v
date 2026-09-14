library ieee;
use ieee.std_logic_1164.all;

entity risc_v_single is 
    port (clk, reset : in  std_logic;

          -- из памяти иснтр
          PC         : out std_logic_vector(31 downto 0);
          Instr      : in  std_logic_vector(31 downto 0);

          -- из памяти данных
          MemWrite   : out std_logic;
          ALUResult  : out std_logic_vector(31 downto 0);
          WriteData  : out std_logic_vector(31 downto 0);
          ReadData   : in  std_logic_vector(31 downto 0));
end;

architecture struct of risc_v_single is 

component decoder is
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
end component;
    
component datapath is 
    port (clk, reset : in  std_logic;

          -- из decoder
          ImmSrc     : in  std_logic_vector(2 downto 0);
          ALUSrcA    : in  std_logic_vector(1 downto 0);
          ALUSrcB    : in  std_logic;
          ResultSrc  : in  std_logic_vector(1 downto 0);
          RegWrite   : in  std_logic;
          PCSrc      : in  std_logic;
          JumpSrc    : in  std_logic;
          ALUControl  : in  std_logic_vector(3 downto 0);
          Zero, ALUResultLSB : out std_logic;

          -- из памяти иснтр 
          PC         : out std_logic_vector(31 downto 0);
          Instr      : in  std_logic_vector(31 downto 0);

          -- из памяти данных
          ALUResult  : out std_logic_vector(31 downto 0);
          WriteData  : out std_logic_vector(31 downto 0);
          ReadData   : in  std_logic_vector(31 downto 0));
end component;

signal immsrc : std_logic_vector(2 downto 0);
signal alusrca, resultsrc : std_logic_vector(1 downto 0);
signal alusrcb, regwrite_s,jumpsrc_s, pcsrc_s : std_logic;
signal alucontrol : std_logic_vector(3 downto 0);
signal zero_s, alulsb_s : std_logic;

begin
    controller : decoder port map (
            op           => Instr(6 downto 0),
            funct3       => Instr(14 downto 12),
            funct7b5     => Instr(30),
            Zero         => zero_s,
            ALUResultLSB => alulsb_s,
            RegWrite     => regwrite_s,
            ImmSrc       => immsrc,
            ALUSrcA      => alusrca,
            ALUSrcB      => alusrcb,
            MemWrite     => MemWrite,
            ResultSrc    => resultsrc,
            JumpSrc      => jumpsrc_s,
            ALUControl   => alucontrol,
            PCSrc        => pcsrc_s);

        risc : datapath port map (
            clk => clk, reset => reset, ImmSrc => immsrc,
            ALUSrcA => alusrca, ALUSrcB => alusrcb, ResultSrc => resultsrc,
            RegWrite => regwrite_s, JumpSrc => jumpsrc_s, ALUControl => alucontrol,
            PCSrc => pcsrc_s, Zero => zero_s, ALUResultLSB => alulsb_s,
            PC => PC, Instr => Instr,
            ALUResult => ALUResult, WriteData => WriteData, ReadData => ReadData);
end;

