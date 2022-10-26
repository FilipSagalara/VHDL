LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use STD.textio.all; 

entity top_sensor is
port( 
------------ interfejs uzytkownika 
	clk: in std_logic; 
	rst: in std_logic; 
	mode: in std_logic; 
	start:in std_logic; 
	bin: out std_logic_vector(15 downto 0) := (others =>'0'); 

------------ interfejs czujnika 
	trig: out std_logic; 
	echo: in std_logic; 
------------ interfejs wyswietlacza
	seg: out std_logic_vector(6 downto 0) := (others => '0');
	an: out std_logic_vector(3 downto 0) := (others => '0')
);

end top_sensor;

architecture behavioral of top_sensor is
--signals
	signal hc_out: std_logic;

	signal hz100: std_logic;
	signal mhz1: std_logic;
	signal khz1: std_logic;

    signal tmpbin: std_logic_vector(15 downto 0) := (others => '1');

	-- segmentation display
	signal led4_drv_in: std_logic_vector(15 DOWNTO 0):= (others => '0');

begin

inst_led_driver: entity work.led4_drv 
generic map(1000, false)
port map(
           a => led4_drv_in(3 downto 0),--: in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN0
           b => led4_drv_in(7 downto 4),--: --: in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN1
           c => led4_drv_in(11 downto 8),--: in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN2
           d => led4_drv_in(15 downto 12),--: in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN3 
           clk_in=>khz1,  --in  STD_LOGIC;                      -- main_clk or slow_clk (external)
           sseg=>seg, --: out  STD_LOGIC_VECTOR (6 downto 0);   -- active Low
           an=>an
);

inst_gen: entity work.clk_gen_1Hz_v6 
generic map(false)
port map(
	    clk_in=>clk,
        rst=>rst, -- async high
        f_100Hz=>hz100,
	    f_1kHz=>khz1,
	    f_1MHz=>mhz1
);

inst_dist_sensor: entity work.dist_sensor 
generic map(50000000, 16, 5800) 
port map(
        clk=>clk,
        rst=>rst,
        mode=>mode,
        start=>start,
        bin=>led4_drv_in,
        trig=>trig,
        echo=>echo
    );
end architecture behavioral;