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

entity reg_component_tb is 
	generic(
    periode_mclk_v : time:= 250 ns -- periode SCL_io
	);
end entity;

-------------------------------------------------------------------------------------------
-- Declaration de l'architecture
-------------------------------------------------------------------------------------------
architecture reg_component_a0 of reg_component_tb is 

	component reg_component
		port(
		Data_in_I2C_o: out std_logic_vector(7 downto 0);
		Data_out_Stack_i : in  std_logic_vector(15 downto 0);
		clk     : in std_logic;
		Enable : in std_logic
	);
		
	end component;
		
	signal Data_in_I2C_o	:	std_logic_vector(7 downto 0);
	signal Data_out_Stack_i 	:	std_logic_vector(15 downto 0);
	signal clk     		:	std_logic;
	signal Enable 		:	std_logic;
		
begin	

----------------------------------------------------------------------------------
-- Instanciation du module technoshield_top0
----------------------------------------------------------------------------------

	reg_component0 : reg_component
	
	port map(
	Data_in_I2C_o,
	Data_out_Stack_i,
	clk,
	Enable
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
		Data_out_Stack_i <= b"0000000001010011";
		Enable <= '1';
		wait for periode_mclk_v;
		Data_out_Stack_i <= b"0000000001010111";
		Enable <= '1';
		wait for periode_mclk_v;
		Enable <= '0';
		wait for periode_mclk_v;
		Enable <= '1';
		Data_out_Stack_i <= b"0000000001010000";
		
		wait for periode_mclk_v;
		Data_out_Stack_i <= b"1010000011001011";
		Enable <= '1';

		wait for periode_mclk_v;
		Data_out_Stack_i <= b"0000000011001000";
		Enable <= '1';
		
		wait for periode_mclk_v;
		Enable <= '0';
		
		wait;
				
	end process;	
end architecture;	