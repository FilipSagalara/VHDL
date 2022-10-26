-- Create Date: 10/05/2022
-- Design Name: ultrasonic_drv_tb
-- Engineer: Kacper Szmitko, Marcin Tajsner
-- Description: Sterownik dla czujnika odległości

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ultrasonic_drv is
    generic(
        F_CLK: positive range 10000000 to 100000000 := 50000000;
        N: positive range 8 to 32 := 8
    );
    port(
        ------------ interfejs uzytkownika
        clk: in std_logic;
        rst: in std_logic;
        mode: in std_logic;
        start: in std_logic;
        bin: out std_logic_vector(N-1 downto 0);
        ------------ interfejs czujnika
        trig: out std_logic;
        echo: in std_logic
    );
end ultrasonic_drv;

architecture behav of ultrasonic_drv is

    constant TRIG_TIME: positive := 20000; -- time in ns
    constant WAIT_TIME: positive := 100000000; -- time in ns
    constant DISTANCE_M_INTERVAL: positive := 100; -- time in ns
    constant DIVIDER_TIMEOUT: positive := 500; --time in ns
    constant DISTANCE_DIVISOR: positive := 58;
    constant DIVIDER_N: positive := 32;
    
    constant CLOCK_TIME: positive := 1000000000 / F_CLK; -- time in ns
    constant TRIG_TICKS: positive := TRIG_TIME / CLOCK_TIME;
    constant WAIT_TICKS: positive := WAIT_TIME / CLOCK_TIME;
    constant DISTANCE_M_TICKS: positive := DISTANCE_M_INTERVAL / CLOCK_TIME;
    constant DIVIDER_TIMEOUT_TICKS: positive := DIVIDER_TIMEOUT / CLOCK_TIME;
    constant ZEROS: std_logic_vector(DIVIDER_N-1 downto 0) := (others => '0');

    signal state: natural range 0 to 6 := 0;
    signal trig_counter: natural range 0 to TRIG_TICKS-1 := 0;
    signal wait_counter: natural range 0 to WAIT_TICKS-1 := 0;
    signal divider_timeout_counter: natural range 0 to DIVIDER_TIMEOUT_TICKS-1 := 0;
    signal distance_divisor_bin: std_logic_vector(DIVIDER_N-1 downto 0) := 
        std_logic_vector(to_unsigned(DISTANCE_DIVISOR, DIVIDER_N));
    signal distance_m_counter: natural := 0;
    signal distance_raw: natural := 0;
    signal distance_raw_bin: std_logic_vector(DIVIDER_N-1 downto 0) := (others => '0');
    signal distance_bin: std_logic_vector(DIVIDER_N-1 downto 0) := (others => '0');
    signal distance_bin_rmdr: std_logic_vector(DIVIDER_N-1 downto 0) := (others => '0');
    signal divider_err: std_logic := '0';

begin
    
    divider: entity work.Divide generic map(DIVIDER_N) port map(
        a => distance_raw_bin,
        b => distance_divisor_bin,
        y => distance_bin,
        Rmdr => distance_bin_rmdr,
        Err => divider_err
    );

    process(clk)
    begin

        if rst = '1' then
            distance_raw <= 0;
            distance_raw_bin <= ZEROS;
            distance_bin_rmdr <= ZEROS;
            divider_err <= '0';
            bin <= distance_bin(N-1 downto 0);
            trig_counter <= 0;
            distance_m_counter <= 0;
            divider_timeout_counter <= 0;
            state <= 0;
        elsif rising_edge(clk) then
            case state is
                when 0 =>
                --bin <= "00000001"; --DEBUG
                    if start = '1' then
                        state <= 1;
                     else 
                     state <= 0;              
		    end if;
                when 1 =>
                --bin <= "00000010"; --DEBUG
                    if trig_counter = 0 then
                        trig <= '1';
			trig_counter <= trig_counter + 1;
			state <= 1;
                    elsif trig_counter = TRIG_TICKS-1 then
                        trig <= '0';
			trig_counter <= 0;
                        state <= 2;
                    else 
                        trig_counter <= trig_counter + 1;
			state <= 1;
                    end if;
                when 2 =>
                --bin <= "00000100"; --DEBUG
                    if echo = '1' then
                        distance_m_counter <= 1;
                        state <= 3;
		    else
			state <= 2;
                    end if;
                when 3 =>
                --bin <= "00001000"; --DEBUG
                    if echo = '1' then
                        if distance_m_counter = DISTANCE_M_TICKS-1 then
                            distance_raw <= distance_raw + 1;
                            distance_m_counter <= 0;
                        else 
                            distance_m_counter <= distance_m_counter + 1;  
                        end if;
		        state <= 3;
                    elsif echo = '0' then
                        distance_raw_bin <= ZEROS;
                        state <= 4;
		    else
			state <= 4;
                    end if;
                when 4 =>
                --bin <= "00010000"; --DEBUG
                if divider_timeout_counter = DIVIDER_TIMEOUT_TICKS-1 then
                    divider_timeout_counter <= 0;
			           state <= 3;
                elsif distance_bin = ZEROS then
                    divider_timeout_counter <= 0;
                    distance_raw_bin <= std_logic_vector(to_unsigned(distance_raw, distance_raw_bin'length));
                    distance_raw <= 0;
                    state <= 5;
                else
                    divider_timeout_counter <= divider_timeout_counter + 1;
                    state <= 4;
		    end if;
                when 5 =>
                --bin <= "00100000"; --DEBUG
                    if distance_bin /= ZEROS then

                        bin <= distance_bin(N-1 downto 0);
                        state <= 6;
                    else
                        state <= 5;
                    end if;
                when 6 =>
                     if wait_counter = WAIT_TICKS-1 then
                        wait_counter <= 0;
                        if mode = '1' then
                            state <= 1;
                        else
                            state <= 0;
                        end if;
                    else 
                        wait_counter <= wait_counter + 1;
                        state <= 6;
                    end if;
            end case;
        end if;
    end process;

end behav;
