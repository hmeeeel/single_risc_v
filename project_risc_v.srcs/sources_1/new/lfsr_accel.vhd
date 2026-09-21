library ieee;
use ieee.std_logic_1164.all;

entity lfsr_accel is
    port (clk, reset : in  std_logic;
          memwrite : in  std_logic;
          aluresult, writedata : in  std_logic_vector(31 downto 0);
          state_rd : out std_logic_vector(31 downto 0));
end;

architecture beh of lfsr_accel is
    constant POLY_ADDR : std_logic_vector(31 downto 0) := X"C0000008";
    constant CTRL_ADDR : std_logic_vector(31 downto 0) := X"C000000C"; --1=RUN  
    constant STATE_ADDR : std_logic_vector(31 downto 0) := X"C0000010";
    constant SEED : std_logic_vector(7 downto 0)  := X"01";

    signal Ai : std_logic_vector(7 downto 0) :=  X"8e"; --t0
    signal state, state_fb, state_nfb : std_logic_vector(7 downto 0) := (others => '0'); -- t1
    signal feedback : std_logic;
    
--C0000000  SWITCH
--C0000004  LED
--C0000008  LFSR POLY 
--C000000C  LFSR CTRL_ADDR
--C0000010  LFSR STATE
begin

    feedback <= state(7);
    state_fb <= (state(6 downto 0) & '0') xor Ai;
    state_nfb <=(state(6 downto 0) & '0');
     process(clk)
     variable run : std_logic := '0'; 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Ai    <= (others => '0');
                state <= (others => '0');
                run   := '0';

            --sw t0, 8(t3)   
            elsif memwrite = '1' and aluresult = POLY_ADDR then
                Ai <= writedata(7 downto 0); 

            -- addi t1,x0,1 sw t1,12(t3)
            elsif memwrite = '1' and aluresult = CTRL_ADDR then
                if writedata(0) = '1' then state <= SEED;   run := '1'; 
            end if;

            --lw t2, 16(t3)
            elsif run = '1' and aluresult = STATE_ADDR then
                if feedback = '1' then state <= state_fb; -- srli+slli+andi+beq+xor
                else state <= state_nfb; -- srli+slli+andi+beq
                end if;
            end if;
        end if;
    end process;

    state_rd <= X"000000" & state;
end;