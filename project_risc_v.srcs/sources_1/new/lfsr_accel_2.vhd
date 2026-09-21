library ieee;
use ieee.std_logic_1164.all;

entity lfsr_accel_2 is
    port (
        clk, reset : in std_logic;
        memwrite: in std_logic;
        aluresult, writedata : in std_logic_vector(31 downto 0);
        state_rd : out std_logic_vector(31 downto 0));
end entity;

architecture beh of lfsr_accel_2 is

    component lfsr_core is
    port (state, Ai : in std_logic_vector(7 downto 0);
          feedback : out std_logic; 
          state_fb, state_nfb : out std_logic_vector(7 downto 0));
    end component;
    
    component lfsr_fsm is
    port (
        clk, reset : in  std_logic;
        x0, x1, x2, x3: in  std_logic;
        lw_ai, lw_seed, state_xor,state_sll : out std_logic);
    end component;
    
    component lfsr_regs is
    port (clk, reset : in  std_logic;
          memwrite : in  std_logic;
          aluresult, writedata : in  std_logic_vector(31 downto 0);
          lw_ai, lw_seed, state_xor, state_sll : in  std_logic;  
          state_fb, state_nfb : in std_logic_vector(7 downto 0);

          x0, x1, x2 : out std_logic;

          Ai_o     : out std_logic_vector(7 downto 0);
          state_o  : out std_logic_vector(7 downto 0);
          state_rd : out std_logic_vector(31 downto 0));
    end component;

    component lfsr_fsm_alternative is
    port (
        clk, reset : in  std_logic;
        x0, x1, x2, x3: in  std_logic;
        lw_ai, lw_seed, state_xor,state_sll : out std_logic);
    end component;

    signal x_poly_write, x_ctrl_start, x_state_read: std_logic; --x0 x1 x3
    signal lw_ai, lw_seed, state_xor, state_sll : std_logic; -- y0 y1 y2 y3
    signal Ai_int, state_int, state_fb_int, state_nfb_int : std_logic_vector(7 downto 0); 
    signal feedback_int  : std_logic; 
begin

    core : lfsr_core port map (
        state => state_int, Ai  => Ai_int, feedback => feedback_int, 
        state_fb => state_fb_int, state_nfb => state_nfb_int);

    fsm : lfsr_fsm port map (
        clk => clk,  reset => reset,
        x0 => x_poly_write, x1 => x_ctrl_start, x2 => x_state_read, x3 => feedback_int,
        lw_ai => lw_ai, lw_seed => lw_seed,
        state_xor => state_xor, state_sll => state_sll);
        
   -- fsm_2 : lfsr_fsm_alternative port map (
   --     clk => clk,  reset => reset,
   --     x0 => x_poly_write, x1 => x_ctrl_start, x2 => x_state_read, x3 => feedback_int,
   --     lw_ai => lw_ai, lw_seed => lw_seed,
   --     state_xor => state_xor, state_sll => state_sll);

    regs : lfsr_regs port map (
        clk => clk, reset => reset,
        memwrite => memwrite, aluresult => aluresult, writedata => writedata,
        lw_ai => lw_ai, lw_seed => lw_seed,
        state_xor => state_xor, state_sll => state_sll,
        state_fb => state_fb_int, state_nfb => state_nfb_int,
        x0 => x_poly_write, x1 => x_ctrl_start, x2 => x_state_read,
        Ai_o => Ai_int,
        state_o => state_int,
        state_rd => state_rd);

end;