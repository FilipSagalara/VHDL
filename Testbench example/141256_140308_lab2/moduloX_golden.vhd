----------------------------
-- Marek Kropidlowski
-- 25/10/2020
-- licznik do weryfikacji lab2
----------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.devices_pkg.all;
use std.textio.all;

entity  moduloX_golden is
  generic(DIGIT: natural:= 6;
        GINDEX: natural:=141256);
  port(clk: in std_logic;
	   rst: in std_logic;
	   ce: in std_logic;
	   tc: out std_logic;
	  data_out: out std_logic_vector(4*DIGIT-1 downto 0));
end entity;

architecture struct of moduloX_golden is
    constant INDEX : std_logic_vector(data_out'range) := std_logic_vector(to_unsigned(GINDEX,4*DIGIT));
    signal ceo: std_logic;
    signal q: std_logic_vector(data_out'range):=((others => '0') );

begin

-- 
data_out <= q;
tc <= ceo;

cnt_beh: cntr_u
    generic map(N=>4*DIGIT, M=>GINDEX-1,T=>8 ns)
    port map(
        rst => rst,
        clk => clk,
        ce => ce,
        ceo => ceo,
        q => q);

end architecture;