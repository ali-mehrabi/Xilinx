----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2019 10:45:45
-- Design Name: 
-- Module Name: LUT_P - Behavioral
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

entity LUT_P is
Port ( SELP : in  std_logic_vector( 3 downto 0);
       POUT : out std_logic_vector(10 downto 0)
      );
end LUT_P;

architecture Behavioral of LUT_P is

type LUT_type is array (0 to 10) of std_logic_vector(10 downto 0);
constant LUT1: LUT_type:= ( "000"&X"00", "000"&X"98","001"&X"30","001"&X"C8", "010"&X"60",
                            "010"&X"F8", "011"&X"90","100"&X"28","100"&X"C0", "101"&X"58", "101"&X"F0");
--constant ZERO: std_logic_vector(247 downto 0) := (others=>'0');
                            
begin
process(SELP)
begin
 case SELP is 
      when "0001" =>
           POUT <= LUT1(1);
      when "0010" =>
           POUT <= LUT1(2);
      when "0011" =>
           POUT <= LUT1(3);
      when "0100" =>
           POUT <= LUT1(4);
      when "0101" =>
           POUT <= LUT1(5);                                     
      when "0110" =>
           POUT <= LUT1(6);    
      when "0111" =>
           POUT <= LUT1(7);
      when "1000" =>
           POUT <= LUT1(8);
      when "1001" =>
           POUT <= LUT1(9);
      when "1010" =>
           POUT <= LUT1(10);                  
      when others => 
           POUT <= LUT1(0);    
      end case;
 end process;                                
end Behavioral;
