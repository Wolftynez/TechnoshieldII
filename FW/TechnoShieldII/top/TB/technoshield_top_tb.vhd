---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Nom du fichier: technoshieldTop_tb
-- Nom du projet: technoShieldII
-- Composante cible: aucune, c'est un banc d'essai
-- Dependances: reg_component, technoshield_top
-- Type de fichier: declaration et definition d'un banc d'essai
-- Auteur: Raphael Fortin
-- Etablissement: Cegep de Lapocatiere
-- Versions:
--	0.1.0		: 2021/02/09
--
-- Description:
--	Ce banc d'essai permet de verifier le bon fonctionnement de l'I2C
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
-- Declaration des bibliothèque
-------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-------------------------------------------------------------------------------------------
-- Declaration de l'entity
-------------------------------------------------------------------------------------------

entity technoshield_top_tb is 
	generic(
    periode_mclk_v : time:= 2500 ns -- periode SCL_io
	);
end entity;

-------------------------------------------------------------------------------------------
-- Declaration de l'architecture
-------------------------------------------------------------------------------------------
architecture technoshield_top_a1 of technoshield_top_tb is 

	component Technoshield_top 
		port(
		but_i         : in STD_LOGIC_VECTOR (3 downto 0);
		Led_o 	  	  : out STD_LOGIC_VECTOR (4 downto 0);
	--	Led_Red_o     : out std_logic_vector (2 downto 0);
	--	Led_Green_o	  : out std_logic;
	--	Led_Blue_o	  : out std_logic;
		SDA_io		  : inout std_logic;		
		SCL_io        : inout std_logic
	);
		
	end component;
		
	signal	but_i         :  STD_LOGIC_VECTOR (3 downto 0);
	signal	Led_o 	  	  :  STD_LOGIC_VECTOR (4 downto 0);
--	signal	Led_Red_o     :  std_logic_vector (2 downto 0);
--	signal	Led_Green_o	  :  std_logic;
--	signal  Led_Blue_o	  :  std_logic;
	signal	SDA_io		  :  std_logic:='1';		
	signal	SCL_io        :  std_logic:='1';
		
		
begin	

----------------------------------------------------------------------------------
-- Instanciation du module technoshield_top0
----------------------------------------------------------------------------------

	technoshield_top0 : technoshield_top
	
	port map(
		but_i,
		Led_o,
		SDA_io,
		SCL_io
	);

----------------------------------------------------------------------------------
-- process de generation de l'horloge SCL_io
----------------------------------------------------------------------------------
	process
	begin
			SCL_io <= '0';
			wait for periode_mclk_v/2;
			SCL_io <= '1';
			wait for periode_mclk_v/2;
	end process;
				
----------------------------------------------------------------------------------
-- process de Simuation
----------------------------------------------------------------------------------
	process
	begin
			but_i <= x"A";
	
			wait for periode_mclk_v * 5;	
			wait for periode_mclk_v - periode_mclk_v/4;
----------------------------------------------------------------------------------
-- Slave call + write op
----------------------------------------------------------------------------------	
			SDA_io <= '1'; 			          	--adr 110 0010 
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v/2;	
			
			SDA_io <= '0'; 			           			
			wait for periode_mclk_v;		  	--Reg msb 0011		
			SDA_io <= '1';					  	
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';						--not(W)
			wait for periode_mclk_v;
			SDA_io <= 'Z';						

	----------------------------------------------------------------------------------
	-- Register Adress
	----------------------------------------------------------------------------------
			wait for periode_mclk_v;		
			SDA_io <= '0'; 			           
			wait for periode_mclk_v;		  		
			SDA_io <= '0';					  	
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';	
			wait for periode_mclk_v;
			SDA_io <= 'Z';						
			
			-- wait for periode_mclk_v;		
			-- SDA_io <= '0'; 			           
			-- wait for periode_mclk_v;		  		
			-- SDA_io <= '1';					  	
			-- wait for periode_mclk_v;
			-- SDA_io <= '0';
			-- wait for periode_mclk_v;
			-- SDA_io <= '1';
			-- wait for periode_mclk_v;
			-- SDA_io <= '0';
			-- wait for periode_mclk_v;
			-- SDA_io <= '0';
			-- wait for periode_mclk_v;
			-- SDA_io <= '1';
			-- wait for periode_mclk_v;
			-- SDA_io <= '1';	
			-- wait for periode_mclk_v;
			-- SDA_io <= 'Z';		
				
	
			wait for periode_mclk_v + periode_mclk_v/2;	

	----------------------------------------------------------------------------------
	-- Slave call read 
	----------------------------------------------------------------------------------
			SDA_io <= '1'; 			          	--adr 110 0010 
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v/2;	
			
			SDA_io <= '0'; 					
			wait for periode_mclk_v;		  	--Reg msb 0011		
			SDA_io <= '1';					  	
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '1';						--not(W)
			wait for periode_mclk_v;
			SDA_io <= 'Z';
			wait for periode_mclk_v;
			
	----------------------------------------------------------------------------------
	-- Slave Wait
	----------------------------------------------------------------------------------
			 SDA_io <= 'Z'; 			           			
			 wait for periode_mclk_v;		  	--Reg msb 0011		
			 SDA_io <= 'Z';					  	
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';
			 wait for periode_mclk_v;
			 SDA_io <= 'Z';						--not(W)
			 wait for periode_mclk_v;
			 SDA_io <= '1';

	----------------------------------------------------------------------------------
	-- Stop
	----------------------------------------------------------------------------------			

			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v/2;
			SDA_io <= '1';
			wait;
	end process;	
end architecture;	