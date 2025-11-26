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
	Data_in_I2C_o: out std_logic_vector(7 downto 0);
	Data_out_Stack_i : in  std_logic_vector(15 downto 0);
	clk     : in std_logic;
	Enable : in std_logic;
	PMOD1_io : inout std_logic_vector(3 downto 0);
	PMOD2_io : inout std_logic_vector(3 downto 0);
	Led_o : out std_logic_vector(4 downto 0);
	Led_OD_o : out std_logic_vector(2 downto 0);
	but_i : in std_logic_vector(3 downto 0)
	);

end entity;

architecture behavioral of reg_component is

	type Reg_8 is array (3 downto 0, 7 downto 0) of std_logic;
	type Reg_32 is array (3 downto 0, 31 downto 0) of std_logic;
	
	signal Led_Blink_s : std_logic := '0';
	signal Led_io_o : std_logic := '0';
	signal COUNTER : STD_LOGIC_VECTOR(23 downto 0):= x"000000";
	--signal PWM_counter : STD_LOGIC_VECTOR(
	signal Write_EN : STD_LOGIC;
	signal IO_register: Reg_8 := (others => (others => '0'));
	signal High_depth_reg : Reg_32 := (others => (others => '0'));

	begin
	
		Write_EN <= Data_out_Stack_i(1);

---------------------------------------------------------------------------
--PMOD_PWM
---------------------------------------------------------------------------	

 	-- process (clk)
	-- begin
		-- if rising_edge(clk) then
			-- PWM_counter <+ PWM_counter + 1;
			
			
			
			
			
			
			
			
			
			
		-- end if;
	
	
	-- end process; 






---------------------------------------------------------------------------
--Selecteur PMOD In/out
---------------------------------------------------------------------------	
	-- process (clk)
	-- begin
		-- if rising_edge(clk) then
			-- if IO_register(3, 0) = '1' then
				-- IO_register(2, 0) <= PMOD1_io(0);
				-- PMOD1_io(0) <= 'Z';
			-- else 
				-- PMOD1_io(0) <= PMOD_pwm_s(0);
			-- end if;
			
			-- if IO_register(3, 1) = '1' then
				-- IO_register(2, 1) <= PMOD1_io(1);
				-- PMOD1_io(1) <= 'Z';
			-- else
				-- PMOD1_io(1) <= PMOD_pwm_s(1);
			-- end if;
	
			-- if IO_register(3, 2) = '1' then
				-- IO_register(2, 2) <= PMOD1_io(2);
				-- PMOD1_io(2) <= 'Z';
			-- else
				-- PMOD1_io(2) <= PMOD_pwm_s(2);
			-- end if;
			
			-- if IO_register(3, 3) = '1' then
				-- IO_register(2, 3) <= PMOD1_io(3);
				-- PMOD1_io(3) <= 'Z';
			-- else
				-- PMOD1_io(3) < = PMOD_pwm_s(3);
			-- end if;
			
			-- if IO_register(3, 4) = '1' then
				-- IO_register(2, 4) <= PMOD2_io(0);
				-- PMOD2_io(0) <= 'Z';
			-- else
				-- PMOD2_io(0) < = PMOD_pwm_s(4);
			-- end if;
			
			-- if IO_register(3, 5) = '1' then
				-- IO_register(2, 5) <= PMOD2_io(1);
				-- PMOD2_io(1) <= 'Z';
			-- else
				-- PMOD2_io(1) < = PMOD_pwm_s(5);
			-- end if;
			
			-- if IO_register(3, 6) = '1' then
				-- IO_register(2, 6) <= PMOD2_io(2);
				-- PMOD2_io(2) <= 'Z';
			-- else
				-- PMOD2_io(2) < = PMOD_pwm_s(6);
			-- end if;

			-- if IO_register(3, 7) = '1' then
				-- IO_register(2, 7) <= PMOD2_io(3);
				-- PMOD2_io(3) <= 'Z';
			-- else
				-- PMOD2_io(3) < = PMOD_pwm_s(7);
			-- end if;
		-- end if;
	-- end process;	

----------------------------------------------------------
--Compteur blink
----------------------------------------------------------
		
	process (clk) 
		begin  
			if (rising_edge(clk)) then
				if COUNTER > x"B71B00" then
					COUNTER <= (others => '0');
					Led_Blink_s <= not Led_Blink_s;
				else
					COUNTER <= COUNTER + 1;
					Led_Blink_s <= Led_Blink_s;
				end if;
			end if;
		end process;

---------------------------------------------------------
--Selecteur Blink
---------------------------------------------------------		
	process (IO_register)
		begin
			if IO_register(0, 7) = '1' then
				Led_o(0) <= Led_Blink_s;
			else
				Led_o(0) <= Led_io_o;
			end if;
		end process;		
						
				
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
				else
				
					Led_io_o <= not IO_register(1, 0);
					Led_o(1) <= not IO_register(1, 1);
					Led_OD_o(0) <= not IO_register(1, 2);
					Led_OD_o(1) <= not IO_register(1, 3);
					Led_OD_o(2) <= not IO_register(1, 4);
					Led_o(2) <= not IO_register(1, 5);
					Led_o(3) <= not IO_register(1, 6);
					Led_o(4) <= not IO_register(1, 7);
								
					IO_register(0,1) <= but_i(0);
					IO_register(0,2) <= but_i(1);
					IO_register(0,3) <= but_i(2);
					IO_register(0,4) <= but_i(3);
				end if;
			end if;	
		end process;
		
	
	
end behavioral;

