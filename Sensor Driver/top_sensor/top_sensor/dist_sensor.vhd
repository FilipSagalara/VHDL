--------------------------------------
-- Filip Kozlowski & Filip Sagalara
-- 141256 & 140308 
-- 17.05.2022
-- czujnik odleglosci hc_sr04 z uyciem divide jako jesdnostki obliczeniowej do dzielenia
--------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
use STD.textio.all; 

entity dist_sensor is

generic(
	F_CLK: positive:= 10E6;
	N: positive := 16;
	DIVIDE_CONST: integer := 5800-- number to calculate the final distance in cm
); port( 
------------ interfejs uzytkownika 
	clk: in std_logic; 
	rst: in std_logic; 
	mode: in std_logic; 
	start:in std_logic; 
	bin: out std_logic_vector(N-1 downto 0) := (others =>'0'); 

------------ interfejs czujnika 
	trig: out std_logic; 
	echo: in std_logic
);

end dist_sensor;

architecture behavioral of dist_sensor is
--signals

    signal count, count_wait: integer range 0 to 1002 :=0;
    signal tmpbin: std_logic_vector(N-1 downto 0) := (others => '1');
    signal echo_time: std_logic_vector(N-1 downto 0) := (others => '0');

    type state_type is (RUNNING,RESET,IDLE, STEP);
	signal c_state: state_type := IDLE;
	signal n_state: state_type;
	signal s_step: std_logic := '0';

	-- divide
	signal divide_out, divide_rmdr: std_logic_vector(N-1 DOWNTO 0):= (others => '0');
	signal divide_b: std_logic_vector(N-1 DOWNTO 0) := std_logic_vector(to_unsigned(DIVIDE_CONST,N));
	signal divide_err: std_logic;

begin

inst_divide: entity work.divide 
generic map (N => N)
port map
(
	a => tmpbin,
	b => divide_b, --"0000101101010100",--"0001011010100111",
    y => divide_out,
    Rmdr => divide_rmdr,
    Err => divide_err
);

process(clk, c_state, start, mode, rst)
begin
	
	case c_state is

		when IDLE => 
		   n_state <= IDLE;
			   
 		   if mode = '0' then
			n_state <= RUNNING;
		   end if;
		   if rst = '1' then
			n_state <= RESET;
		   end if;
		   if mode = '1' then
		    s_step <= '1';
		   	n_state <= STEP;
		   end if;

		when RUNNING =>
			n_state <= RUNNING;

		    if rst = '1' then
				n_state <= RESET;
		    end if;

		when RESET =>
			n_state <= IDLE;

		when STEP =>
			n_state <= STEP;

			if mode = '0' then
				n_state <= IDLE;
			end if;
		end case;
end process;
----------------------------------------------------------------------------------------

proc_memory: process(clk)
begin
 	if rising_edge(clk) then
 	 	if (rst ='1') then 

 	 		trig <= '0';
        	count <= 0;
        	echo_time <= (others =>'0');
        	tmpbin <= (others =>'0');
			bin <= (others => '0');
			count_wait <= 0;
        
      	else 
     		c_state <= n_state;
	  	end if; 

        if mode = '1' then

        	if start = '1' then 

	        	trig <= '1';
    	        if count = 1000 then 
        	    	
        	    	trig <= '0';
            	    
					--echo_time <= (others => '0');
            	    if echo = '1' then 
						echo_time <= echo_time + 1;
					else
						tmpbin <= echo_time;
						
	    				count <= 0;
	    			end if;

        	    else
	        	    --bin <= divide_out;
        	    	count <= count + 1; 

				end if;
			end if;    

    	else
           trig <= '1';
    	       if count = 1000 then 
        	    	
        	    	trig <= '0';
					
					echo_time <= (others => '0');

            	    if echo = '1' then 
						echo_time <= echo_time + 1;
					else
						
						tmpbin <= echo_time;
						
						count <= 0;
	    			end if;

        	    else
        	    	count <= count + 1; 

				end if;
        end if;      
    end if;           

    bin <= divide_out;         
end process;

end architecture;