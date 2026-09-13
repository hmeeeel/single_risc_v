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
    port (
    immsrc, resSrc : out std_logic_vector(1 downto 0);
    aluA, aluB, memwr, regwr, PCSrc : out  std_logic;
    op : in std_logic_vector (6 downto 0));
    end component;
    
component datapath is 
    port (clk, reset : in  std_logic;

          -- из decoder
          ImmSrc     : in  std_logic_vector(1 downto 0);
          ALUSrcA    : in  std_logic;
          ALUSrcB    : in  std_logic;
          ResultSrc  : in  std_logic_vector(1 downto 0);
          RegWrite   : in  std_logic;
          PCSrc      : in  std_logic;

          -- из памяти иснтр 
          PC         : out std_logic_vector(31 downto 0);
          Instr      : in  std_logic_vector(31 downto 0);

          -- из памяти данных
          ALUResult  : out std_logic_vector(31 downto 0);
          WriteData  : out std_logic_vector(31 downto 0);
          ReadData   : in  std_logic_vector(31 downto 0));
end component;

signal immsrc, resultsrc : std_logic_vector(1 downto 0);
signal alusrca, alusrcb : std_logic;
signal regwrite_s, pcsrc_s : std_logic;
begin
    controller : decoder  port map (immsrc => immsrc, resSrc => resultsrc,
                                    aluA => alusrca, aluB => alusrcb, memwr => MemWrite, 
                                    regwr => regwrite_s, PCSrc => pcsrc_s, op => Instr(6 downto 0));
        
    risc : datapath port map (clk => clk, reset => reset, ImmSrc => immsrc,
                              ALUSrcA => alusrca, ALUSrcB => alusrcb, ResultSrc=> resultsrc, 
                              RegWrite=> regwrite_s, PCSrc => pcsrc_s, PC => PC, Instr => Instr, 
                              ALUResult => ALUResult, WriteData => WriteData, ReadData => ReadData);
end;

