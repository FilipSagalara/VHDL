library ieee;
use ieee.std_logic_1164.all;
use work.gates_pkg.all;
use work.devices_pkg.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod_141256x1 is
  port (reset: in std_logic;
 	clk: in std_logic;
 	ce: in std_logic;
	wyjscie: out std_logic);
end entity mod_141256x1;

architecture struct of mod_141256x1 is
--wyjscia bramek and
 signal and2_5_out: std_logic; 
 signal and2_6_5_out: std_logic; 
 signal and3_1_out: std_logic; 
 signal and3_2_out: std_logic; 

-- signal ce: in std_logic;
 signal ce_out: std_logic_vector(5 downto 0);
 signal reset_ctr: std_logic:='0';
 signal new_round:std_logic;


-- wyjscia licznikow: 
 signal counter_6_1: std_logic_vector(3 downto 0); 
 signal counter_5_4: std_logic_vector(3 downto 0); 
 signal counter_4_1: std_logic_vector(3 downto 0); 
 signal counter_3_2: std_logic_vector(3 downto 0); 
 signal counter_2_5: std_logic_vector(3 downto 0); 
 signal counter_1_6: std_logic_vector(3 downto 0); 


begin
 -- liczniki:
 inst_counter1: cntr_u port map(rst=>reset_ctr, ce=>ce, clk=>clk, ceo=>ce_out(5), q=>counter_1_6);
 inst_counter2: cntr_u port map(rst=>reset_ctr, ce=>ce_out(5), clk=>clk, ceo=>ce_out(4), q=>counter_2_5);
 inst_counter3: cntr_u port map(rst=>reset_ctr, ce=>ce_out(4), clk=>clk, ceo=>ce_out(3), q=>counter_3_2);
 inst_counter4: cntr_u port map(rst=>reset_ctr, ce=>ce_out(3), clk=>clk, ceo=>ce_out(2), q=>counter_4_1);
 inst_counter5: cntr_u port map(rst=>reset_ctr, ce=>ce_out(2), clk=>clk, ceo=>ce_out(1), q=>counter_5_4);
 inst_counter6: cntr_u port map(rst=>reset_ctr, ce=>ce_out(1), clk=>clk, ceo=>ce_out(0), q=>counter_6_1);

--bramki and:
 and2_5: and2 port map(in1=>counter_2_5(0), in2=>counter_2_5(2), out1=>and2_5_out);
 and2_6_5: and2 port map(in1=>counter_1_6(1), in2=>counter_1_6(2), out1=>and2_6_5_out);
 and3_1: and3 port map(in1=>counter_6_1(0), in2=>counter_5_4(2), in3=>counter_4_1(0), out1=>and3_1_out);
 and3_2: and3 port map(in1=>counter_3_2(1), in2=>and2_5_out, in3=>and2_6_5_out, out1=>and3_2_out);
 and2_result: and2 port map(in1=>and3_1_out, in2=>and3_2_out, out1=>wyjscie);

 or2_res: or2 port map(in1=>new_round, in2=>reset, out1=>reset_ctr);

end architecture struct;    