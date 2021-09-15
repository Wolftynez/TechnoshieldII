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

entity stack_tb is 
	generic(
    periode_mclk_v : time:= 250 ns -- periode SCL_io
	);
end entity;

-------------------------------------------------------------------------------------------
-- Declaration de l'architecture
-------------------------------------------------------------------------------------------
architecture stack_a0 of stack_tb is 

	component stack
		port(
	Data_out_I2C_o: out std_logic_vector(15 downto 0);
	Data_out_I2C_i : in  std_logic_vector(7 downto 0);
	clk     : in std_logic;
	Enable : out std_logic;
	Wake_up : in std_logic
	);
		
	end component;
		
	signal Data_out_I2C_o	:	std_logic_vector(15 downto 0);
	signal Data_out_I2C_i 	:	std_logic_vector(7 downto 0);
	signal clk     		:	std_logic;
	signal Enable 		:	std_logic;
	signal Wake_up  	: 	std_logic;
		
begin	

----------------------------------------------------------------------------------
-- Instanciation du module technoshield_top0
----------------------------------------------------------------------------------

	stack0 : stack
	
	port map(
	Data_out_I2C_o,
	Data_out_I2C_i,
	clk,
	Enable,
	Wake_up
	);

----------------------------------------------------------------------------------
-- process de generation de l'horloge clk
----------------------------------------------------------------------------------
	process
	begin
			clk <= '0';
			wait for periode_mclk_v/2;
			clk <= '1';
			wait for periode_mclk_v/2;
	end process;
				
----------------------------------------------------------------------------------
-- process de Simuation
----------------------------------------------------------------------------------
	process
	begin
		Data_out_I2C_i <= b"11010011";
		Wake_up <= '1';
		wait for periode_mclk_v;
		Data_out_I2C_i <= b"10101010";
		Wake_up <= '1';
		wait for periode_mclk_v;
		Wake_up <= '0';
		wait for periode_mclk_v;
		Data_out_I2C_i <= b"01010011";
		Wake_up <= '1';
		wait for periode_mclk_v;
		Wake_up <= '0';
		
		
		
		
		
		
		wait;
				
	end process;	
end architecture;	