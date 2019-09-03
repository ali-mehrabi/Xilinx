----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2019 20:27:30
-- Design Name: 
-- Module Name: CURVE_PACK - Behavioral
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

Package  CURVE_PACK is
constant w: integer := 255;
constant P:    std_logic_vector(w-1 downto 0):= "111"&X"FFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFED"; --EDWARDS curve ED25519
constant P2:   std_logic_vector(w downto 0):= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDA";  --2*P
constant P3:   std_logic_vector(w+1 downto 0):= '1'&X"7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7";  --2*P
constant ONE:  std_logic_vector(w-1 downto 0) :="000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
constant ZERO: std_logic_vector(w-1 downto 0) :="000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
constant dd: std_logic_vector(254 downto 0) := "101"&X"203_6CEE_2B6F_FE73_8CC7_4079_7779_E898_0070_0A4D_4141_D8AB_75EB_4DCA_1359_78A3";
--------------------CURVE PARAMETERS 
--------------------
constant WAIT_PERIOD : integer := 1581;
constant PD_WAIT_PERIOD : integer := 645;
constant PA_WAIT_PERIOD : integer := 1011;
constant P_KEY   : std_logic_vector(254 downto 0) := "000"&X"000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0003";
constant PADD    : std_logic_vector(1 downto 0) := "01";
constant PDOUBLE : std_logic_vector(1 downto 0) := "11";
constant READP   : std_logic_vector(1 downto 0) := "10";
--------------------
procedure FQUAD( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0));

procedure FTRPL( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0));

procedure FDOUB( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0));

procedure FADD( 
signal A:   IN   std_logic_vector(w-1 downto 0);
signal B:   IN   std_logic_vector(w-1 downto 0);
signal S:   OUT  std_logic_vector(w-1 downto 0));

procedure FSUB( 
signal A:   IN   std_logic_vector(w-1 downto 0);
signal B:   IN   std_logic_vector(w-1 downto 0);
signal S:   OUT  std_logic_vector(w-1 downto 0));

procedure  CSA (
signal X:        IN  std_logic_vector(w   DOWNTO 0);
signal Y:        IN  std_logic_vector(w   DOWNTO 0);
signal Z:        IN  std_logic_vector(w   DOWNTO 0);
signal S:        OUT std_logic_vector(w+1 DOWNTO 0);
signal C:        OUT std_logic_vector(w+1 DOWNTO 0));

function MSBB(A: std_logic_vector )  return  integer;  

End Package CURVE_PACK;

Package body CURVE_PACK is

procedure FQUAD( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0)) is 
variable TEMP: std_logic_vector(w+1 downto 0);
begin
TEMP(w+1 downto 0):= A(w-1 downto 0)&"00";
if (TEMP> P3) then 
   TEMP:= TEMP - P3;
elsif TEMP > P2 then 
   TEMP:= TEMP - P2; 
elsif TEMP > P then
   TEMP:= TEMP -P;
else 
   TEMP:= TEMP;  
end if;
B(w-1 downto 0) <= TEMP(w-1 downto 0);         
end procedure FQUAD;

procedure FTRPL( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0)) is
variable TEMP0,TEMP1,TEMP2: std_logic_vector(w+1 downto 0);
begin
TEMP1(w+1 downto 0):= "00"&A(w-1 downto 0);
TEMP0(w+1 downto 0):= '0'&A(w-1 downto 0)&'0';
TEMP2(w+1 downto 0):= TEMP1+TEMP0;
if (TEMP2> P2) then 
   TEMP2:= TEMP2 - P2;
elsif TEMP2 > P then 
   TEMP2:= TEMP2 - P; 
else
   TEMP2:= TEMP2;
end if;
B(w-1 downto 0) <= TEMP2(w-1 downto 0);          
end procedure FTRPL;

procedure FDOUB( 
signal A:   IN  std_logic_vector(w-1 downto 0);
signal B:   OUT std_logic_vector(w-1 downto 0)) is 
variable TEMP: std_logic_vector(w downto 0);
begin
TEMP(w downto 0):= A(w-1 downto 0)&'0';
if (TEMP> P) then 
   TEMP:= TEMP - P;
else
   TEMP:= TEMP;
end if;
B(w-1 downto 0) <= TEMP(w-1 downto 0);         
end procedure FDOUB;

procedure FADD( 
signal A:   IN   std_logic_vector(w-1 downto 0);
signal B:   IN   std_logic_vector(w-1 downto 0);
signal S:   OUT  std_logic_vector(w-1 downto 0)) is 
variable TEMP: std_logic_vector(w downto 0);
begin
TEMP(w downto 0):= '0'&A(w-1 downto 0)+B(w-1 downto 0);
if (TEMP> P) then 
   TEMP:= TEMP - P;
else
   TEMP:= TEMP;
end if;
S(w-1 downto 0) <= TEMP(w-1 downto 0);         
end procedure FADD;

procedure FSUB( 
signal A:   IN   std_logic_vector(w-1 downto 0);
signal B:   IN   std_logic_vector(w-1 downto 0);
signal S:   OUT  std_logic_vector(w-1 downto 0)) is 
variable TEMP: std_logic_vector(w-1 downto 0);
begin
if (A >= B) then 
   TEMP:= A-B;
else
   TEMP:= A+(P-B);
end if;
S(w-1 downto 0) <= TEMP(w-1 downto 0);         
end procedure FSUB;

procedure  CSA (
signal X:        IN  std_logic_vector(w   DOWNTO 0);
signal Y:        IN  std_logic_vector(w   DOWNTO 0);
signal Z:        IN  std_logic_vector(w   DOWNTO 0);
signal S:        OUT std_logic_vector(w+1 DOWNTO 0);
signal C:        OUT std_logic_vector(w+1 DOWNTO 0))
is
begin
S(w+1 downto 0) <= '0'&((X XOR Y) XOR Z);
C(w+1 downto 0) <= (((X AND Y) OR (X AND Z)) OR (Y AND Z))&'0';
end procedure CSA;


function MSBB(A: std_logic_vector ) return integer is 
  variable n : integer;
  begin 
  for i in A'range loop
     if A(i)='1' then 
     n:= i;
     exit;
     end if;   
  end loop;
  return n;
end function MSBB;


End  CURVE_PACK;

