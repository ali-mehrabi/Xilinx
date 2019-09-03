----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2019 15:31:04
-- Design Name: 
-- Module Name: EDPA - Behavioral
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


entity EDPA is
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
end EDPA;

architecture Behavioral of EDPA is
type STATE is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22);
signal ST : STATE;

component INTLVD_RED is
Port ( CLK : IN std_logic;
       RST : IN std_logic;
       X : IN  std_logic_vector(254 DOWNTO 0);
       Y : IN  std_logic_vector(254 DOWNTO 0);
       Z : OUT std_logic_vector(254 DOWNTO 0)
 );
end component INTLVD_RED;

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



signal RESET: std_logic;
signal RX1,RY1,RZ1 : std_logic_vector(254 downto 0);
--signal RX2,RY2,RZ2 : std_logic_vector(254 downto 0);
signal B,C,D,E,K,L : std_logic_vector(254 downto 0);
signal LX1,LY1,LZ1 : std_logic_vector(254 downto 0);
signal LX2,LY2,LZ2 : std_logic_vector(254 downto 0);

begin
U1 : INTLVD_RED port map (CLK =>CLK, RST => RESET, X=>RX1, Y=>RY1, Z=>RZ1);
--U2 : INTLVD_RED port map (CLK =>CLK, RST => RESET, X=>RX2, Y=>RY2, Z=>RZ2);
U3 : MADD       port map (X => LX1, Y=>LY1,Z=>LZ1);
U4 : MSUB       port map (X => LX2, Y=>LY2,Z=>LZ2);

process(CLK,RST)
variable count : integer; 
begin
if RST = '0' then 
   ST <= S0; 
   RESET <='0';
   count:=0;
   X3<= (others => '0');
   Y3<= (others => '0');
   Z3<= (others => '0');
   B <= (others => '0');
   C <= (others => '0');
   D <= (others => '0');
   E <= (others => '0');
   K <= (others => '0'); 
   L <= (others => '0');
   RX1 <= (others => '0');
   RY1 <= (others => '0'); 
elsif CLK ='1'and CLK'event then
   case ST is 
      when S0 =>   
          RX1 <= X1; --C= X1*X2 mod p
          RY1 <= X2; 
          LX1<=X1; 
          LY1<=Y1;
          ST <= S1;
      when S1 =>   
         RESET <= '1';
         if count = 90 then 
            Count :=0;
            C  <= RZ1; -- C= X1*X2
            K  <= LZ1; -- K= X1 +Y1
            ST <= S2;
          else 
            count:= count+1;    
          end if;  
      when S2 => 
          RESET <= '0';        
          RX1 <= Y1; --D= Y1*Y2 mod p
          RY1 <= Y2; --
          LX1<=X2; 
          LY1<=Y2;  -- L = X2+Y2      
          ST <= S3;
      when S3 =>   
          RESET <= '1';
          if count = 90 then 
             Count :=0;
             D <= RZ1; -- D= Y1*Y2
             L   <= LZ1;
             ST <= S4;
          else 
            count:= count+1;   
          end if;                               
      when S4 => 
          RESET <= '0';
          RX1 <= Z2;
          RY1 <= Z2;
          LX1 <= D;
          LY1 <= C;
          ST  <= S5;
     when S5 =>   
          RESET <= '1'; 
          if count = 90 then 
             Count :=0;
             B  <= RZ1; 
             ST <= S6;
           else 
              count:= count+1;    
           end if;          
      when S6 => 
           RESET <= '0';
           RX1 <= C;
           RY1 <= D;  
           ST  <= S7;         
      when S7 => 
          RESET <= '1'; 
          if count = 90 then 
             Count :=0;
             E  <= RZ1; -- E = C*D
             C  <= LZ1; -- C = C+D
             ST <= S8;
          else 
             count:= count+1;    
          end if;     
      when S8 => 
           RESET <='0';
           RX1 <= E;
           RY1 <= dd;
           ST <= S9;
     when S9 =>      
          RESET <= '1'; 
          if count = 90 then 
             Count :=0;
             E  <= RZ1; -- E = d*C*D
             ST <= S10;
          else 
             count:= count+1;    
          end if;                      
     when S10 =>  
          RESET <= '0';
          LX1 <= B;
          LY1 <= E; 
          LX2 <= B;
          LY2 <= E;
          RX1 <= K;
          RY1 <= L;
          ST <= S11;
     when S11 =>  
          RESET <= '1';   
          if count = 90 then 
             count :=0;
             K   <= RZ1; -- K= (X1+Y1)(X2+Y2)
             E   <= LZ1; --  E = B+E
             B   <= LZ2; --  B = B-E       
             ST <= S12;
           else 
             count:= count+1;    
           end if;
      when S12 =>
            RESET <= '0';
            RX1 <= Z2; -- (B-E)Z2
            RY1 <= B;  --
            LX2 <= K;  -- (K-C)
            LY2 <= C;  --
            ST  <= S13;
       when S13 =>
            RESET <= '1'; 
            if count = 90 then 
               count :=0;
               L   <= RZ1;   -- L = (B-E)*Z2  = J
               D  <= LZ2;   -- D =  (K-C)   = I    
               ST <= S14;
            else 
               count:= count+1;    
            end if;
       when S14 => 
            RESET <='0';                        
            RX1 <= L;  
            RY1 <= D; 
            ST <= S15;
       when S15 => 
            RESET <= '1'; 
            if count = 90 then 
               count :=0;
               X3  <= RZ1;       
               ST <= S16;
            else 
               count:= count+1;    
            end if;      
       when S16 => 
            RESET <= '0';
            RX1 <= Z2;    -- (B+E)Z2 = Z3
            RY1 <= E;     --  
            ST <= S17;        
       when S17 => 
            RESET <= '1';       
            if count = 90 then 
               count :=0;   
               K <= RZ1;       
               ST <= S18;
            else 
               count:= count+1;    
            end if;
        when S18 =>  
            RESET <='0';
            RX1 <= E;
            RY1 <= B; 
            ST  <= S19;
        when S19 => 
            RESET <= '1';
            if count = 90 then 
               count :=0;   
               Z3 <= RZ1;       
               ST <= S20;
            else 
               count:= count+1;    
            end if;
        when S20 => 
             RESET <= '0';
             RX1 <= K;
             RY1 <= C;
             ST <= S21;
        when S21 =>  
             RESET <= '1';   
             if count = 90 then 
                count :=0;  
                Y3 <= RZ1;       
                ST <= S22;
             else 
                count:= count+1;    
          end if; 
        when S22 => 
             RESET <= '0';               
   end case;
   
end if;
end process;
end Behavioral;