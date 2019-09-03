----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2019 20:52:24
-- Design Name: 
-- Module Name: MSUB_tb - Behavioral
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
use WORK.CURVE_PACK.all;

entity MSUB_tb is
--  Port ( );
end MSUB_tb;

architecture Behavioral of MSUB_tb is

component MSUB is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end component  MSUB;
signal X,Y, Z : std_logic_vector(w-1 DOWNTO 0);
begin
ut: MSUB port map(X=>X,Y=>Y,Z=>Z);
X <= (others => '0') ,"011"& X"6AB384C9F5A046C3D043B7D1833E7AC080D8E4515D7A45F83C5A14E2843CE0E" after 10 ns,"001"& X"4E528B1154BE417B6CF078DD6712438D381A5B2C593D552FF2FD2C1207CF3CB" after 20 ns ; 
Y <= (others => '0') ,"010"& X"260CDF3092329C21DA25EE8C9A21F5697390F51643851560E5F46AE6AF8A3C9" after 10 ns , "010"& X"D9082313F21AB975A6F7CE340FF0FCE1258591C3C9C58D4308F2DC36A033713" after 50 ns ; 

end Behavioral;
