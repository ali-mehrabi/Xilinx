----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2019 10:57:39
-- Design Name: 
-- Module Name: LUT_Y - Behavioral
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2019 10:57:39
-- Design Name: 
-- Module Name: LUT_Y - Behavioral
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
library WORK;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
--use WORK.PACK.all;

entity LUT_Y is
Port (
       RST : in std_logic;
       SELY: in std_logic_vector( 2 downto 0);
       Y         : in std_logic_vector(254 downto 0);
       YOUT: out std_logic_vector(257 downto 0)
      );
end LUT_Y;

architecture Behavioral of LUT_Y is
type STATE is (T0,T1,T2,T3,T4,T5,T6,T7,T8,T9);
signal ST : STATE;
constant p   :   std_logic_vector(254 downto 0) := "111"&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED";
constant pn  :   std_logic_vector(4 downto 0) := "10011";
signal Y2:     std_logic_vector(254 downto 0);
signal LUT2:   std_logic_vector(254 downto 0);
signal LUT3:   std_logic_vector(254 downto 0);
signal LUT4:   std_logic_vector(254 downto 0);
signal LUT5:   std_logic_vector(254 downto 0);
signal LUT6:   std_logic_vector(254 downto 0);
signal LUT7:   std_logic_vector(254 downto 0);
component MADD is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end component ;

begin

u2: MADD generic map(255) port map(X=> Y2,    Y=> Y2,   Z=> LUT2);
u4: MADD generic map(255) port map(X=> LUT2,  Y=>LUT2,  Z=> LUT4);
u3: MADD generic map(255) port map(X=> LUT2,  Y=>Y2,    Z=> LUT3);
u6: MADD generic map(255) port map(X=> LUT3,  Y=>LUT3,  Z=> LUT6);
u5: MADD generic map(255) port map(X=> LUT2,  Y=>LUT3,  Z=> LUT5);
u7: MADD generic map(255) port map(X=> LUT4,  Y=>LUT3,  Z=> LUT7);

process(RST)
begin
if (RST ='1' and RST'event) then
    Y2 <= Y;
end if; 
end process; 

process(SELY)
begin
case SELY is 
when "001" => 
YOUT <= "000"& Y2(254 downto 0);
when "010" =>
YOUT <="000"& LUT2(254 downto 0);
when "011" =>
YOUT <="000"& LUT3(254 downto 0);
when "100" => 
YOUT <= "000"& LUT4(254 downto 0);
when "101" =>  
YOUT <= "000"& LUT5(254 downto 0);
when "110"=> 
YOUT <= "000"& LUT6(254 downto 0);
when "111"=> 
YOUT <= "000"& LUT7(254 downto 0);
when others =>
YOUT <= (others =>'0');
end case;
end process;

end Behavioral;


