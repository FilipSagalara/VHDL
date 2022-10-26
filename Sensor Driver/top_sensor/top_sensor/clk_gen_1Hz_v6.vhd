----------------------------------------------------------------------------------
-- Company: CCE
-- Engineer: Kropidlowski Marek
-- Create Date:    14/03/2005 
-- v.1: 1s, 1ms, 1us timebase with async reset, 
-- v.2a: output high after reset, sim correct.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_gen_1Hz_v6 is
    generic ( Simulation : boolean := true);
    Port (  clk_in : in  STD_LOGIC;
            rst : in STD_LOGIC; -- async high
            f_100Hz, f_1kHz, f_1MHz : out std_logic;
            t_1sec, t_1ms, t_1us : out  STD_LOGIC);
end clk_gen_1Hz_v6;

architecture behav of clk_gen_1Hz_v6 is
--
constant Fclk_MHz: natural:=50; -- clk_in frequency in MHz (min:10, max:200, step:10)
constant N_period: natural:=Fclk_MHz/2;
constant dec: natural:=10;
constant cent: natural:=100;
constant kilo: natural:=1000;
constant Np2: natural:=2*N_period;
constant Npk: natural:=N_period*kilo;
constant Npk2: natural:=2*Npk;
constant Npkd: natural:=Npk*dec;
constant Npkk2: natural:=Npk2*kilo;
signal mhz_count : integer range 0 to N_period :=0;
signal khz_count : integer range 0 to kilo :=0;
signal chz_count : integer range 0 to dec :=0;
signal hz_count : integer range 0 to kilo :=0;
signal clk_mhz2,clk_khz2,clk_hz2: std_logic:='1';
signal clk_mhz,clk_khz,clk_hz,clk_chz: std_logic:='0';
signal mhz_en,khz_en,hz_en,chz_en: std_logic:='0';

begin

gen_hw: if not Simulation generate

 mhz_timer: process(clk_in,rst)
  begin
    if rst='1' then
      mhz_count <= 0;
      mhz_en <= '0';
      khz_count <= 0;
      khz_en <= '0';
      chz_count <= 0;
      chz_en <= '0';
      hz_count <= 0;
      hz_en <= '0';
    elsif rising_edge(clk_in) then
      if mhz_count=(N_period -1) then
           mhz_count <= 0;
           mhz_en <= '1';
      else
           mhz_count <= mhz_count + 1;
           mhz_en <= '0';
      end if;

      if (mhz_en)='1' then
        if khz_count=(kilo-1) then
             khz_count <= 0;
             khz_en <= '1';
        else
             khz_count <= khz_count + 1;
             khz_en <= '0';
        end if;
      end if;

      if (khz_en and mhz_en)='1' then
        if hz_count=(kilo-1) then
             hz_count <= 0;
             hz_en <= '1';
        else
             hz_count <= hz_count + 1;
             hz_en <= '0';
        end if;
      end if;

      if (khz_en and mhz_en)='1' then
        if chz_count=(dec-1) then
             chz_count <= 0;
             chz_en <= '1';
        else
             chz_count <= chz_count + 1;
             chz_en <= '0';
        end if;
      end if;

    end if;
  end process mhz_timer;

 x_50percent: process(clk_in,rst)
  begin
    if rst='1' then
      clk_mhz <= '0';
      clk_khz <= '0';
      clk_chz <= '0';
      clk_hz <= '0';
      clk_mhz2 <= '1';
      clk_khz2 <= '1';
      clk_hz2 <= '1';
    elsif rising_edge(clk_in) then
      if (mhz_en) ='1' then
           clk_mhz <= not clk_mhz;
      end if;
      if (mhz_en and clk_mhz) ='1' then
        clk_mhz2 <= not clk_mhz2;
      end if;
      if (mhz_en and khz_en) ='1'then
           clk_khz <= not clk_khz;
      end if;
      if (mhz_en and khz_en and clk_khz) ='1'then
          clk_khz2 <= not clk_khz2;
      end if;
      if (mhz_en and khz_en and chz_en) ='1' then
           clk_chz <= not clk_chz;
      end if;
      if (mhz_en and khz_en and hz_en) ='1' then
           clk_hz <= not clk_hz;
      end if;
      if (mhz_en and khz_en and hz_en and clk_hz) ='1' then
           clk_hz2 <= not clk_hz2;
      end if;
    end if;
 end process;
end generate;

t_1us <= clk_mhz2;
t_1ms <= clk_khz2;
t_1sec <= clk_hz2;
f_100Hz <= clk_chz;
f_1kHz <= clk_khz;
f_1MHz <= clk_mhz;

test_proc: if Simulation generate
 --synthesis translate_off
 process(rst,clk_in)
    variable timer: natural:=0;
    begin
    if rst='1' then
        timer:=0;
        clk_mhz2<='0';
        clk_khz2<='0';
        clk_hz2<='0';
        clk_chz<='0';
        clk_khz<='0';
        clk_mhz<='0';
    elsif rising_edge(clk_in) then
        if (timer mod N_period)=0 then clk_mhz<=not clk_mhz; end if;
        if (timer mod Np2)=0 then clk_mhz2<=not clk_mhz2; end if;
        if (timer mod Npk)=0 then clk_khz<= not clk_khz; end if;
        if (timer mod Npk2)=0 then clk_khz2<= not clk_khz2; end if;
        if (timer mod Npkd)=0 then clk_chz<= not clk_chz; end if;
        if (timer=Npkk2) then
            clk_hz2 <= not clk_hz2;
            timer:=1;
        else
            timer:=timer+1;
        end if;    
    end if;
 end process;
 --synthesis translate_on
end generate;

end behav;
