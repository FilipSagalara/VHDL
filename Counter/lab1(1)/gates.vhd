-- VHDL Components Package of primitive gates
-- v.2.0

library ieee;
use ieee.std_logic_1164.all;

package gates_pkg is

component and2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component and2;
 
component and3
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1: out std_logic);
end component and3;
 	
component and4
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4 : in std_logic;
        out1: out std_logic);
end component and4; 

component and5
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1: out std_logic);
end component and5;

component inverter
  generic(Tpd: delay_length:=1 ns);
   port(in1: in std_logic; out1: out std_logic);
end component inverter;
 
component or2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component or2;
 
component or3
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1: out std_logic);
end component or3;
 	
component or4
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4 : in std_logic;
        out1: out std_logic);
end component or4; 

component or5
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1: out std_logic);
end component or5;

component nand2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component nand2;
  
component nand3
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1: out std_logic);
end component nand3;
 	
component nand4
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4 : in std_logic;
        out1: out std_logic);
end component nand4;
 
component nand5
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1: out std_logic);
end component nand5;

component nand6
  generic(Tpd: delay_length:=6 ns);
   port(in1, in2, in3, in4, in5, in6: in std_logic;
        out1: out std_logic);
end component nand6;
 
component nor2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component nor2;
 
component nor3
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1: out std_logic);
end component nor3; 
	
component nor4
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4 : in std_logic;
        out1: out std_logic);
end component nor4; 

component nor5
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1: out std_logic);
end component nor5;

component not1
  generic(Tpd: delay_length:=1 ns);
   port(in1: in std_logic; out1: out std_logic);
end component not1;

component xor2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component xor2;

component xnor2
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1: out std_logic);
end component xnor2;
 
end package gates_pkg;
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

PACKAGE BODY gates_pkg IS

end package body gates_pkg;
---------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
entity and2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2 : in std_logic;
        out1 : out std_logic);
end entity and2;

architecture dataflow of and2 is
begin
   out1 <= in1 and in2 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity and3 is
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1 : out std_logic);
end entity and3;

architecture dataflow of and3 is
begin
   out1 <= in1 and in2 and in3 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity and4 is
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4: in std_logic;
        out1 : out std_logic);
end entity and4;

architecture dataflow of and4 is
begin
   out1 <= in1 and in2 and in3 and in4 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity and5 is
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1 : out std_logic);
end entity and5;

architecture dataflow of and5 is
begin
   out1 <= in1 and in2 and in3 and in4 and in5 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity or2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1 : out std_logic);
end entity or2;

architecture dataflow of or2 is
begin
   out1 <= in1 or in2 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity or3 is
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1 : out std_logic);
end entity or3;

architecture dataflow of or3 is
begin
   out1 <= in1 or in2 or in3 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity or4 is
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4: in std_logic;
        out1 : out std_logic);
end entity or4;

architecture dataflow of or4 is
begin
   out1 <= in1 or in2 or in3 or in4 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity or5 is
  generic(Tpd: delay_length:=5 ns);
   port(in1, in2, in3, in4, in5 : in std_logic;
        out1 : out std_logic);
end entity or5;

architecture dataflow of or5 is
begin
   out1 <= in1 or in2 or in3 or in4 or in5 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity inverter is
  generic(Tpd: delay_length:=1 ns);
   port(in1 : in std_logic;
        out1 : out std_logic);
end entity inverter;

architecture dataflow of inverter is
begin
   out1 <= not in1 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nand2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1 : out std_logic);
end entity nand2;

architecture dataflow of nand2 is
begin
   out1 <= not (in1 and in2) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nand3 is
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1 : out std_logic);
end entity nand3;

architecture dataflow of nand3 is
begin
   out1 <= not (in1 and in2 and in3) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nand4 is
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4: in std_logic;
        out1 : out std_logic);
end entity nand4;

architecture dataflow of nand4 is
begin
   out1 <= not (in1 and in2 and in3 and in4) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nand5 is
  generic(Tpd: delay_length:=5 ns);
   port (in1, in2, in3, in4, in5 : in std_logic;
        out1 : out std_logic);
end entity nand5;

architecture dataflow of nand5 is
begin
   out1 <= not (in1 and in2 and in3 and in4 and in5) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nor2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2: in std_logic;
        out1 : out std_logic);
end entity nor2;

architecture dataflow of nor2 is
begin
   out1 <= in1 nor in2 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nor3 is
  generic(Tpd: delay_length:=3 ns);
   port(in1, in2, in3 : in std_logic;
        out1 : out std_logic);
end entity nor3;

architecture dataflow of nor3 is
begin
   out1 <= not (in1 or in2 or in3) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nor4 is
  generic(Tpd: delay_length:=4 ns);
   port(in1, in2, in3, in4: in std_logic;
        out1 : out std_logic);
end entity nor4;

architecture dataflow of nor4 is
begin
   out1 <= not (in1 or in2 or in3 or in4) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity nor5 is
  generic(Tpd: delay_length:=5 ns);
   port (in1, in2, in3, in4, in5 : in std_logic;
        out1 : out std_logic);
end entity nor5;

architecture dataflow of nor5 is
begin
   out1 <= not (in1 or in2 or in3 or in4 or in5) after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity not1 is
  generic(Tpd: delay_length:=1 ns);
   port(in1 : in std_logic;
        out1 : out std_logic);
end entity not1;

architecture dataflow of not1 is
begin
   out1 <= not in1 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity xor2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2 : in std_logic;
        out1 : out std_logic);
end entity xor2;

architecture dataflow of xor2 is
begin
   out1 <= in1 xor in2 after Tpd;
end architecture dataflow;

library ieee;
use ieee.std_logic_1164.all;
entity xnor2 is
  generic(Tpd: delay_length:=2 ns);
   port(in1, in2 : in std_logic;
        out1 : out std_logic);
end entity xnor2;

architecture dataflow of xnor2 is
begin
   out1 <= not (in1 xor in2) after Tpd;
end architecture dataflow;
