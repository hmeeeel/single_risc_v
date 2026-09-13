library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_mem is
    port (
        clk, memwrite : in  std_logic;
        aluresult, writedata      : in  std_logic_vector(31 downto 0);

        sw_i    : in  std_logic_vector(15 downto 0);
        led_o   : out std_logic_vector(15 downto 0);

        readdata      : out std_logic_vector(31 downto 0)
    );
end;

architecture beh of d_mem is

    type ram_t is array (0 to 255) of std_logic_vector(31 downto 0);
    signal ram     : ram_t := (others => (others => '0'));
    signal led_reg : std_logic_vector(15 downto 0) := (others => '0');

    constant SW_ADDR  : std_logic_vector(31 downto 0) := X"C0000000";
    constant LED_ADDR : std_logic_vector(31 downto 0) := X"C0000004";
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if memwrite = '1' then
                if aluresult = LED_ADDR then
                    led_reg <= writedata(15 downto 0);
                elsif aluresult = SW_ADDR then
                    null;  -- SW read-only
                else
                    ram(to_integer(unsigned(aluresult(9 downto 2)))) <= writedata;
                end if;
            end if;
        end if;
    end process;

     readdata <= (X"0000" & sw_i) when aluresult = SW_ADDR else ram(to_integer(unsigned(aluresult(9 downto 2))));
    led_o <= led_reg;
end;
