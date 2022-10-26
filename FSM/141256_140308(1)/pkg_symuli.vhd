-------------------------------------------------------------------------------
-- Project: ---
-- Author(s): HusTakocem
-- Created: Feb 2019
-------------------------------------------------------------------------------
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.all;

Package pkg_symuli Is

-- synthesis translate off
----             _____hpulse______
-- ____offset___/                 \___period-hpulse_____/
---
procedure clk_gen (signal s: out std_ulogic; offset,hpulse,period: delay_length );

----_____hpulse______
-- /                 \_____lpulse______/  x number
---
procedure pulse_gen (signal s: out std_ulogic; number: natural; hpulse,lpulse: delay_length);

----_____hpulse______
-- /                 \_____space______
---
procedure pulse (signal s: out std_ulogic; hpulse,space: delay_length);

----                    _____hpulse______
-- x n_of_bounce /\/\/\/                 \/\/\/\_____space______ 
---
procedure bounced_pulse (signal s: out std_ulogic; n_of_bounce: natural; bounce,hpulse,space: delay_length);

-- 7-seg decoder
function decode7 (hex: std_logic_vector(6 downto 0); neg: boolean:=true) return character;
function decodeAN (an: std_logic_vector; neg: boolean:=true) return character;
function decodeANi (an: std_logic_vector; neg: boolean:=true) return natural;

procedure print(str : in string);
procedure write_bcd_info(bcd: in std_logic_vector; expected: in string);
procedure check_bcd_vector(bcd: in std_logic_vector; expected: in std_logic_vector; result: out boolean);
procedure stop_after(t: in time);

-- synthesis translate on
End Package pkg_symuli;

---------------------------------------------------------------------------------------------------------

PACKAGE BODY pkg_symuli IS
-- synthesis translate off
----             _____hpulse______
-- ____offset___/                 \___period-hpulse_____/
---
procedure clk_gen (signal s: out std_ulogic; offset,hpulse,period: delay_length ) is
 begin
  wait for offset;
    loop
        s <= '1', '0' after hpulse;
        wait for period; end loop;
 end procedure;

----_____hpulse______
-- /                 \_____lpulse______/  x number
---
procedure pulse_gen (signal s: out std_ulogic; number: natural; hpulse,lpulse: delay_length) is
begin
    for i in 1 to number loop
        s <= '1', '0' after hpulse;
        wait for hpulse + lpulse; end loop;
end procedure;    

----_____hpulse______
-- /                 \_____space______
---
procedure pulse (signal s: out std_ulogic; hpulse,space: delay_length) is
begin
        s <= '1', '0' after hpulse;
        wait for hpulse + space; 
end procedure;    

----                    _____hpulse______
-- x n_of_bounce /\/\/\/                 \/\/\/\_____space______ 
---
procedure bounced_pulse (signal s: out std_ulogic; n_of_bounce: natural; bounce,hpulse,space: delay_length) is
begin
    for i in 1 to n_of_bounce loop
        s <= '1', '0' after bounce/2;
        wait for bounce; end loop;
    s <= '1', '0' after hpulse;
    wait for hpulse;
    for i in 1 to n_of_bounce loop
        s <= '1', '0' after bounce/2;
        wait for bounce; end loop;
    wait for space; 
end procedure;    

-- 7-seg decoder
function decode7 (hex: std_logic_vector(6 downto 0); neg: boolean:=true) return character is
variable byte: std_logic_vector(7 downto 0);
variable c: character;
begin
    if neg then
        byte:='0' & not(hex);
    else 
        byte:='0' & hex;
    end if;
    case byte is
        when x"3f" => c:='0';
        when x"06" => c:='1';
        when x"5b" => c:='2';
        when x"4f" => c:='3';
        when x"66" => c:='4';
        when x"6d" => c:='5';
        when x"7d" => c:='6';
        when x"07" => c:='7';
        when x"7f" => c:='8';
        when x"6f" => c:='9';
        when x"77" => c:='a';
        when x"7c" => c:='b';
        when x"39" => c:='c';
        when x"5e" => c:='d';
        when x"79" => c:='e';
        when x"71" => c:='f';
        when others => c:='-';
    end case;
    return c;
end function;

function decodeAN (an: std_logic_vector; neg: boolean:=true) return character is
variable onehot: std_logic_vector(an'range);
variable c: character;
begin
    if neg then
        onehot:= not(an);
    else 
        onehot:= an;
    end if;
    for i in an'range loop
        if onehot(i)='1' then
            c:=integer'image(i)(1);
            return c;
        end if;
    end loop;
    return '-';
end function;

function decodeANi (an: std_logic_vector; neg: boolean:=true) return natural is
variable onehot: std_logic_vector(an'range);
variable p: natural;
begin
    if neg then
        onehot:= not(an);
    else 
        onehot:= an;
    end if;
    for i in an'range loop
        if onehot(i)='1' then
            p:=i;
            return p;
        end if;
    end loop;
    return 99;
end function;

procedure print(str : in string) is
    variable oline : line;
  begin
    write(oline, str);
    writeline(output, oline);
end procedure;

procedure write_bcd_info(bcd: in std_logic_vector; expected: in string) is
constant J: positive:=(bcd'left+1) /4;
variable L : LINE;
begin
  write(L, STRING'("Expected:"), LEFT, 15);
  write(L, STRING'("Actual:"),   LEFT, 15);
  writeline(OUTPUT,L);
  write(L,expected,LEFT,15);
  for i in J downto 1 loop
    write(L, to_integer(unsigned(bcd(i*4-1 downto i*4-4))));
  end loop;
  writeline(OUTPUT,L);
end procedure;

procedure check_bcd_vector(bcd: in std_logic_vector; expected: in std_logic_vector; result: out boolean) is
constant J: positive:=(bcd'left+1) /4;
variable L : LINE;
begin
  write(L, STRING'("Expected:"), LEFT, 15);
  write(L, STRING'("Actual:"),   LEFT, 15);
  writeline(OUTPUT,L);
  for i in J downto 1 loop
    write(L, to_integer(unsigned(expected(i*4-1 downto i*4-4))));
  end loop;
  write(L,string'(" "),LEFT,7);
  for i in J downto 1 loop
    write(L, to_integer(unsigned(bcd(i*4-1 downto i*4-4))));
  end loop;
  write(L,string'(" "),LEFT,3);
  if bcd /= expected then
    write(L, STRING'("_ERROR_"),   LEFT, 8);
    result:=false;
  else 
    write(L, STRING'("_OK_"),   LEFT, 8);
    result:=true;
  end if;
  writeline(OUTPUT,L);
  write(L,now,UNIT=>ns);
  writeline(OUTPUT,L);
end procedure;

procedure stop_after(t: in time) is
begin
    wait for t;
    stop(2);
end procedure;

-- synthesis translate on
end package body pkg_symuli;
---------------------------------------------------------------------------