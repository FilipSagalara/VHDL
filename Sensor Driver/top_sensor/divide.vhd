LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Divide IS
  GENERIC (n: integer := 8);
  PORT (a,b: IN std_logic_vector(n-1 DOWNTO 0);
        y: OUT std_logic_vector(n-1 DOWNTO 0);
        Rmdr: OUT std_logic_vector(n-1 DOWNTO 0);
        Err: OUT std_logic);
END Divide;

ARCHITECTURE combi OF Divide IS
BEGIN

   PROCESS(a,b)
      VARIABLE Tmp: std_logic_vector(n-1 DOWNTO 0);
      VARIABLE var_a: std_logic_vector(n-1 DOWNTO 0);
      VARIABLE Tmp2: std_logic_vector(n-1 DOWNTO 0);
      VARIABLE Tmp3: std_logic_vector(n-1 DOWNTO 0);
   BEGIN
      var_a := a;
      div_loop: FOR i IN n-1 DOWNTO 0 LOOP
         Tmp :=std_logic_vector (conv_unsigned (unsigned (var_a(n-1 DOWNTO i)),n)); 
         IF Tmp >= b THEN 
            Tmp2(i) := '1';
            Tmp3 := Tmp - b; 
            IF i /= 0 THEN 
               var_a(n-1 DOWNTO i) := Tmp3(n-1-i downto 0);
               var_a(i-1) := a(i-1); 
            END IF; 
         ELSE 
            Tmp2(i) := '0';
            Tmp3 := Tmp;
         END IF; 
      END LOOP; 
      Rmdr <= Tmp3; 
      y <= Tmp2;
   END PROCESS; 
   Err <= '1' WHEN (b = (conv_std_logic_vector(0,n))) ELSE '0';
   
END combi;