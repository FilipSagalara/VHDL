---------------------------------------------------------------------------------
-- File:        devices.vhd
-- Entity:      devices_pkg
-- Description: pakiet modeli do zajec symulacyjnych (podstawowe)
-- Author:      CCE
-- Created:     25/12/2009 (mod.2)
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

PACKAGE devices_pkg IS

  constant HI:	std_logic := '1';
  constant LO:	std_logic := '0';

  component mux4xN -- arch: with_delay
	generic (N: natural:=4;
           delay: time := 3 ns);
	PORT ( s: in std_logic_vector(1 downto 0); --! selekcja
		a,b,c,d: in std_logic_vector(N-1 downto 0);
		y: out std_logic_vector(N-1 downto 0)	);
  end component mux4xN;

  component bin2onehot -- arch: behavioral
    generic (delay: time := 3 ns);
    Port ( bin : in std_logic_vector(3 downto 0); -- liczba binarna
           onehot : out std_logic_vector(9 downto 0)); -- liczba w kodzie "1zN"
  end component bin2onehot;
  
  component seven_seg  -- arch: symulacja, synteza
    generic (delay: time := 3 ns);
    Port ( hex : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0));
  end component seven_seg;
  
  component dff -- arch: flip_flop, latch
    generic (delay: time:= 1 ns);
    Port    (clk : in std_logic;
             rst : in std_logic;
             d : in std_logic;
             q : out std_logic);
  end component dff;

  component fd_qn is -- przerzutnik d z wyjsciem zanegowanym 
    generic (delay: time:=1 ns);
    Port    (clk : in std_logic;
             rst : in std_logic; -- async
             d : in std_logic;
             q, qn : out std_logic);
  end component fd_qn;
  
  component cntr_u -- arch: behav
   GENERIC (
     N: integer:= 4; -- rozmiar licznika
     M: integer:= 9; -- warunek konca zliczania
     T: time:= 4 ns  -- czas propagacji
   );
   PORT (
     rst: in std_logic;  -- reset asynchroniczny, aktywny '1'
     ce: in std_logic;   -- clock enable
     clk: in std_logic;  -- zegar
     ceo: out std_logic; -- clock enable output
     q: out std_logic_vector(N-1 downto 0) -- wyjscie danych
   );
  end component cntr_u;

  component cb4_rel IS -- licznik binarny 4b z ladowaniem zawartosci
        GENERIC (
            T: time:= 4 ns  -- czas propagacji
        );
        PORT (
            rst: in std_logic; -- reset synchroniczny, aktywny '1'
            ce: in std_logic;  -- clock enable
            load: in std_logic;-- aktywny '1'
            clk: in std_logic; -- zegar
            din: in std_logic_vector(3 downto 0);
            ceo: out std_logic; -- clock enable output
            q: out std_logic_vector(3 downto 0) -- wyjscie danych
        );
    END component;

  component cb4_re IS -- licznik binarny 4b
        GENERIC (
            T: time:= 4 ns  -- czas propagacji
        );
        PORT (
            rst: in std_logic; -- reset synchroniczny, aktywny '1'
            ce: in std_logic;  -- clock enable
            clk: in std_logic; -- zegar
            ceo: out std_logic; -- clock enable output
            q: out std_logic_vector(3 downto 0) -- wyjscie danych
        );
    END component;

  component cb4_ce IS -- licznik binarny 4b
        GENERIC (
            T: time:= 4 ns  -- czas propagacji
        );
        PORT (
            rst: in std_logic; -- reset asynchroniczny, aktywny '1'
            ce: in std_logic;  -- clock enable
            clk: in std_logic; -- zegar
            ceo: out std_logic; -- clock enable output
            q: out std_logic_vector(3 downto 0) -- wyjscie danych
        );
    END component;

END package devices_pkg;


---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

PACKAGE BODY devices_pkg IS

end package body devices_pkg;
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fd_qn is
    generic (delay: time:=1 ns);
    Port    (clk : in std_logic;
             rst : in std_logic; -- async
             d : in std_logic;
             q, qn : out std_logic);
end entity fd_qn;

architecture flip_flop of fd_qn is

begin
process(clk,rst)
    begin
    if rst='1' then
        q <='0' after delay;
        qn<='1' after delay;
    elsif rising_edge(clk) then
        q <= d after delay;
        qn<= not d after delay;
    end if; 
 end process;
end architecture flip_flop;

---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
    generic (delay: time:=1 ns);
    Port    (clk : in std_logic;
             rst : in std_logic;
             d : in std_logic;
             q : out std_logic);
end entity dff;

architecture flip_flop of dff is

begin
process(clk,rst)
	begin
	if rst='1' then
		q<='0' after delay;
		elsif clk='1' and clk'event then
		q<=d after delay;
	end if;	
	end process;
end architecture flip_flop;

architecture latch of dff is

begin
process(clk,rst,d)
	begin
	if rst='1' then
		q<='0' after delay;
		elsif clk='1' then
		q<=d after delay;
	end if;	
	end process;
end architecture latch;
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2onehot is
    generic (delay: time := 3 ns);
    Port ( bin : in std_logic_vector(3 downto 0); -- liczba binarna
           onehot : out std_logic_vector(9 downto 0)); -- liczba w kodzie "1zN"
end entity bin2onehot;

architecture Behavioral of bin2onehot is
signal onehot_s: std_logic_vector(onehot'range);
begin
   onehot<= onehot_s after delay;
   with bin select
	onehot_s<="0000000001" when "0000", --0
		"0000000010" when "0001",	--1
		"0000000100" when "0010",	--2
		"0000001000" when "0011",	--3
		"0000010000" when "0100",	--4
		"0000100000" when "0101",	--5
		"0001000000" when "0110",	--6
		"0010000000" when "0111",	--7
		"0100000000" when "1000",	--8
		"1000000000" when "1001",	--9
		"1111111111" when others;	--error
end architecture Behavioral;
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_seg is
    generic (delay: time := 3 ns);
    Port ( hex : in std_logic_vector(3 downto 0);
           seg : out std_logic_vector(6 downto 0));
end entity seven_seg;

architecture symulacja of seven_seg is
type liczba is (empty,zero,jeden,dwa,trzy,cztery,piec,szesc,siedem,osiem,dziewiec,A,b,C,d,E,F);
signal hex_i: liczba;
signal seg_s: std_logic_vector(seg'range);

begin
  seg <= seg_s after delay;
   with hex_i select               --        0
	seg_s <=  "0000110" when jeden,--      -----
		"1011011" when dwa,	       --    5|     |1
		"1001111" when trzy,	   --     |  6  |
		"1100110" when cztery,	   --      -----
		"1101101" when piec,  	   --    4|     |2
		"1111101" when szesc,	   --     |     |
		"0000111" when siedem,	   --      -----
		"1111111" when osiem,	   --        3
        "1101111" when dziewiec,   --
        "0111111" when zero,
        "1110111" when A,
        "1111100" when b,
        "0111001" when C,
        "1011110" when d,
        "1111001" when E,
        "1110001" when F,
        "0000000" when others
        ;	   --

   with hex select
	hex_i <= jeden when "0001",  --1
		dwa when "0010",	     --2
		trzy when "0011",	     --3
		cztery when "0100",	     --4
		piec when "0101",	     --5
		szesc when "0110",	     --6
		siedem when "0111",	     --7
		osiem when "1000",	     --8
        dziewiec when "1001",    --9
        zero when "0000",    --0
        A when "1010",    --a
        b when "1011",    --b
        C when "1100",    --c
        d when "1101",    --d
        E when "1110",    --e
        F when "1111",    --f
		empty when others;	     --null
		
end architecture symulacja;

architecture synteza of seven_seg is
signal seg_s: std_logic_vector(seg'range);

begin
  seg <= seg_s after delay;
   with hex select                 --        0
	seg_s <= "0000110" when "0001",--      -----
		"1011011" when "0010",     --    5|     |1
		"1001111" when "0011",	   --     |  6  |
		"1100110" when "0100",	   --      -----
		"1101101" when "0101",	   --    4|     |2
		"1111101" when "0110",	   --     |     |
		"0000111" when "0111",     --      -----
		"1111111" when "1000",	   --        3
		"1101111" when "1001",	   --
        "0111111" when "0000",
        "1110111" when "1010",
        "1111100" when "1011",
        "0111001" when "1100",
        "1011110" when "1101",
        "1111001" when "1110",
        "1110001" when "1111",
        "0000000" when others
        ;      --
end architecture synteza;
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY cntr_u IS -- licznik uniwersalny
	GENERIC (
		N: integer:= 4; -- rozmiar licznika
		M: integer:= 9; -- warunek konca zliczania
		T: time:= 4 ns  -- czas propagacji
	);
	PORT (
		rst: in std_logic; -- reset asynchroniczny, aktywny '1'
		ce: in std_logic;  -- clock enable
		clk: in std_logic;  -- zegar
    ceo: out std_logic; -- clock enable output
    q: out std_logic_vector(N-1 downto 0) -- wyjscie danych
	);
END ENTITY cntr_u;

ARCHITECTURE behav OF cntr_u IS
  signal s_q: std_logic_vector(N-1 downto 0);

 BEGIN

 q_cnt:PROCESS (clk, rst)
	BEGIN
		IF rst='1' THEN
			s_q<=conv_std_logic_vector(0,N);
		ELSIF clk'event and clk='1' THEN
			IF ce='1' THEN
				if s_q = M then
				s_q<=conv_std_logic_vector(0,N);
				else
				s_q<=s_q+1;
				end if;
			END IF ;
		END IF ;
	END PROCESS;

 q <= s_q after T;
 ceo <= '1' after T when ((s_q = M) and (ce='1')) else '0' after T;
END ARCHITECTURE behav;
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux4xN IS
  generic (N: natural:=4;
           delay: time := 3 ns);
  PORT ( s: in std_logic_vector(1 downto 0); --! selekcja
    a,b,c,d: in std_logic_vector(N-1 downto 0);
    y: out std_logic_vector(N-1 downto 0) );
END ENTITY mux4xN;

ARCHITECTURE with_delay OF mux4xN IS

BEGIN
mux : PROCESS ( a,b,c,d,s)
	BEGIN
		IF s = "00" THEN
			y <= d after delay;
		ELSIF s = "01" THEN
			y <= c after delay;
		ELSIF s = "10" THEN
			y <= b after delay;
		ELSE 
			y <= a after delay;
		END IF ;
END PROCESS;

END ARCHITECTURE with_delay;
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY cb4_ce IS -- licznik binarny 4b
    GENERIC (
        T: time:= 4 ns  -- czas propagacji
    );
    PORT (
        rst: in std_logic; -- reset asynchroniczny, aktywny '1'
        ce: in std_logic;  -- clock enable
        clk: in std_logic; -- zegar
        ceo: out std_logic; -- clock enable output
        q: out std_logic_vector(3 downto 0) -- wyjscie danych
    );
END ENTITY;

ARCHITECTURE behav OF cb4_ce IS
signal s_q: std_logic_vector(q'range):=(others=>'0');

BEGIN
q <= s_q after T;
ceo <= ce and s_q(3) and s_q(2) and s_q(1) and s_q(0) after T;
q_cnt:PROCESS (clk, rst)
    BEGIN
        IF rst='1' THEN
            s_q<=x"0";
        ELSIF rising_edge(clk) THEN
            IF ce='1' THEN
               s_q<=s_q+1;
            END IF ;
        END IF ;
    END PROCESS;

END ARCHITECTURE behav;
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY cb4_re IS -- licznik binarny 4b
    GENERIC (
        T: time:= 4 ns  -- czas propagacji
    );
    PORT (
        rst: in std_logic; -- reset synchroniczny, aktywny '1'
        ce: in std_logic;  -- clock enable
        clk: in std_logic; -- zegar
        ceo: out std_logic; -- clock enable output
        q: out std_logic_vector(3 downto 0) -- wyjscie danych
    );
END ENTITY;

ARCHITECTURE behav OF cb4_re IS
signal s_q: std_logic_vector(q'range):=(others=>'0');

BEGIN
q <= s_q after T;
ceo <= ce and s_q(3) and s_q(2) and s_q(1) and s_q(0) after T;

q_cnt:PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst='1' THEN
                s_q<=x"0";
            elsif ce='1' THEN
               s_q<=s_q+1;
            END IF ;
        END IF ;
    END PROCESS;

END ARCHITECTURE behav;
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY cb4_rel IS -- licznik binarny 4b z ladowaniem zawartosci
    GENERIC (
        T: time:= 4 ns  -- czas propagacji
    );
    PORT (
        rst: in std_logic; -- reset synchroniczny, aktywny '1'
        ce: in std_logic;  -- clock enable
        load: in std_logic;-- aktywny '1'
        clk: in std_logic; -- zegar
        din: in std_logic_vector(3 downto 0);
        ceo: out std_logic; -- clock enable output
        q: out std_logic_vector(3 downto 0) -- wyjscie danych
    );
END ENTITY;

ARCHITECTURE behav OF cb4_rel IS
signal s_q: std_logic_vector(q'range):=(others=>'0');

BEGIN
q <= s_q after T;
ceo <= ce and s_q(3) and s_q(2) and s_q(1) and s_q(0) after T;

q_cnt:PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst='1' THEN
                s_q<=x"0";
            elsif load='1' THEN
                s_q<=din;
            elsif ce='1' THEN
               s_q<=s_q+1;
            END IF ;
        END IF ;
    END PROCESS;

END ARCHITECTURE behav;
------------------------------------------------------------------------------