----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2019 11:12:28
-- Design Name: 
-- Module Name: EDPD - Behavioral
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


entity EDPD is
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
end EDPD;

architecture Behavioral of EDPD is
type STATE is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20);
signal ST : STATE;

component INTLVD_RED is
Port ( CLK : IN std_logic;
       RST : IN std_logic;
       X : IN  std_logic_vector(254 DOWNTO 0);
       Y : IN  std_logic_vector(254 DOWNTO 0);
       Z : OUT std_logic_vector(254 DOWNTO 0)
 );
end component INTLVD_RED;
signal RESET: std_logic;
signal RX1,RY1,RZ1 : std_logic_vector(254 downto 0);
--signal RX2,RY2,RZ2 : std_logic_vector(254 downto 0);

component MADD is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end component MADD;

component MSUB is
generic(w: integer := 255);
port(
X:        IN  std_logic_vector(w-1 DOWNTO 0);
Y:        IN  std_logic_vector(w-1 DOWNTO 0);
Z:        OUT  std_logic_vector(w-1 DOWNTO 0));
end component MSUB;

signal LX1,LY1,LZ1 : std_logic_vector(254 downto 0);
signal LX2,LY2,LZ2 : std_logic_vector(254 downto 0);

signal B,C,D,E,F,G,K,P1 : std_logic_vector(254 downto 0);

begin
U1 : INTLVD_RED port map (CLK =>CLK, RST => RESET, X=>RX1, Y=>RY1, Z=>RZ1);
U3 : MADD       port map (X => LX1, Y=>LY1,Z=>LZ1);
U4 : MSUB       port map (X => LX2, Y=>LY2,Z=>LZ2);

process(CLK,RST)
variable count : integer; 
begin
if RST = '0' then 
   ST <= S0; 
   RESET <='0';
   count:=0;
   P1<=P;
   X2<= (others => '0');
   Y2<= (others => '0');
   Z2<= (others => '0');
   C <= (others => '0');
   D <= (others => '0');
   E <= (others => '0');
   F <= (others => '0');
   RX1 <= (others => '0');
  -- RX2 <= (others => '0');
   RY1 <= (others => '0');
  -- RY2 <= (others => '0');   
elsif CLK ='1'and CLK'event then
   case ST is 
      when S0 =>   
          RX1 <= X1; -- X1^2 mod p
          RY1 <= X1; --
          LX1 <= X1; --FADD(X1,Y1,B); -- B=(X1+Y1)
          LY1 <= Y1;
          ST <=S1; 
      when S1 => 
          RESET <= '1';
          if count = 90 then 
             Count :=0;     
             C <= RZ1; -- C= X1^2
             ---          B <= LZ1; 
             ST <= S2;
           else 
             count:= count+1;    
           end if;   
       when S2 =>  
          RESET <= '0';
          B <= LZ1; 
          RX1 <= Y1; -- Y1^2 mod p
          RY1 <= Y1; --
          ST <= S3;
      when S3 => 
          RESET <= '1';
          if count = 90 then 
             Count :=0;
             D <= RZ1; -- D = Y1^2           
             ST <= S4;
         else 
            count:= count+1;    
         end if;               
      when S4 =>    
           RESET <= '0';
           RX1 <= B; -- (X1+Y1)^2 mod p
           RY1 <= B; --
           LX1 <= D; LY1 <= C; --FADD(D,C,E); --E  
           LX2 <= D; LY2 <= C; --FSUB(D,C,F); --F 
           ST<= S5;
      when S5 => 
           RESET <='1';
           E <= LZ1;
           F <= LZ2;
           ST <= S6;
      when S6 =>
           LX2 <= P1; 
           LY2 <= E; --FSUB(P,E,E); 
           ST <= S7;
      when S7 => 
           E <= LZ2;
           ST <= S8;           
      when S8 =>       
           if count = 88 then 
              Count :=0;
              B <= RZ1; -- (X1+Y1)^2 in B         
              ST <= S9;
           else 
              count:= count+1;    
           end if; 
      when S9 => 
           RESET <='0';
           RX1 <= Z1; -- Z1^2 mod p
           RY1 <= Z1; -- 
           ST <= S10;
      when S10 => 
          RESET <= '1';
         if count = 90 then 
              count :=0;
              C <= RZ1; -- Z1^2 in C          
              ST <= S11;
            else 
              count:= count+1;    
            end if;
       when S11 =>
            RESET <= '0';
            LX1 <= C; LY1 <= C; --FADD(C,C,C);  
            RX1 <= F;      -- F*E=  Y3 mod p
            RY1 <= E;      --  
            ST <= S12;
       when S12 => 
            C <= LZ1; ---  2Z1^2 in C 
            RESET <= '1';            
            ST <= S13;
       when S13 => 
            LX2 <= F; LY2 <= C;  
            ST <= S14;                    
       when S14 =>            
            if count = 88 then 
               count :=0; 
               Y2 <= RZ1;         
               ST <= S15;
            else 
               count:= count+1;    
            end if;
        when S15 => 
            RESET <= '0';
            C   <= LZ2; -- C = F - 2Z1^2
            LX1 <= E;   -- E+B
            LY1 <= B;
            ST <= S16; 
        when S16 => 
            RX1 <= C;
            RY1 <= LZ1;
            ST<= S17;
        when S17 => 
            RESET <= '1';        
            if count = 90 then 
               count :=0; 
               X2 <= RZ1;         
               ST <= S18;
             else 
               count:= count+1;    
             end if;
        when S18 => 
             RESET <= '0';    
             RX1 <= F;
             RY1 <= C;
             ST <= S19;
        when S19 => 
             RESET <= '1'; 
             if count = 90 then  
                Z2 <= RZ1;    
                ST <= S20;    
             else 
                count:= count+1;    
             end if;  
        when S20 =>
             RESET <= '0';                                 
   end case;
   
end if;
end process;
end Behavioral;
