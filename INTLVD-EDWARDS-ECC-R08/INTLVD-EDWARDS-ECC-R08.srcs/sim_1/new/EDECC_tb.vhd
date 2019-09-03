----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2019 15:11:41
-- Design Name: 
-- Module Name: EDECC_tb - Behavioral
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
use IEEE.std_logic_arith.all;
library WORK;
use  WORK.CURVE_PACK.all;


entity EDECC_tb is
--  Port ( );
end EDECC_tb;

architecture Behavioral of EDECC_tb is
signal CLK : std_logic:='0';
signal RST,DREADY : std_logic;
signal X1,Y1,Z1,XO,YO,ZO : std_logic_vector(254 downto 0);
component EDECC is
Port (
      CLK:         IN   std_logic;
      RESETN:      IN   std_logic;
      DATA_READY:  IN   std_logic;
      READY :      OUT  std_logic;
      PXI,PYI,PZI: IN   std_logic_vector(w-1 downto 0);
      PXO,PYO,PZO: OUT  std_logic_vector(w-1 downto 0)
);
end component EDECC;

begin
U1: EDECC port map(CLK =>CLK, RESETN=>RST, DATA_READY =>DREADY, PXI=>X1, PYI=>Y1,PZI=>Z1, PXO=>XO,PYO=>YO,PZO=>ZO);
CLK <= not CLK after 2 ns; 
RST <= '0', '1'after 13 ns;
X1 <= "010"&X"169_36D3_CD6E_53FE_C0A4_E231_FDD6_DC5C_692C_C760_9525_A7B2_C956_2D60_8F25_D51A";
Y1 <= "110"&X"666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6666_6658";
Z1 <= "000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
DREADY <='0',  '1' after 10 ns;

end Behavioral;
