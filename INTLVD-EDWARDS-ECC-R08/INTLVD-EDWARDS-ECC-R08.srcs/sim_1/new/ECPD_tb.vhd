----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2019 10:27:44
-- Design Name: 
-- Module Name: ECPD_tb - Behavioral
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
use  WORK.CURVE_PACK.all;




entity ECPD_tb is
--  Port ( );
end ECPD_tb;

architecture Behavioral of ECPD_tb is


component  EDPD is
Port (
CLK: in  std_logic;
RST: in  std_logic;
X1 : in  std_logic_vector(254 downto 0);
Y1 : in  std_logic_vector(254 downto 0); 
Z1 : in  std_logic_vector(254 downto 0);
X2 : out std_logic_vector(254 downto 0);
Y2 : out std_logic_vector(254 downto 0); 
Z2 : out std_logic_vector(254 downto 0)
);
end component EDPD;
signal X1,Y1,Z1,X2,Y2,Z2 : std_logic_vector(254 downto 0);
signal CLK : std_logic:='0';
signal RST : std_logic;
begin
ut: EDPD port map(CLK=> CLK, RST => RST,X1=>X1,Y1=>Y1,Z1=>Z1,X2=>X2,Y2=>Y2,Z2=>Z2);

CLK <= not CLK after 2 ns; 
RST <= '0', '1'after 13 ns;
X1 <= "010"&X"169_36D3_CD6E_53FE_C0A4_E231_FDD6_DC5C_692C_C760_9525_A7B2_C956_2D60_8F25_D51A";
Y1 <= "110"&X"666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6658";
Z1 <= "000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";

end Behavioral;
