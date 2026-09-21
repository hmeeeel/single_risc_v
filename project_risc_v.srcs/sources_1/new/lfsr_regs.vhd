library ieee;
use ieee.std_logic_1164.all;

entity lfsr_regs is
    port (clk, reset : in  std_logic;
          memwrite : in  std_logic;
          aluresult, writedata : in  std_logic_vector(31 downto 0);
          lw_ai, lw_seed, state_xor, state_sll : in  std_logic;  
          state_fb, state_nfb : in std_logic_vector(7 downto 0);

          x0, x1, x2 : out std_logic;

          Ai_o     : out std_logic_vector(7 downto 0);
          state_o  : out std_logic_vector(7 downto 0);
          state_rd : out std_logic_vector(31 downto 0));
end;

architecture beh of lfsr_regs is
    constant POLY_ADDR  : std_logic_vector(31 downto 0) := X"C0000008";
    constant CTRL_ADDR  : std_logic_vector(31 downto 0) := X"C000000C";
    constant STATE_ADDR : std_logic_vector(31 downto 0) := X"C0000010";
    constant SEED : std_logic_vector(7 downto 0) := X"01";

    signal Ai, state : std_logic_vector(7 downto 0) := (others => '0');
    signal run : std_logic := '0';

    signal prev_aluresult : std_logic_vector(31 downto 0) := (others => '0');
    signal state_accessed : std_logic;
begin

    
    process(clk)
    begin
        if rising_edge(clk) then
            prev_aluresult <= aluresult;
            if reset = '1' then
                Ai    <= (others => '0');
                state <= (others => '0');
                run   <= '0';
            elsif lw_ai = '1' then Ai <= writedata(7 downto 0);
            elsif lw_seed = '1' then
                state <= SEED;
                run   <= '1';
            elsif state_xor = '1' then state <= state_fb;
            elsif state_sll= '1' then state <= state_nfb;
            end if;
        end if;
    end process;

    Ai_o     <= Ai;
    state_o  <= state;
    state_rd <= X"000000" & state;


    state_accessed <= '1' when (aluresult = STATE_ADDR and prev_aluresult /= STATE_ADDR and  run = '1') else '0';
                                
    x0 <= '1' when (memwrite = '1' and aluresult = POLY_ADDR) else '0';
    x1 <= '1' when (memwrite = '1' and aluresult = CTRL_ADDR and writedata(0) = '1') else '0';

    --x2 <= '1' when (aluresult = STATE_ADDR and run = '1') else '0';
    x2 <= state_accessed; 

end;