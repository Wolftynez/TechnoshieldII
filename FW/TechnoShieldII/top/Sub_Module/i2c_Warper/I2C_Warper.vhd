---------------------------------------------------------------------------
-- Stack Component
-- 2/2/2021 V.2
---------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Warper_i2c is  


	port(
		sda_io 	: inout std_logic;
		scl_io	: inout std_logic;
		Data_in_I2C	: in std_logic_vector(7 downto 0);
		Data_out_I2C	: out std_logic_vector(7 downto 0);
		clk	: in std_logic;
		Wake_up : out std_logic
	);

end entity;

architecture behavioral of Warper_i2c is

	component SB_I2C is
	
		generic (
			I2C_SLAVE_INIT_ADDR: string:= "0b1100010";
			BUS_ADDR74: string:= "0b0011"
		);
	
		port(
		SBCLKI : in std_logic;
		SBRWI : in std_logic;
		SBSTBI : in std_logic;

		
		SBADRI0 : in std_logic;
		SBADRI1 : in std_logic;
		SBADRI2 : in std_logic;
		SBADRI3 : in std_logic;
		SBADRI4 : in std_logic;
		SBADRI5 : in std_logic;
		SBADRI6 : in std_logic;
		SBADRI7 : in std_logic;
		
		SBDATI0 : in std_logic;
		SBDATI1 : in std_logic;
		SBDATI2 : in std_logic;
		SBDATI3 : in std_logic;
		SBDATI4 : in std_logic;
		SBDATI5 : in std_logic;
		SBDATI6 : in std_logic;
		SBDATI7 : in std_logic;
		
		SBDATO0 : out std_logic;
		SBDATO1 : out std_logic;
		SBDATO2 : out std_logic;
		SBDATO3 : out std_logic;
		SBDATO4 : out std_logic;
		SBDATO5 : out std_logic;
		SBDATO6 : out std_logic;
		SBDATO7 : out std_logic;
		
		SBACKO : out std_logic;
		SCLI : in std_logic;
		SCLO : out std_logic;
		SCLOE :out std_logic;
		SDAI : in std_logic;
		SDAO : out std_logic;
		SDAOE : out std_logic;
		
		I2CIRQ: out std_logic
		);
		
	end component;
	
	
	type etat_t is (
		init_e, 
		init_set_irq_in_e, init_set_irq_out_e, 
		init_set_slave_in_e, init_set_slave_out_e, 
		init_set_delayed_in_e, init_set_delayed_out_e, 
		init_set_addr_in_e, init_set_addr_out_e, 
		idle_e, 
		Clear_IRQ_in_e, Clear_IRQ_out_e, 
		read_in_e, read_mid_e, read_out_e,
		write_in_e, write_out_e
	);
	signal etat_s : etat_t := init_e;
	signal data_out_s : std_logic_vector(7 downto 0);
	signal data_in_s : std_logic_vector(7 downto 0):=x"00";
	signal adr_s : std_logic_vector(7 downto 0):=x"00";
	signal ack_s : std_logic:='0';
	signal WE_s : std_logic:='0';
	signal strobe_s : std_logic:='0';
	signal TRRDY_s, sdao_s, sdai_s, sdaoe_s, sclo_s, scli_s, scloe_s : std_logic:='0';
	signal I2C_is_read : std_logic := '0';



	begin
	
I2Cinst0 : SB_I2C
	generic map(			
		I2C_SLAVE_INIT_ADDR => "0b0000111110",
		BUS_ADDR74 => "0b0011"
		)

	port map (
		clk,
		WE_s,
		strobe_s,

		--adr_s,
 		adr_s(0),
		adr_s(1),
		adr_s(2),
		adr_s(3),
		adr_s(4),
		adr_s(5),
		adr_s(6),
		adr_s(7),
		
		--data_in_s,
		data_in_s(0),
		data_in_s(1),
		data_in_s(2),
		data_in_s(3),
		data_in_s(4),
		data_in_s(5),
		data_in_s(6),
		data_in_s(7),

		--data_out_s,
		data_out_s(0),
		data_out_s(1),
		data_out_s(2),
		data_out_s(3),
		data_out_s(4),
		data_out_s(5),
		data_out_s(6),
		data_out_s(7), 

		ack_s,
		scli_s,
		sclo_s,
		scloe_s,
		sdai_s,
		sdao_s,
		sdaoe_s,
		
		TRRDY_s
	);
	
	
	
	
	adr_s(7 downto 4) <=  b"0011";	
	
		sdai_s <= sda_io;
		
		process(sdao_s, sdaoe_s)
		begin
			if sdaoe_s = '1' then
				sda_io <= sdao_s;
			else
				sda_io <= 'Z';
			end if;
		end process;
		
		scli_s <= scl_io;
		scl_io <= 'Z';		
---------------------------------------------------------
--
---------------------------------------------------------			
		
		
	--machine à État
	process(clk)
	begin
		if rising_edge(clk) then
			case etat_s is
			
				when init_e =>
				etat_s <= init_set_slave_in_e;



				when init_set_slave_in_e =>
					if ack_s = '1' then
						etat_s <= init_set_slave_out_e;
					end if;
				
				when init_set_slave_out_e =>
						etat_s <= init_set_addr_in_e;
					
					
					
				when init_set_addr_in_e =>
					if ack_s = '1' then
						etat_s <= init_set_addr_out_e;
					end if;
				
				when init_set_addr_out_e =>
						etat_s <= init_set_delayed_in_e;	

						
						
				when init_set_delayed_in_e =>
					if ack_s = '1' then
						etat_s <= init_set_delayed_out_e;
					end if;
				
				when init_set_delayed_out_e =>
						etat_s <= init_set_irq_in_e;	
						
						
						
				when init_set_irq_in_e =>
					if ack_s = '1' then
						etat_s <= init_set_irq_out_e;
					end if;
					
				when init_set_irq_out_e =>
					etat_s <= Clear_IRQ_in_e;
					
					
					
				when idle_e =>
					if TRRDY_s = '1' then
						etat_s <= read_in_e;
					else
						etat_s <= idle_e;
					end if;
					
					
					
				when read_in_e =>
					if ack_s = '1' then
						etat_s <= read_mid_e;
					end if;	
					
				when read_mid_e => 
					etat_s <= read_out_e;
				
				when read_out_e =>
					etat_s <= Clear_IRQ_in_e;
					
					
					
				when Clear_IRQ_in_e =>
					if ack_s = '1' then
						etat_s <= Clear_IRQ_out_e;
					end if;
				
				when Clear_IRQ_out_e =>
					if I2C_is_read = '0' then
						etat_s <= idle_e;
					else
						etat_s <= write_in_e;
					end if;
					
					
					
				when write_in_e =>
					if ack_s = '1' then
						etat_s <= write_out_e;
					end if;
					
				when write_out_e =>
					etat_s <= Clear_IRQ_in_e;
					
			end case;
		end if;
	end process;

	
	
	process(etat_s)
	begin
		case etat_s is
		
	    --*************************************-- 
		--*			INIT STATE				  *--        
		--*************************************--
			when init_e =>							--Init State
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";	
			
			data_in_s <= x"00";		--do nothing		
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
			
	    --************************************-- 
		--*	      INIT SET SLAVE I2C	     *--          
		--************************************--	
			when init_set_addr_in_e =>			
			WE_s <= '1';							--Set Address I2C (0111110x)
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"3";
			data_in_s <= x"0f";
			
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing	
			
			when init_set_addr_out_e =>				--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing	
			
		--************************************-- 
		--*	      INIT SET delayed I2C	     *--          
		--************************************--	
			when init_set_delayed_in_e =>			--Recommended by Lattice DOC : AdvancediCE40SPII2CHardenedIPUsageGuide.pdf
			WE_s <= '1';							--Disable Clock Stretching	
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"9";
			data_in_s <= x"04";
			
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing		
			
			when init_set_delayed_out_e =>			--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
	    --************************************-- 
		--*	      INIT SET SLAVE Addr I2C	     *--          
		--************************************--	
			when init_set_slave_in_e =>				
			WE_s <= '1';								
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"8";
			data_in_s <= x"84";
			Wake_up <= '1';
			Data_out_I2C <= b"00100011";
			
			when init_set_slave_out_e =>			--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing	
			
	    --************************************-- 
		--*	    INIT SET Interrupt I2C   	 *--      
		--************************************--				
			when init_set_irq_in_e =>				--Initialise Interrupt Transmittion ready
			WE_s <= '1';							--REG: x7 addr: bit 2
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"7";
			data_in_s <= x"04";
			Wake_up <= '1';
			Data_out_I2C <= b"00100010";
			
			when init_set_irq_out_e =>		   		--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
	    --************************************-- 
		--*	          IDLE STATE		     *--         
		--************************************--				
			when idle_e =>						--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
	    --************************************--
		--*	        READ I2C CHIP 		     *--        
		--************************************--				
			when Read_in_e =>						--Read I2C Instruction / RX REG 
			WE_s <= '0';							--REG I2CRXDR: xE; addr data: ALL
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"E";
			data_in_s <= x"00"; -- fait rien
			
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing

			
			when Read_mid_e =>
			WE_s <= '0';							--REG I2CRXDR: xE; addr data: ALL
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"E";
			Data_out_I2C <= data_out_s;
			Wake_up <= '1';
			
			if data_out_s(1) = '0' then				--logic for entering write state
				I2C_is_read <= '1';
			else
				I2C_is_read <= '0';
			end if;
			
			data_in_s <= x"00";		--do nothing
			
			when Read_out_e =>
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
			
			
	    --************************************--
		--*	        Write I2C CHIP 		     *--        
		--************************************--				
			when write_in_e =>						--Read I2C Instruction / RX REG 
			WE_s <= '1';							--REG I2CRXDR: xE; addr data: ALL
			strobe_s <= '1';
			adr_s(3 downto 0) <= x"D";
			data_in_s <= Data_in_I2C; 
			
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			I2C_is_read <= '0';

			
			when write_out_e =>
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing			
	    --************************************-- 
		--*	       CLEAR INTERRUPT 			 *--         
		--************************************--			
			when Clear_IRQ_in_e =>
			WE_s <= '1';
			strobe_s <= '1';
			adr_s(3 downto 0) <=x"6";
			data_in_s <= x"04";
			
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing
			
			when Clear_IRQ_out_e =>					--Deassert all signal
			WE_s <= '0';
			strobe_s <= '0';
			adr_s(3 downto 0) <= b"0000";
			
			data_in_s <= x"00";		--do nothing
			Data_out_I2C <= x"00"; 	--do nothing
			Wake_up <= '0';			--do nothing	
		
		end case;
	end process;	
		
	end behavioral;

