library ieee;
use ieee.std_logic_1164.all;

entity top is 
    port (clk, reset : in std_logic;
          sw_i : in std_logic_vector (15 downto 0);
          led_o : out std_logic_vector (15 downto 0));
end;

architecture struct of top is 
component risc_v_single is 
    port (clk, reset : in  std_logic;

          -- из памяти иснтр
          PC         : out std_logic_vector(31 downto 0);
          Instr      : in  std_logic_vector(31 downto 0);

          -- из памяти данных
          MemWrite   : out std_logic;
          ALUResult  : out std_logic_vector(31 downto 0);
          WriteData  : out std_logic_vector(31 downto 0);
          ReadData   : in  std_logic_vector(31 downto 0));
end component;

component instr_mem is port (pc : in std_logic_vector (31 downto 0);
          instr : out std_logic_vector(31 downto 0));
end component;

component d_mem is
    port (clk, memwrite : in  std_logic;
         aluresult, writedata : in  std_logic_vector(31 downto 0);

         sw_i    : in  std_logic_vector(15 downto 0);
         led_o   : out std_logic_vector(15 downto 0);

         readdata      : out std_logic_vector(31 downto 0));
    end component;
    
signal pc_s, instr_s : std_logic_vector(31 downto 0);
signal memwrite_s : std_logic;
signal aluresult_s, writedata_s, readdata_s: std_logic_vector(31 downto 0);
begin 
    cpu : risc_v_single port map (clk       => clk,
                                  reset     => reset,
                                  PC        => pc_s,
                                  Instr     => instr_s,
                                  MemWrite  => memwrite_s,
                                  ALUResult => aluresult_s,
                                  WriteData => writedata_s,
                                  ReadData  => readdata_s);
    imem : instr_mem port map (pc => pc_s, instr => instr_s);

    dmem : d_mem port map (clk       => clk,
                           memwrite  => memwrite_s,
                           aluresult => aluresult_s,
                           writedata => writedata_s,
                           sw_i      => sw_i,
                           led_o     => led_o,
                           readdata  => readdata_s);
end;
