----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2019 09:02:21
-- Design Name: 
-- Module Name: INTMM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
library WORK;

entity INTLVD_RED is
Port ( CLK : IN std_logic;
       RST : IN std_logic;
       X : IN  std_logic_vector(254 DOWNTO 0);
       Y : IN  std_logic_vector(254 DOWNTO 0);
       Z : OUT std_logic_vector(254 DOWNTO 0)
 );
end INTLVD_RED;

architecture Behavioral of INTLVD_RED is
type STATE is (ST0,ST1,ST2,ST3,ST4,ST5,ST6,ST7);
signal ST: STATE;

signal S1,C1 : std_logic_vector(254  downto 0); 
signal S2,C2 : std_logic_vector(258  downto 0); 
signal S3,C3 : std_logic_vector(259  downto 0); 
signal S,C   : std_logic_vector(259  downto 0); 
signal YLUT  : std_logic_vector(254  downto 0); 
signal PLUT  : std_logic_vector(10  downto 0);
signal SELP  : std_logic_vector(3 downto 0);
signal SZ    : std_logic_vector(259  downto 0);
signal SELY  : std_logic_vector(2 downto 0);
signal RESET : std_logic;
signal EN : std_logic;
signal k : integer;
component CSA1 is
generic(w: integer := 258);
port(
X:        IN  std_logic_vector(w-4 DOWNTO 0);
Y:        IN  std_logic_vector(w-4 DOWNTO 0);
Z:        IN  std_logic_vector(w-4 DOWNTO 0);
S:        OUT std_logic_vector(w   DOWNTO 0);
C:        OUT std_logic_vector(w   DOWNTO 0));
end component CSA1;

component CSA2 is
generic(w: integer := 259);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        IN  std_logic_vector(10  DOWNTO 0);
S:        OUT std_logic_vector(w   DOWNTO 0);
C:        OUT std_logic_vector(w   DOWNTO 0));
end component CSA2;

component REGCSA is
generic(w: integer:= 255);
Port(
CLK:    IN  std_logic;
RST:    IN  std_logic;
X:      IN  std_logic_vector(w-1 downto 0);
Z:      OUT std_logic_vector(w-1 downto 0)
); 
end component REGCSA;

component SELUNIT is
Port (
C:     IN  std_logic_vector(3 downto 0);
S:     IN  std_logic_vector(3 downto 0);
SEL:   OUT std_logic_vector(3 downto 0) );
end component SELUNIT;

component LUT_P is
Port ( SELP : in  std_logic_vector( 3 downto 0);
       POUT : out std_logic_vector(10 downto 0)
      );
end component LUT_P;

component LUT_Y is
Port ( RST : in std_logic;
       SELY: in  std_logic_vector(2 downto 0);
       Y   : in  std_logic_vector(254 downto 0);
       YOUT: out std_logic_vector(254 downto 0)
      );
end component LUT_Y;

component REDUCER is
Port ( EN: in std_logic;
       S   : in std_logic_vector(259 downto 0);
       Z   : out std_logic_vector(254 downto 0)
 );
end component REDUCER;

begin
U1: CSA1     generic map( w => 258) port map( X=> S(254 downto 0), Y=>C(254 downto 0), Z=> YLUT, S => S2, C=>C2);
U2: CSA2     generic map( w => 259) port map( X=> S2, Y=>C2, Z=> PLUT, S => S3, C => C3); 
U3: REGCSA   generic map( w => 260) port map(CLK => CLK, RST => RESET, X=> S3, Z=> S);
U4: REGCSA   generic map( w => 260) port map(CLK => CLK, RST => RESET, X=> C3, Z=> C);
U5: SELUNIT                         port map(S => S(258 downto 255), C => C(258 downto 255),SEL=> SELP);
U6: LUT_P                           port map(SELP=> SELP, POUT => PLUT);
U7: LUT_Y                           port map(RST => RST, SELY=> SELY, Y =>Y , YOUT => YLUT);
U8: REDUCER                         port map( EN=> EN, S=>SZ(259 downto 0), Z=>Z(254 downto 0));


process(CLK, RST)
begin
if RST ='0'then 
   RESET <= '0';
   SELY <="000";
   EN <= '0';
   ST <= ST0;
   k <= 85;
   SZ <= (others =>'0');
elsif CLK='1' and CLK'event then 
case ST is 
    when ST0 =>
         RESET <= '1';
         ST  <= ST1;
    when ST1 => 
         ST <= ST2;  
    when ST2 => 
         ST <= ST3;  
    when ST3 => 
         ST <= ST4; 
    when ST4 => 
         ST <= ST5;                
    when ST5 => 
         if k > 0 then
            SELY <= X(3*k-1 downto 3*k-3);
            k<= k-1;
            ST <= ST5;
         else        
             ST <= ST6;
         end if;
    when ST6 => 
         EN <='1';   
         SZ <= S+C;  
         ST <= ST7;
    when ST7 =>
         ST<= ST7;                  
end case;   
end if;
end process;
end Behavioral;

------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
library WORK;

entity CSA1 is
generic(w: integer := 258);
port(
X:        IN  std_logic_vector(w-4 DOWNTO 0);
Y:        IN  std_logic_vector(w-4 DOWNTO 0);
Z:        IN  std_logic_vector(w-4 DOWNTO 0);
S:        OUT std_logic_vector(w   DOWNTO 0);
C:        OUT std_logic_vector(w   DOWNTO 0));
end CSA1;

Architecture Behavioral of CSA1 is
signal Z1: std_logic_vector( w-1 downto 0);
begin
Z1 <= "000"& Z;
--- Z to LUTY , X,Y to INPUTS.
--- X and Y are  modulu 2^255 then shifted left by 3.
S <= '0' & ((X(w-4 downto 0) XOR Y(w-4 downto 0)) XOR Z1(w-1 downto 3)) & Z1(2)&Z1(1)&Z1(0);
C <= (((X(w-4 downto 0) AND Y(w-4 downto 0))) OR (X(w-4 downto 0) AND Z1(w-1 downto 3)) OR (Y(w-4 downto 0) AND Z1(w-1 downto 3)))& "0000";
end Behavioral;

---------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
library WORK;


entity CSA2 is
generic(w: integer := 259);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        IN  std_logic_vector(10  DOWNTO 0);
S:        OUT std_logic_vector(w   DOWNTO 0);
C:        OUT std_logic_vector(w   DOWNTO 0));
end CSA2;

Architecture Behavioral of CSA2 is
signal S1,C1 : std_logic_vector(w-1 DOWNTO 0);
signal S2,C2,C3,C4 : std_logic_vector(10  DOWNTO 0);

begin
S1 <= X xor Y;
S2 <= S1(10 downto 0) xor Z(10 downto 0);
S <= '0' & S1(w-1 downto 11) & S2;
C1 <= X and Y;
C2 <= X(10 downto 0) and Z(10 downto 0);
C3 <= Y(10 downto 0) and Z(10 downto 0);
C4 <= C2 or C3 or C1(10 downto 0);
C <= C1(w-1 downto 11)& C4(10 downto 0)& '0';
end Behavioral;
---------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
library WORK;
--use WORK.MMPACK.all;

entity REGCSA is
generic(w: integer:= 260);
Port(
CLK:    IN  std_logic;
RST:    IN  std_logic;
X:      IN  std_logic_vector(w-1 downto 0);
Z:      OUT std_logic_vector(w-1 downto 0)
); 
end REGCSA;

architecture Behavioral of REGCSA is
begin
process(CLK,RST)
begin
if RST='0' then 
   Z<= (others=>'0');
elsif CLK='1' and CLK'event then 
   Z<= X;
end if; 
end process;
end Behavioral;
----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
library WORK;

entity SELUNIT is
Port (
C:     IN  std_logic_vector(3 downto 0);
S:     IN  std_logic_vector(3 downto 0);
SEL:   OUT std_logic_vector(3 downto 0) );
end SELUNIT;

architecture Behavioral of SELUNIT is
begin
SEL(3 downto 0) <= (S(3 downto 0) + C(3 downto 0));
end Behavioral;

-----------------------------------------------------------------------------------------------------------------------------------