----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2019 12:16:06
-- Design Name: 
-- Module Name: INTMM_tb - Behavioral
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

entity INTMM_tb is
--  Port ( );
end INTMM_tb;

architecture Behavioral of INTMM_tb is

component INTLVD_RED is
Port ( CLK : IN std_logic;
       RST : IN std_logic;
       X : IN  std_logic_vector(254 DOWNTO 0);
       Y : IN  std_logic_vector(254 DOWNTO 0);
       Z : OUT std_logic_vector(254 DOWNTO 0)
 );
 
end component INTLVD_RED;
signal CLK   : std_logic:='0';
signal RST   : std_logic;
signal X,Y,Z : std_logic_vector(254 DOWNTO 0);

begin
ut: INTLVD_RED port map(CLK =>CLK, RST => RST, X=>X, Y=>Y, Z=>Z); 
CLK <= not CLK after 1.4 ns;
RST <= '0', '1'after 10 ns; 
X <= (others => '0') ,"010"& X"260CDF3092329C21DA25EE8C9A21F5697390F51643851560E5F46AE6AF8A3C9" after 5 ns; 
Y <= (others => '0') ,"010"& X"260CDF3092329C21DA25EE8C9A21F5697390F51643851560E5F46AE6AF8A3C9" after 5 ns; 
 
end Behavioral;
