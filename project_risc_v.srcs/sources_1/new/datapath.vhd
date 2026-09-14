library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is 
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
end;

architecture struct of datapath is 
    component mux2 is 
        generic (n : natural := 31);
        port (a, b : in std_logic_vector(n downto 0);  
              sel : in std_logic; 
              y : out std_logic_vector(n downto 0) );
    end component;

    component fdre is
        generic (n : natural := 31);
        port (r, clk : in std_logic;
              d : in std_logic_vector (n downto 0);
              q : out std_logic_vector (n downto 0));
    end component;

    component add is
        port (a, b : in std_logic_vector(31 downto 0); 
              s : out std_logic_vector(31 downto 0));
    end component;

    component extend is
        port ( s : in std_logic_vector (2 downto 0);
               instr : in std_logic_vector (31 downto 7);
               y : out std_logic_vector (31 downto 0));
    end component;

    component reg_file is
        generic (
            N: natural := 32;
            A: natural := 5);
        Port (
            CLK, CLR: in  std_logic;
            WE : in  std_logic;
            WA, RA1, RA2 : in  std_logic_vector(A - 1 downto 0);
            WDP: in  std_logic_vector(N - 1 downto 0);
            RDP1, RDP2 : out std_logic_vector(N - 1 downto 0));
    end component;

    component mux3 is 
        generic (n : natural := 31);
        port (a, b, c : in std_logic_vector (n downto 0);
              sel : in std_logic_vector (1 downto 0);
              y : out std_logic_vector (n downto 0));
    end component;

    component alu is
    port (a, b : in  std_logic_vector(31 downto 0);
          ALUControl : in  std_logic_vector(3 downto 0);
          result : out std_logic_vector(31 downto 0);
          zero : out std_logic);
    end component;

signal instr_bits : std_logic_vector (31 downto 7);
signal a1, a2, a3, wd3 : std_logic_vector (4 downto 0);
signal rd1, rd2      : std_logic_vector(31 downto 0);
signal zero_s : std_logic;

signal pc_t, PCnext, pc4, pctarget, jumpbase: std_logic_vector (31 downto 0);
signal immext, result , alures, srca, srcb : std_logic_vector(31 downto 0);
constant ZERO32 : std_logic_vector(31 downto 0) := (others => '0');
constant FOUR : std_logic_vector(31 downto 0) := X"00000004";

begin
    PCreg : fdre generic map (n => 31)
         port map (r => reset, clk => clk, d => PCnext, q => PC_t);
    pc <= pc_t;         
         
    add4 : add port map (a => PC_t, b => FOUR, s => PC4);

    -- jal(PC) / jalr(RD1)
    jumpbase_mux : mux2 generic map (n => 31)
                        port map (a => rd1, b => pc_t, sel => JumpSrc, y => jumpbase);
    
    add_target: add port map (a => jumpbase, b => ImmExt, s => PCTarget);

    ext : extend port map (s => ImmSrc, instr => instr_bits, y => ImmExt);
    
    -- PCSrc=1 -> PCTarget (jal), PCSrc=0 -> PCPlus4
    pc_mux : mux2 generic map (n => 31)
                  port map (a => PCTarget, b => PC4, sel => pcsrc, y => pcnext);
    
    instr_bits <= instr(31 downto 7);
    a1 <= instr(19 downto 15);
    a2 <= instr(24 downto 20);
    a3 <= instr(11 downto 7);
    
    --result = wd3
    regFile : reg_file generic map (n => 32, a => 5)
                       port map (clk => clk, clr => reset, we => RegWrite, wa => a3, ra1 => a1, ra2 => a2, wdp => result,  rdp1 => rd1, rdp2 => rd2);
    WriteData <= rd2;
    
    -- SrcA: 00=RD1, 01=0 (lui), 10=PC (auipc)
    a_mux : mux3 generic map (n => 31)
                 port map (a => rd1, b => ZERO32, c => pc_t, sel => ALUSrcA, y => srcA);

     -- SrcB: 1 -> ImmExt, 0 -> RD2
    b_mux : mux2 generic map (n => 31)
                 port map (a => immext, b => rd2, sel => ALUSrcB, y => srcB);

    alu_i : alu port map (a => srcA, b => srcB, ALUControl => ALUControl, result => alures, zero => zero_s);
    aluresult <= alures;
    zero <= zero_s;
    ALUResultLSB <= alures(0);

    res_mux : mux3 generic map (n => 31)
                   port map (a => alures, b=> readdata, c => pc4, sel => ResultSrc, y =>  result);
end;