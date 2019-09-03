----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2019 11:51:02
-- Design Name: 
-- Module Name: EDECC - Behavioral
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

entity EDECC is
Port (
      CLK:         IN   std_logic;
      RESETN:      IN   std_logic;
      DATA_READY:  IN   std_logic;
      READY :      OUT  std_logic;
      PXI,PYI,PZI: IN   std_logic_vector(w-1 downto 0);
      PXO,PYO,PZO: OUT  std_logic_vector(w-1 downto 0)
);
end EDECC;

architecture Behavioral of EDECC is

component EDPA is
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


component EDPD is
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

type   STATE_TYPE is (S0,S1,S2,S3,S4,S5,S6,S7,S8);
signal STATE : STATE_TYPE;
signal ARESETN,DRESETN :STD_LOGIC;
signal X1,X2,X3,X4,Y1,Y2,Y3,Y4,Z1,Z2,Z3,Z4 : std_logic_vector(w-1 downto 0);
signal X5,Y5,Z5                            : std_logic_vector(w-1 downto 0);
signal X1R,Y1R                             : std_logic_vector(w-1 downto 0);
signal R0X,R0Y,R0Z,R1X,R1Y,R1Z             : std_logic_vector(w-1 downto 0);


begin

U1: EDPA port map(CLK=> CLK, RST=> ARESETN, X1=>X1, Y1=>Y1, Z1=>Z1, X2=>X2, Y2=>Y2, Z2=>Z2, X3=>X3, Y3=>Y3, Z3=>Z3);
U2: EDPD port map(CLK=> CLK, RST=> DRESETN, X1=>X4, Y1=>Y4, Z1=>Z4, X2=>X5, Y2=>Y5, Z2=>Z5);


CONTROLLER:
process(CLK,RESETN)
variable COUNT :integer;
variable j: integer;
begin
if RESETN = '0' then
   --X1 <=(others=> '0');
   --Y1 <=(others=> '0');
   --Z1 <=(others=> '0');
   --X2 <=(others=>'0');
   --Y2 <=(others=>'0');
   --Z2 <=(others=>'0');
   --X4 <=(others=>'0');
   --Y4 <=(others=>'0');
   --Z4 <=(others=>'0');
   R0X<=(others=>'0');
   R0Y<=(others=>'0');
   R0Z<=(others=>'0');
   R1X<=(others=>'0');
   R1Y<=(others=>'0');
   R1Z<=(others=>'0');
   PXO<=(others=>'0');
   PYO<=(others=>'0');
   PZO<=(others=>'0');  
   ARESETN  <= '0';
   DRESETN  <= '0';
   READY    <= '0';
   STATE    <= S0 ;
   j:=0;
   count:=0;
elsif CLK='0' and CLK'event then  
   if DATA_READY = '1' then
      case STATE is
           when S0=>
                j:=MSBB(P_KEY)-1;---- Private Key(1) is read
                STATE <= S1; 
                X4  <= PXI;   ------ double P 
                Y4  <= PYI;
                Z4  <= PZI;
           when S1 =>
                R0X <= PXI;   ------P registered in R0
                R0Y <= PYI;
                R0Z <= PZI;
                DRESETN <= '1'; --Do Point Doubling               
                STATE   <= S2;
           when S2 =>                   
                if count < PD_WAIT_PERIOD then  -- Wait until Point doubling is done
                   count:=count+1;
                   STATE <=S2;
                else   
                  count:=0;
                  R1X <= X5;    --2P registered in R1
                  R1Y <= Y5;
                  R1Z <= Z5;
                  STATE <= S3;
                end if;
           when S3 => 
                DRESETN <='0'; 
                if P_KEY(j)='1' then --if Ki=1 then R1=2R1, R0=R1+R0 else
                   X4 <= R1X;      --             R0=2R0, R1=R1+R0
                   Y4 <= R1Y;
                   Z4 <= R1Z;
                else 
                   X4 <= R0X;      
                   Y4 <= R0Y;
                   Z4 <= R0Z;  
                end if; 
                X1 <= R0X;
                Y1 <= R0Y;
                Z1 <= R0Z;
                X2 <= R1X;
                Y2 <= R1Y;
                Z2 <= R1Z;                
                STATE <= S4;            
           when S4 =>
                DRESETN <='1';     
                ARESETN <='1';   
                if count < PA_WAIT_PERIOD then 
                   count := count +1;   
                   STATE  <=S4;
                else
                   count :=0;
                   if P_KEY(j)='1' then --if Ki=1 then R1=2R1, R0=R1+R0 else
                      STATE <= S5;    --             R0=2R0, R1=R1+R0
                   else
                      STATE<= S6;
                   end if;   
                 end if;                  
           when S5 => 
                R0X <= X3;
                R0Y <= Y3;
                R0Z <= Z3;
                R1X <= X5;
                R1Y <= Y5;
                R1Z <= Z5;

                STATE <= S7;           
           when S6 =>    
                R1X <= X3;
                R1Y <= Y3;
                R1Z <= Z3; 
                R0X <= X5;
                R0Y <= Y5;
                R0Z <= Z5;
                STATE <= S7;  
           when S7 => 
                ARESETN <='0';      -- Deactivate Point Addition   
                DRESETN <='0';      -- Activate point Doubling   
                if j>0 then
                   j:= j-1;
                   STATE <= S3;
                 else
                   STATE <= S8;
                 end if;
           when S8  =>
                 PXO    <=R0X ;
                 PYO    <=R0Y ;
                 PZO    <=R0Z ;
                 READY  <='1';
                 STATE  <=S8;
            end case;
        end if;
    end if;
end process CONTROLLER;
end Behavioral;