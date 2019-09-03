library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use WORK.CURVE_PACK.all;

entity MSUB is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end MSUB;

Architecture Behavioral of MSUB is
signal S3, S4    : std_logic_vector(w downto 0);
signal C1, C2    : std_logic_vector(w downto 0);
signal S1, S2, nY: std_logic_vector(w-1 downto 0);
--signal L1, L2, J1, J2:  std_logic;
signal J : std_logic_vector(w-1 downto 0);
signal CL1, SL1 : std_logic_vector(w-6 downto 0);
signal CL2, SL2 : std_logic_vector(1 downto 0);
signal CL3, SL3 : std_logic;
begin
nY <= not Y;
S1 <= X xor nY;
J <= X and nY;
C1 <= J & '1'; 
SL1 <= not (S1(w-1 downto 5));
SL2 <= not (S1(3 downto 2));
SL3 <= not S1(0);
S2 <= SL1 & S1(4) & SL2 & S1(1) & SL3;
CL1 <= X(w-1 downto 5) or nY(w-1 downto 5);
CL2 <= X(3 downto 2) or nY(3 downto 2);
CL3 <= X(0) or nY(0);
C2 <= CL1& J(4) & CL2 & J(1) & CL3 & '1';
S3 <= S1 + C1;
S4 <= S2 + C2;
Z <= S4(w-1 downto 0) when  S4(w) = '1' else S3(w-1 downto 0);
end Behavioral;