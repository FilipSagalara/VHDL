LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use STD.textio.all;
--USE work.pkg_symuli.all;
 
 entity key_fsm_c is 
        GENERIC (D: positive:= 8);
        PORT  (
          clk, rst, left , right, up, down,center: in std_logic;
     
          data_out: out std_logic_vector(4*D - 1 downto 0);--:=(others=>'0');
          cntr_en, cntr_rst, cntr_load, edit_en_out: out std_logic:='0'
        );

end entity;

architecture beh1 of key_fsm_c is
	type state_type is (START,STOP,RESET,IDLE,LOAD,EDIT,INC_val,DEC_val,INC_pos,DEC_pos);
	signal c_state: state_type := IDLE;
	signal n_state: state_type;
	signal inc_val1, dec_val1, inc_pos1, dec_pos1 : std_logic := '0';
		
begin
	proc: process(c_state, inc_val1, dec_val1, inc_pos1, dec_pos1, 
		      left, right, up, down, center) 
	begin

		cntr_load <= '0';
 		cntr_rst <= '0';
		inc_val1<='0'; 
		dec_val1<='0'; 
		inc_pos1<='0'; 
		dec_pos1 <='0';
	  case c_state is

			when IDLE => 
			   n_state <= IDLE;
			   
			   if left = '1' then
				n_state <= STOP;
			   else
			   end if;

			   if right = '1' then
				n_state <= START;
			   else
			   end if;

			   if up = '1' then
				n_state <= LOAD;
			   end if;

			   if down = '1' then
				n_state <= RESET;
			   end if;

			   if center = '1' then
				n_state <= EDIT;
			   end if;
			
			when EDIT => 
			   n_state <= EDIT;

			   if left = '1' then
				n_state <= INC_pos;
			   end if;

			   if right = '1' then
				n_state <= DEC_pos;
			   end if;

			   if up = '1' then
				n_state <= INC_val;
			   end if;

			   if down = '1' then
				n_state <= DEC_val;
			   end if;

			   if center = '1' then
				n_state <= LOAD;
			   end if;

			when LOAD =>
			  n_state <= IDLE;
			  cntr_load <= '1';

			when STOP =>
			  n_state <= IDLE;

			when START =>
			  n_state <= IDLE;

			when RESET =>
			  n_state <= IDLE;
			  cntr_rst <= '1';

			when INC_val =>
			  inc_val1 <= '1';
			  n_state <= EDIT;

			when DEC_val =>
			  dec_val1 <= '1';
			  n_state <= EDIT;

			when INC_pos =>
			  inc_pos1 <= '1';
			  n_state <= EDIT;

			when DEC_pos =>
			  dec_pos1 <= '1';
			  n_state <= EDIT;

		end case;

	end process;
----------------------------------------------------------------------------------------

	proc_memory: process (clk)
		type int_array is array(0 to D-1) of integer range 0 to 9;
		variable nd : int_array:=(others=>0);
		variable posit : natural range 0 to D-1 :=0 ;
		
    begin
	 if( rising_edge(clk)) then
          if (rst ='1') then 
            c_state <= IDLE;
          else c_state <= n_state ;
	    c_state <= n_state;

	    if inc_val1 = '1' then
		if nd(posit) = 9 then nd(posit) := 0; 
		else
		  nd(posit) := nd(posit) + 1;
		end if;
	    end if;
	    if dec_val1 = '1' then
		if nd(posit) = 0 then nd(posit) := 9;
		else
		  nd(posit) := nd(posit) - 1;
		end if;
	    end if;
	    if inc_pos1 = '1' then
		if posit = 7 then posit := 0; 
		else
		  posit := posit + 1;
		end if;
	    end if;
	    if dec_pos1 = '1' then
		if posit = 0 then posit := 7;
		else
		  posit := posit - 1;
		end if;
	    end if;
	    if n_state = IDLE then
		edit_en_out <= '0';
	    else
		edit_en_out <= '1';
	    end if;

	    if n_state = EDIT or n_state = STOP then
		cntr_en <= '0';
	    else 
		cntr_en <= '1';
	    end if;
    	    
    	    if n_state = LOAD then
		data_out <= std_logic_vector(to_unsigned(nd(7), 4)) & std_logic_vector(to_unsigned(nd(6),4)) 
& std_logic_vector(to_unsigned(nd(5),4)) & std_logic_vector(to_unsigned(nd(4),4)) 
& std_logic_vector(to_unsigned(nd(3),4)) & std_logic_vector(to_unsigned(nd(2),4)) 
& std_logic_vector(to_unsigned(nd(1),4)) & std_logic_vector(to_unsigned(nd(0),4));
	    end if;
           end if;
          end if;
        end process;
end architecture;