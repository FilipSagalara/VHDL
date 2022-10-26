----------------------------------------------------------------------------------
-- Company: CCE
-- Engineer: Kropidlowski Marek
-- 
-- Create Date:    10:14:28 05/11/2019 
-- Nexys4DDR button fsm vc
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
USE work.pkg_symuli.all;
 
ENTITY key_fsm_c_tb IS
END key_fsm_c_tb;
 
ARCHITECTURE behavior OF key_fsm_c_tb IS 
    constant D: positive:=8; -- bcd register length (x4b)
    constant K: positive:=1*D; -- no of stimuli sequences

   --Inputs
    signal reg_out : std_logic_vector(D*4 -1 downto 0);
    signal clk_in: std_logic := '0';  
    signal rst: std_logic:='0';
    signal left,right,up,down,center: std_logic:='0';
    signal cntr_en,cntr_rst, edit_en, cntr_load: std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 100 ns;
   constant offset: time := 3 ns;
   constant space: time := 10*clk_in_period;

   -- local proc
   procedure cntr_start(signal s: out std_logic) is begin
    pulse(s,clk_in_period,space); 
   end procedure;

   procedure cntr_stop(signal s: out std_logic) is begin
    pulse(s,clk_in_period,space); 
   end procedure;

   procedure cntr_loading(signal s: out std_logic) is begin
    pulse(s,clk_in_period,space); 
   end procedure;

   procedure cntr_load_check(signal b,cload: in std_logic; edit: in std_logic) is begin
    if edit ='0' and rising_edge(b) then
      wait for 0.5 * clk_in_period;
      assert (cload='1') report "cntr load = 0" severity Error; 
    end if; 
   end procedure;

   procedure cntr_rst_on(signal s: out std_logic) is begin
    pulse(s,clk_in_period,space); 
   end procedure;

   procedure set_bcd_vector(signal u,d,l,r,c: out std_logic; current: in std_logic_vector; new_reg: in std_logic_vector) is
   variable o,n,v: integer:=0;
   begin
    pulse(c,clk_in_period,space); -- go to edit
    for i in 1 to current'length/4 loop
      o:=to_integer(unsigned(current(i*4-1 downto i*4-4))); -- old
      n:=to_integer(unsigned(new_reg(i*4-1 downto i*4-4))); -- new
      v:=o-n;
      if v<0 then
        pulse_gen(u,abs(v),clk_in_period,space); -- v up (pos i)
      elsif v>0 then
        pulse_gen(d,abs(v),clk_in_period,space); -- v down (pos i)
      end if;
      pulse_gen(l,1,clk_in_period,space); -- 1 pos left
    end loop;
    pulse(c,clk_in_period,space); -- exit edit
   end procedure;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.key_fsm_c 
        Generic MAP (D)
        PORT MAP (
          clk => clk_in,
          rst => rst,
          left => left,
          right => right,
          up => up,
          down => down,
          center => center,

          data_out => reg_out,
          cntr_en => cntr_en,
          cntr_rst => cntr_rst,
          cntr_load => cntr_load,
          edit_en_out => edit_en
        );

  -- sequential stimuli
  process 
  variable new_bcd: std_logic_vector(reg_out'range):=x"12345678";
  variable ok: boolean:=true;
  BEGIN
    -- reset all
    pulse(rst,2*clk_in_period,clk_in_period);

    for i in 1 to K loop
      new_bcd:= new_bcd(3 downto 0) & new_bcd(reg_out'left downto reg_out'right+4);
      set_bcd_vector(up,down,left,right,center, reg_out,new_bcd);
      wait for 3 * clk_in_period;
      check_bcd_vector(reg_out,new_bcd,ok);
      --if not ok then stop_after(0 ns); end if;
      cntr_start(right);
      wait for 100 * clk_in_period;
      cntr_loading(up);
      wait for 100 * clk_in_period;
      cntr_stop(left);
      wait for 100 * clk_in_period;
    end loop;
    -- reset cntr   
    cntr_rst_on(down);
    stop_after(5 * clk_in_period);
    wait;
  end process;

   -- Clock definition
   clk_gen(clk_in, offset, clk_in_period/2, clk_in_period);

   cntr_load_check(up,cntr_load,edit_en);

END;
