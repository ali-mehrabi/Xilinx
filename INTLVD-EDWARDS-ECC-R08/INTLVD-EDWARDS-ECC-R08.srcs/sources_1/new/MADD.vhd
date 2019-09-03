library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use WORK.CURVE_PACK.all;

entity MADD is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end MADD;

Architecture Behavioral of MADD is
signal S1,S2  : std_logic_vector(w   downto 0);
signal C2  : std_logic_vector(w   downto 0);
signal S3, S4, C1 : std_logic_vector(w-1 downto 0);
signal L1, L2, J1,J2 : std_logic;
begin
S2 <= '0'&X + Y;
S3 <= (X xor Y );
S1 <= C2 + S4;
C1 <= (X and Y);
L1 <= not S3(1);
L2 <= not S3(4);
J1 <= X(1) or Y(1) or C1(1);
J2 <= X(4) or Y(4) or C1(4);
C2(w downto 0) <= C1(w-1 downto 5)& J2 & C1(3 downto 2) & J1 & C1(0)& '1';
S4(w-1 downto 0) <= S3(w-1 downto 5) & L2 & S3(3 downto 2) & L1 & S3(0);
Z  <= S1(w-1 downto 0) when  S1(w) = '1' else S2(w-1 downto 0);
end Behavioral;
