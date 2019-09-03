----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2019 13:40:19
-- Design Name: 
-- Module Name: EDPA_tb - Behavioral
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


entity EDPA_tb is
--  Port ( );
end EDPA_tb;

architecture Behavioral of EDPA_tb is

component  EDPA is
Port (
CLK: in  std_logic;
RST: in  std_logic;
X1 : in  std_logic_vector(254 downto 0);
Y1 : in  std_logic_vector(254 downto 0); 
Z1 : in  std_logic_vector(254 downto 0);
X2 : in  std_logic_vector(254 downto 0);
Y2 : in  std_logic_vector(254 downto 0); 
Z2 : in  std_logic_vector(254 downto 0);
X3 : out std_logic_vector(254 downto 0);
Y3 : out std_logic_vector(254 downto 0); 
Z3 : out std_logic_vector(254 downto 0)
);
end component EDPA;
signal X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3 : std_logic_vector(254 downto 0);
signal CLK : std_logic:='0';
signal RST : std_logic;
begin
ut: EDPA port map(CLK=> CLK, RST => RST,X1=>X1,Y1=>Y1,Z1=>Z1,X2=>X2,Y2=>Y2,Z2=>Z2,X3=>X3,Y3=>Y3,Z3=>Z3);

CLK <= not CLK after 4 ns; 
RST <= '0', '1'after 13 ns;
X1 <= "010"&X"169_36D3_CD6E_53FE_C0A4_E231_FDD6_DC5C_692C_C760_9525_A7B2_C956_2D60_8F25_D51A";
Y1 <= "110"&X"666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6658";
Z1 <= "000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";

X2 <= "010"&X"169_36D3_CD6E_53FE_C0A4_E231_FDD6_DC5C_692C_C760_9525_A7B2_C956_2D60_8F25_D51A";
Y2 <= "110"&X"666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6658";
Z2 <= "000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
end Behavioral;


