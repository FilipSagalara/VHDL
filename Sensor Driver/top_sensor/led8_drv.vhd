-------------------------------------------------------------------------------
-- Project: IP components lib
-- Author(s): Marek Kropidlowski
-- Created: Dec 2015   
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led8_drv is
    Generic ( MAIN_CLK: natural:=100E6;                 -- main frequency in Hz
              CLKDIV_INTERNAL: boolean:=True);          -- 
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN0
           b : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN1
           c : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN2
           d : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN3 
           e : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN4
           f : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN5
           g : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN6
           h : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN7 
           clk_in : in  STD_LOGIC;                      -- main_clk or slow_clk (external)
           sseg : out  STD_LOGIC_VECTOR (6 downto 0);   -- active Low
           an : out  STD_LOGIC_VECTOR (7 downto 0));    -- active Low
end led8_drv;

architecture Behavioral of led8_drv is
constant DONTCARE: std_logic_vector(3 downto 0):="----";
constant F_SLOW: natural:=500; -- display freq in Hz
constant H_PERIOD: natural:=MAIN_CLK/F_SLOW/2;
signal clkdiv_counter : natural range 0 to H_PERIOD :=0;
signal slow_clk: std_logic:='0';
signal digit: std_logic_vector(3 downto 0):="0000";
signal one_hot,address: std_logic_vector(7 downto 0):=x"FE";
signal seg: std_logic_vector(6 downto 0);

begin

-- otputs
an_out: an <= one_hot;
sseg_out: sseg <= not(seg);
--

addr_reg: process(slow_clk)
begin
    if rising_edge(slow_clk) then 
        one_hot <= one_hot(6 downto 0) & one_hot(7);
    end if;    
end process;
address <= one_hot;

data_mux: with address select
    digit <= a when x"fe",
        b when x"fd",
        c when x"fb",
        d when x"f7",
        e when x"ef",
        f when x"df",
        g when x"bf",
        h when x"7f",
        DONTCARE when others;

sseg_dec: with digit select             --        0
    seg <= "0000110" when "0001",       --      -----
        "1011011" when "0010",          --    5|     |1
        "1001111" when "0011",          --     |  6  |
        "1100110" when "0100",          --      -----
        "1101101" when "0101",          --    4|     |2
        "1111101" when "0110",          --     |     |
        "0000111" when "0111",          --      -----
        "1111111" when "1000",          --        3
        "1101111" when "1001",
        "1110111" when "1010",
        "1111100" when "1011",
        "0111001" when "1100",
        "1011110" when "1101",
        "1111001" when "1110",
        "1110001" when "1111",
        "0111111" when "0000",
        "1000000" when others;

-- clock signals
clkdiv_true: if CLKDIV_INTERNAL generate
  process(clk_in) begin
    if rising_edge(clk_in) then 
      if clkdiv_counter=H_PERIOD-1 then
        clkdiv_counter <= 0;
        slow_clk <= not slow_clk;
      else 
        clkdiv_counter <= clkdiv_counter+1;
      end if;
    end if;
  end process;
end generate;

clkdiv_false: if not CLKDIV_INTERNAL generate
  slow_clk <= clk_in;
end generate;

end Behavioral;