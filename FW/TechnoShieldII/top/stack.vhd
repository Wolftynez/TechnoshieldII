---------------------------------------------------------------------------
-- Stack Component
-- 2/2/2021 V.2
---------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stack is  


	port(
	Data_out_I2C_o: out std_logic_vector(15 downto 0);
	Data_out_I2C_i : in  std_logic_vector(7 downto 0);
	clk     : in std_logic;
	Enable : out std_logic;
	Wake_up : in std_logic
	);

end entity;

architecture behavioral of Stack is

--type state_type is (not_busy, is_busy);


signal Data_LSB : std_logic_vector(7 downto 0) := x"00";
--signal state : state_type := not_busy;
signal isBusy : std_logic:= '0';

	begin
	
		
---------------------------------------------------------
--
---------------------------------------------------------			
		
		process(clk)
		begin
			if rising_edge(clk) then
				if wake_up = '1' then
					if isBusy = '0' then
						if Data_out_I2C_i(7) = '0' then
							Data_out_I2C_o <= b"00000000" & Data_out_I2C_i;
							Enable <= '1';
						else
							Data_LSB <= Data_out_I2C_i;
							isBusy <= '1';
							Enable <= '0';
						end if;
					else 
						Data_out_I2C_o <= Data_out_I2C_i & Data_LSB;
						isBusy <= '0';
						Enable <= '1';
					end if;	
				else 
					Enable <= '0';
				end if;
			end if;	
		end process;
		
	end behavioral;

