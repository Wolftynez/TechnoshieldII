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

entity I2C_Warper_tb is 
	generic(
    periode_mclk_v : time:= 2500 ns -- periode SCL_io
	);
end entity;

-------------------------------------------------------------------------------------------
-- Declaration de l'architecture
-------------------------------------------------------------------------------------------
architecture I2C_Warper_a1 of I2C_Warper_tb is 

	component warper_i2c
		port(
		sda_io 	: inout std_logic;
		scl_io	: inout std_logic;
		Data_in_I2C	: in std_logic_vector(7 downto 0);
		Data_out_I2C	: out std_logic_vector(7 downto 0);
		clk	: in std_logic;
		Wake_up : out std_logic
	);
		
	end component;
		
	signal	clk_s			 : std_logic:='1';	
	signal	SDA_io		 	 : std_logic:='1';		
	signal	SCL_io       	 : std_logic:='1';
	signal Data_in_I2C		 : std_logic_vector(7 downto 0) := x"0F";
	signal Data_out_I2C		 : std_logic_vector(7 downto 0) := x"00";	
	signal wake_s		 	 : std_logic :='0';
		
begin	

----------------------------------------------------------------------------------
-- Instanciation du module technoshield_top0
----------------------------------------------------------------------------------

	warper_i2c0 : warper_i2c
	
	port map(
		SDA_io,
		SCL_io,
		Data_in_I2C,
		Data_out_I2C,	
		clk_s,
		wake_s
	);



----------------------------------------------------------------------------------
-- process de generation de l'horloge clk
----------------------------------------------------------------------------------
	process
	begin
			clk_s <= '0';
			wait for 20 ns;
			clk_s <= '1';
			wait for 20 ns;
	end process;
				

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
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';	
			wait for periode_mclk_v;
			SDA_io <= 'Z';						
			
			wait for periode_mclk_v;		
			SDA_io <= '0'; 			           
			wait for periode_mclk_v;		  		
			SDA_io <= '1';					  	
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '1';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '0';
			wait for periode_mclk_v;
			SDA_io <= '1';	
			wait for periode_mclk_v;
			SDA_io <= 'Z';		
				
	
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