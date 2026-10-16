library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity lfsr_accel_2 is
    port (
        clk, reset : in  std_logic;
        memwrite   : in  std_logic;
        aluresult, writedata : in std_logic_vector(31 downto 0);
        state_rd   : out std_logic_vector(31 downto 0));
end;
architecture beh of lfsr_accel_2 is

  constant POLY_ADDR : std_logic_vector(31 downto 0) := x"C0000008";
  constant CTRL_ADDR : std_logic_vector(31 downto 0) := x"C000000C";

  signal wr_poly, wr_ctrl, poly_req, load_req : std_logic;
  signal din : std_logic_vector(7 downto 0) := (others => '0'); 

  signal poly, state : std_logic_vector(7 downto 0) := (others => '0');
  signal x0, x1, x2, x3 : std_logic;
  signal y : std_logic_vector(3 downto 0); 

  constant C_1  : std_logic_vector(2 downto 0) := "000";
  constant C_X0 : std_logic_vector(2 downto 0) := "001";
  constant C_X1 : std_logic_vector(2 downto 0) := "010";
  constant C_X2 : std_logic_vector(2 downto 0) := "011";
  constant C_X3 : std_logic_vector(2 downto 0) := "100";
  type rom_t is array (0 to 7) of std_logic_vector(12 downto 0);
  constant UROM : rom_t := (
    --   COND    A1     A0     Y
    0 => C_X0 & "001" & "000" & "0000",
    1 => C_1  & "010" & "010" & "1000",
    2 => C_X1 & "011" & "010" & "0000",
    3 => C_1  & "100" & "100" & "0100",
    4 => C_X2 & "101" & "100" & "0000",
    5 => C_X3 & "111" & "110" & "0000",
    6 => C_1  & "100" & "100" & "0001",
    7 => C_1  & "100" & "100" & "0011" 
  );
  signal upc  : unsigned(2 downto 0) := (others => '0');
  signal mi   : std_logic_vector(12 downto 0);  
  signal cond : std_logic; 
begin

  wr_poly <= '1' when memwrite = '1' and aluresult = POLY_ADDR else '0';
  wr_ctrl <= '1' when memwrite = '1' and aluresult = CTRL_ADDR else '0';

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        din      <= (others => '0');
        poly_req <= '0';
        load_req <= '0';
      else
        if wr_poly = '1' then
          din      <= writedata(7 downto 0);
          poly_req <= '1';
        elsif y(3) = '1' then poly_req <= '0';
        end if;
        if wr_ctrl = '1' then load_req <= writedata(0);  
        elsif y(2) = '1' then  load_req <= '0';
        end if;
      end if;
    end if;
  end process;

  --cond for ya
  x0 <= poly_req;      
  x1 <= load_req;   
  x2 <= '1';    
  x3 <= state(7);   

--ya - ? ???-??? ?? ??????? ??? ???? ???????? 
  mi <= UROM(to_integer(upc));
  y  <= mi(3 downto 0);
  with mi(12 downto 10) select cond <=
                                      x0  when C_X0,
                                      x1  when C_X1,
                                      x2  when C_X2,
                                      x3  when C_X3,
                                      '1' when others;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then upc <= (others => '0');
      elsif cond = '1' then upc <= unsigned(mi(9 downto 7)); --A1
      else upc <= unsigned(mi(6 downto 4)); --A0
      end if;
    end if;
  end process;

--oa -reg and comb logic
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        poly  <= (others => '0');
        state <= (others => '0');
      else
        if y(3) = '1' then poly <= din;
        end if;
        if y(2) = '1' then state <= x"01";
        elsif y(0) = '1' then
          if y(1) = '1' then 
            state <= (state(6 downto 0) & '0') xor poly;
          else
            state <= state(6 downto 0) & '0';
          end if;
        end if;
      end if;
    end if;
  end process;
  state_rd <= x"000000" & state;
end;