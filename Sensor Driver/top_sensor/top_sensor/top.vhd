

library IEEE;
use IEEE.std_logic_1164.all;

entity top is
    port (
        clk: IN std_logic; 
        rst: IN std_logic;
        mode: IN std_logic;
        start: IN std_logic;
        echo: IN std_logic;
        trig: OUT std_logic;
        seg: OUT std_logic_vector(6 downto 0);
        bin: OUT std_logic_vector(7 downto 0);
        an: OUT std_logic_vector(3 downto 0)
    );     
end entity top;

architecture behav of top is 

    signal clk_1k, clk_1m, clk_100 : std_logic;
    signal bin_s: std_logic_vector(15 downto 0);

begin
        
    clk1: entity work.clk_gen_1Hz_v6 generic map(false) port map(
        clk_in=>clk, 
		rst=>rst,
		f_100Hz=>clk_100, 
		f_1kHz=>clk_1k, 
		f_1MHz=>clk_1m
    );


    ultra: entity work.dist_sensor generic map(50000000, 16, 5800) port map(
        clk=>clk,
        rst=>rst,
        mode=>mode,
        start=>start,
        bin=>bin_s,
        trig=>trig,
        echo=>echo
    );

    led1: entity work.led4_drv generic map(1000, false) port map(
		a=>bin_s(3 downto 0), 
		b=>bin_s(7 downto 4), 
		c=>bin_s(11 downto 8),
        d=>bin_s(15 downto 12), 
        clk_in=>clk_1k,
		sseg=>seg,
		an=>an
    );

    bin <= bin_s(7 downto 0);
end architecture behav;