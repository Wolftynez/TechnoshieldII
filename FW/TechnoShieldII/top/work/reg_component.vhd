---------------------------------------------------------------------------
-- Register Component
-- 2/2/2021 V.2
---------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_component is  


	port(
	Data_in_I2C_o: out std_logic_vector(7 downto 0) := x"00";
	Data_out_Stack_i : in  std_logic_vector(15 downto 0);
	clk     : in std_logic;
	Enable : in std_logic;
	Led_o : out std_logic_vector(4 downto 0);
	but_i : in std_logic_vector(3 downto 0)
	);

end entity;

architecture behavioral of reg_component is

	type Reg_8 is array (3 downto 0, 7 downto 0) of std_logic;
	type Reg_32 is array (3 downto 0, 31 downto 0) of std_logic;
	
	signal last_temp : std_logic_vector(7 downto 0) := x"00";
	signal temp : std_logic_vector(7 downto 0) :=x"00";
	signal Write_EN : STD_LOGIC;
	signal IO_register: Reg_8 := (others => (others => '0'));
	signal High_depth_reg : Reg_32 := (others => (others => '0'));

	begin
	
		Write_EN <= Data_out_Stack_i(1);
		
---------------------------------------------------------
--Reg 32 + 8
---------------------------------------------------------			
		
		process(clk)
		begin
			if rising_edge(clk) then
				if Enable = '1' then
					if Data_out_Stack_i(7) = '1' then 
						if Write_EN = '1' then
							for j in 0 to 7 loop
							High_depth_reg(conv_integer(Data_out_Stack_i(6 downto 5)), j + (conv_integer(Data_out_Stack_i(3 downto 2)) * 8)) <= Data_out_Stack_i(j + 8);
							end loop;
						else
							for k in 0 to 7 loop
							Data_in_I2C_o(k) <= High_depth_reg(conv_integer(Data_out_Stack_i(6 downto 5)), k + (conv_integer(Data_out_Stack_i(3 downto 2)) * 8));
							end loop;
						end if;
					else
						if Write_EN = '1' then
							IO_register(conv_integer(Data_out_Stack_i(6 downto 5)),conv_integer(Data_out_Stack_i(4 downto 2))) <= Data_out_Stack_i(0);
						else
							for i in 0 to 7 loop
							Data_in_I2C_o(i) <= IO_register(conv_integer(Data_out_Stack_i(6 downto 5)),i);
							end loop;
						end if;
					end if;
				end if;	
			end if;	
		end process;
		
----------------------------------------
--Assignation I/o
----------------------------------------

	Led_o(0) <= IO_register(1, 0);
	Led_o(1) <= IO_register(1, 1);
	Led_o(2) <= IO_register(1, 2);
	Led_o(3) <= IO_register(1, 3);
	Led_o(4) <= IO_register(1, 4);

	-- IO_register(0, 1) <= but_i(0);
	-- IO_register(0, 2) <= but_i(1);		
	-- IO_register(0, 3) <= but_i(2);
	-- IO_register(0, 4) <= but_i(3);	
	
	
	end behavioral;

