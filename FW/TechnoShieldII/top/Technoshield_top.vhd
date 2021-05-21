---------------------------------------------------------------------------
-- 
-- 
---------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

entity Technoshield_top is
    Port ( 
		but_i      : in STD_LOGIC_VECTOR (3 downto 0);
		Led_o 	  	  : out STD_LOGIC_VECTOR (4 downto 0);
		Led_RGB_o     : inout std_logic_vector (2 downto 0);
		SDA_io		  : inout std_logic;		
		SCL_io        : inout std_logic
	);
	

end entity;


architecture Behavioral of  Technoshield_top is


	-- component SB_LED_DRV_CUR is 
		
		-- port(
		-- EN	: in std_logic;
		-- LEDPU : out std_logic
		-- );
	-- end component;
	
	-- component SB_RGB_DRV is

		
		-- port(
		-- RGBLEDEN 	: in std_logic;
		-- RGB0PWM		: in std_logic;
		-- RGB1PWM		: in std_logic;
		-- RGB2PWM		: in std_logic;
		-- RGBPU		: in std_logic;
		-- RGB0		: out std_logic;	
		-- RGB1		: out std_logic;
		-- RGB2		: out std_logic
		-- );
	-- end component;

	component stack
		port(
			Data_out_I2C_o: out std_logic_vector(15 downto 0);
			Data_out_I2C_i : in  std_logic_vector(7 downto 0);
			clk     : in std_logic;
			Enable : out std_logic;
			Wake_up : in std_logic
		);
	end component;
	

	
	component reg_component
		port(
			Data_in_I2C_o: out std_logic_vector(7 downto 0);
			Data_out_Stack_i : in  std_logic_vector(15 downto 0);
			clk     : in std_logic;
			Enable : in std_logic;
			Led_o : out std_logic_vector(4 downto 0);
			Led_OD_o : out std_logic_vector(2 downto 0);
			but_i : in std_logic_vector(3 downto 0)
		);
	end component;



	component Warper_i2c
		port(
		sda_io 	: inout std_logic;
		scl_io	: inout std_logic;
		Data_in_I2C	: in std_logic_vector(7 downto 0);
		Data_out_I2C	: out std_logic_vector(7 downto 0);
		clk	: in std_logic;
		Wake_up : out std_logic
	);
		
	end component;	
		


	component SB_HFOSC is
	
		generic (
		CLKHF_DIV: string:="0b00"
		);
	
		port(
		CLKHF : out std_logic;	
		CLKHFEN : in std_logic;
		CLKHFPU : in STD_LOGIC	
		);
		
	end component;


	
	component SB_IO_OD is
	
		generic(
			NEG_TRIGGER : bit						:=	'0';
			PIN_TYPE	: bit_vector (5 downto 0)	:=	"000000"
		);
		
		port(
		DOUT1 : in std_logic;           
		DOUT0 : in std_logic;  
		CLOCKENABLE : in std_logic;
		LATCHINPUTVALUE : in std_logic;
		INPUTCLK : in std_logic;
		DIN1 : out std_logic;
		DIN0 : out std_logic;
		OUTPUTENABLE : in std_logic;
		OUTPUTCLK : in std_logic;
		PACKAGEPIN : inout std_logic
		);
		
	end component;			
	



	signal Led_rgb_s : std_logic_vector(2 downto 0); 
	signal clk     :  STD_LOGIC:= '0';


--Signal for Stack and Reg

	signal Data_out_stack : std_logic_vector(15 downto 0) := x"0000";
	signal Wake_up : std_logic := '0';
	signal Enable : std_logic := '0';
	signal Data_in_I2C : std_logic_vector(7 downto 0) := x"00";
	signal Data_out_I2C : std_logic_vector(7 downto 0) := x"00";

begin

	-- LED_CUR_inst0 : SB_LED_DRV_CUR
	
	-- port map(
	-- '1',
	-- LEDPU
	-- );
	
	-- RGB_inst0 : SB_RGB_DRV
	
	-- port map (
	-- '1',
	-- Led_s(0),
	-- Led_s(1),
	-- Led_s(2),
	-- LEDPU
	-- Led_Red_o(0),
	-- Led_Red_o(1),
	-- Led_Red_o(2)
	-- );
	
	
	
	Warper0 : Warper_i2c 
	
		port map (
			SDA_io,
			SCL_io,
			Data_in_I2C,
			Data_out_I2C,
			clk,
			Wake_up
		);
	
	
	
	stack0 : stack
	
		port map (
			Data_out_stack,
			Data_out_I2C,
			clk,
			Enable,
			Wake_up
		);
	

	
	reg_component0 : reg_component
	
		port map (
			Data_in_I2C,
			Data_out_stack,
			clk,
			Enable,
			Led_o,
			Led_rgb_s,
			but_i
		);
		

		
	OD0 : SB_IO_OD  
	
		generic map ( 
			NEG_TRIGGER =>	'0',
			PIN_TYPE	=>	"011001"
					) 
					
		port map (   
					DOUT1 => open,
					DOUT0 =>  Led_rgb_s(0),  -- leave open
					CLOCKENABLE => open,
					LATCHINPUTVALUE => '0', 
					INPUTCLK => open,
					DIN0 => open,
					DIN1 => open,
					OUTPUTENABLE => '0', 
					OUTPUTCLK => open,
					PACKAGEPIN  => Led_RGB_o(0)
				);
				

				
	OD1 : SB_IO_OD  
	
		generic map ( 
			NEG_TRIGGER =>	'0',
			PIN_TYPE	=>	"011001"
					) 
					
		port map (        
					DOUT1 => open,
					DOUT0 =>  Led_rgb_s(1),  -- leave open
					CLOCKENABLE => open,
					LATCHINPUTVALUE => '0', -- i do not want to latch the input.
					INPUTCLK => open,
					DIN0 => open,
					DIN1 => open,
					OUTPUTENABLE => '0', -- disable the output.
					OUTPUTCLK => open,
					PACKAGEPIN  => Led_RGB_o(1)
				);	



	OD2 : SB_IO_OD  
	
		generic map ( 
			NEG_TRIGGER =>	'0',
			PIN_TYPE	=>	"011001"
					) 
					
		port map (     
					DOUT1 => open,
					DOUT0 =>  Led_rgb_s(2),  -- leave open
					CLOCKENABLE => open,
					LATCHINPUTVALUE => '0', -- i do not want to latch the input.
					INPUTCLK => open,
					DIN0 => open,
					DIN1 => open,
					OUTPUTENABLE => '0', -- disable the output.
					OUTPUTCLK => open,
					PACKAGEPIN  => Led_RGB_o(2)
				);
	HFOSCinst0 : SB_HFOSC
	
		generic map(
			CLKHF_DIV => "0b10"
		)
		port map (
			clk,
			'1',
			'1'
		);
	


end Behavioral;
