----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2019 14:45:24
-- Design Name: 
-- Module Name: REDUCER - Behavioral
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




entity REDUCER is
Port ( EN: in std_logic;
       S   :in std_logic_vector(259 downto 0);
       Z   : out std_logic_vector(254 downto 0)
 );
end REDUCER;

architecture Behavioral of REDUCER is
constant p   : std_logic_vector(254 downto 0) := "111"&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED";
constant p2  : std_logic_vector(255 downto 0) :=      X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDA";
constant p3  : std_logic_vector(256 downto 0) :=  '1'&X"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7";
constant p4  : std_logic_vector(256 downto 0) :=  '1'&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4";
constant p5  : std_logic_vector(257 downto 0) := "10"&X"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1";
constant p6  : std_logic_vector(257 downto 0) := "10"&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8E";
constant p7  : std_logic_vector(257 downto 0) := "11"&X"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7B";
constant p8  : std_logic_vector(257 downto 0) := "11"&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF68";
constant p9  : std_logic_vector(258 downto 0) := "100"&X"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF55";
constant p10  : std_logic_vector(258 downto 0) := "100"&X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF42";
constant p10n : std_logic_vector(7 downto 0):= "10111110"; 
constant p9n : std_logic_vector(7 downto 0) := "10101011"; 
constant p8n : std_logic_vector(7 downto 0) := "10011000"; 
constant p7n : std_logic_vector(7 downto 0) := "10000101"; 
constant p6n : std_logic_vector(7 downto 0) := "01110010";    
constant p5n : std_logic_vector(7 downto 0) := "01011111"; 
constant p4n : std_logic_vector(7 downto 0) := "01001100"; 
constant p3n : std_logic_vector(7 downto 0) := "00111001"; 
constant p2n : std_logic_vector(7 downto 0) := "00100110"; 
constant p1n : std_logic_vector(7 downto 0) := "00010011"; 
signal   SX : std_logic_vector(259 downto 0);
begin

SX <= 
S(259 downto 0) + p10n  when (S >= p10) else 
S(259 downto 0) + p9n  when (S >= p9) else 
S(259 downto 0) + p8n  when (S >= p8) else 
S(259 downto 0) + p7n  when (S >= p7) else 
S(259 downto 0) + p6n  when (S >= p6) else 
S(259 downto 0) + p5n  when (S >= p5) else 
S(259 downto 0) + p4n  when (S >= p4) else 
S(259 downto 0) + p3n  when (S >= p3) else 
S(259 downto 0) + p2n  when (S >= p2) else 
S(259 downto 0) + p1n  when (S >= p ) else 
S(259 downto 0);
Z(254 downto 0) <= SX(254 downto 0) when EN = '1' else (others=>'0');
end Behavioral;
