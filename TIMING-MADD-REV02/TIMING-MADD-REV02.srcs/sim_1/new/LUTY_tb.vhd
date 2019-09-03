----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.08.2019 17:26:29
-- Design Name: 
-- Module Name: LUTY_tb - Behavioral
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


entity LUTY_tb is
--  Port ( );
end LUTY_tb;

architecture Behavioral of LUTY_tb is


component LUT_Y is
Port (-- CLK : in std_logic;
       RST : in std_logic;
       SELY: in std_logic_vector( 2 downto 0);
       Y         : in std_logic_vector(254 downto 0);
       YOUT: out std_logic_vector(257 downto 0)
      );
end component LUT_Y;
signal  CLK : std_logic:='0';
signal  RST : std_logic;
signal  SELY: std_logic_vector( 2 downto 0);
signal  Y:    std_logic_vector(254 downto 0);
signal  YOUT: std_logic_vector(257 downto 0);

begin
CLK <= NOT CLK after 1.5 ns;
ut: LUT_Y port map( RST => RST, SELY=> SELY, Y => Y, YOUT =>YOUT);
RST <= '0' , '1' after 15 ns;
SELY <= "000", "001" after 70 ns, "101" after 90 ns, "111" after 110 ns, "100" after 120 ns, "011" after 125 ns, "010" after 130 ns, "110"after 135 ns, "111"after 140 ns, "101"after 142 ns, "100"after 146 ns, "111"after 149 ns;
Y <= (others => '0') ,"010"& X"260CDF3092329C21DA25EE8C9A21F5697390F51643851560E5F46AE6AF8A3C9" after 10 ns; 
end Behavioral;
