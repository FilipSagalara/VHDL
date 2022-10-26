----------------------------
-- Filip Kozlowski & Filip Sagalara
-- 141256 & 140308
-- testbanch do lab2
----------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.devices_pkg.all;
use work.all;
use std.textio.all;

entity tb_moduloX_golden is
end entity;

architecture behavioral of tb_moduloX_golden is

--component moduloX_golden is
--generic(DIGIT: natural:= 6;
--        GINDEX: natural:=141256;
--	SIMTIME: natural:= 500; --simulation time
--	FORCETIME: delay_length:= 10 ns); --force period time
--port (clk: in std_logic;
--	   rst: in std_logic;
--	   ce: in std_logic;
--	   tc: out std_logic;
--	  data_out: out std_logic_vector(4*DIGIT-1 downto 0));
--end component;
--uut: moduloX_golden port map(
--	clk=>clock,
--	rst=>reset,
--	ce=>clock_enable,
--	tc=>timec,
--	data_out=>data);

    signal ceo, clock_enable, clock, reset: std_logic:='0';
    signal timec: std_logic;
    signal data: std_logic_vector(23 downto 0);
    signal q: std_logic_vector(data'range):=((others => '0') );
    
    constant INDEX : std_logic_vector(data'range) := std_logic_vector(to_unsigned(141256,24));
    constant FORCETIME : delay_length:= 10 ns;
    constant SIMTIME : delay_length := 500 ns;

begin
UUT: entity work.moduloX_golden(struct) 
     port map(
	clk=>clock,
	rst=>reset,
	ce=>clock_enable,
	tc=>timec,
	data_out=>data);
----------------------------------------------------------------------
sim: process is
    procedure stop_after(t:delay_length) is
 	begin
	 wait for t; --stop(2);
	end procedure stop_after;
  begin
   stop_after(SIMTIME);
  end process sim;
----------------------------------------------------------------------
sim_time_count_process: process is 
    procedure count_time is
	variable t1, t2 : delay_length:= 0 ns;
	begin
	if (to_integer(signed(q)) = INDEX) then t1 := now;
	wait for 1 ns;							-- wait musi by by nie byo infinite loop
	 report "count period time " &time'image(t1) severity Warning;
	end if;
	end procedure count_time;
  begin 
   count_time;
  end process sim_time_count_process;
----------------------------------------------------------------------
sim_time_ceo_process: process is 
    procedure count_ceo_time is
	variable t1, t2 : delay_length:= 0 ns;
	begin
	if rising_edge(ceo) then t1 := now;
	 wait until ceo ='0';
	 t2:= now-t1;
	 report "ceo period time " &time'image(t2) severity Warning;
	end if;
	end procedure count_ceo_time;
  begin 
   count_ceo_time;
  end process sim_time_ceo_process;
----------------------------------------------------------------------
state_sim_process: process is
procedure raport_state is
	begin
	if rising_edge(q(0)) then
	wait until q(0) = '0';						-- wait musi by by nie byo infinite loop
	 report "last state is: " &time'image(now) severity Warning;
	end if;
	end procedure raport_state;
begin
 raport_state;
end process state_sim_process;
----------------------------------------------------------------------
--------------------- signals' processes -----------------------------
----------------------------------------------------------------------
clk_process: process is
 procedure clock_gen(signal s: out std_logic; period: delay_length) is
 begin loop
  s<= '1', '0' after period/2;
 wait for period;
 end loop;
end procedure clock_gen;
begin
 clock_gen(clock, FORCETIME);
end process clk_process;
----------------------------------------------------------------------
rst_process: process is
procedure set_pulse(signal s: out std_logic; t_high,t_low: delay_length) is
 begin
  s<='1','0' after t_high;
  wait for (t_high+t_low);
end procedure set_pulse;
 begin
  set_pulse(reset, FORCETIME, 4*FORCETIME);
 end process rst_process; 
-------------------------------------------
ce_proc: process is 
procedure set_pulse(signal s: out std_logic; t_high,t_low: delay_length) is
 begin
  s<= '1', '0' after t_high;
  wait for (t_high+t_low);
end procedure set_pulse;
begin 
 set_pulse(clock_enable, FORCETIME, 500 ns);
end process ce_proc;
----------------------------------------------------------------------

end;