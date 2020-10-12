LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY toplevel IS
   PORT ( CLOCK_50, CLOCK2_50, AUD_DACLRCK   : IN		STD_LOGIC;
			AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT  	: IN    	STD_LOGIC;
			AUD_DACDAT									: OUT		STD_LOGIC;
			--KEY                                	: IN    	STD_LOGIC_VECTOR(0 DOWNTO 0);     --renamed to master_reset
			master_reset								: IN		STD_LOGIC;
			AUD_XCK										: out   	STD_LOGIC;
			FPGA_I2C_SDAT                      	: INOUT 	STD_LOGIC;
			FPGA_I2C_SCLK								: OUT		STD_LOGIC
		);
END toplevel;

ARCHITECTURE Behavior OF toplevel IS
   COMPONENT clock_generator
      PORT( CLOCK_27 : IN STD_LOGIC;
            reset    : IN STD_LOGIC;
            AUD_XCK  : OUT STD_LOGIC);
   END COMPONENT;

   COMPONENT audio_and_video_config
		PORT( CLOCK_50	:	IN 	STD_LOGIC;
				RESET		:	IN 	STD_LOGIC;
				I2C_SDAT	:	INOUT STD_LOGIC;
				I2C_SCLK	:	OUT	STD_LOGIC);
   END COMPONENT;
	
	COMPONENT audio_codec
		PORT( CLOCK_50			:	IN		STD_LOGIC;
				RESET				: 	IN		STD_LOGIC;
				READ_S			:	IN		STD_LOGIC;
				WRITE_S			:	IN		STD_LOGIC;
				WRITEDATA_LEFT :	IN 	STD_LOGIC_VECTOR(23 DOWNTO 0);
				WRITEDATA_RIGHT:	IN 	STD_LOGIC_VECTOR(23 DOWNTO 0);
				AUD_ADCDAT 		:	IN		STD_LOGIC;
				AUD_BCLK 		:	IN		STD_LOGIC;
				AUD_ADCLRCK		:	IN		STD_LOGIC;
				AUD_DACLRCK		:	IN		STD_LOGIC;
				read_ready		:	OUT	STD_LOGIC;
				write_ready		:	OUT	STD_LOGIC;
				readdata_left	:	OUT	STD_LOGIC_VECTOR(23 DOWNTO 0);
				readdata_right	:	OUT	STD_LOGIC_VECTOR(23 DOWNTO 0);
				AUD_DACDAT		:	OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT controller IS
		PORT(	CLOCK_50			:	IN		STD_LOGIC;
				RESET				: 	IN		STD_LOGIC;
				read_ready		:	IN		STD_LOGIC;
				write_ready		:	IN		STD_LOGIC;
				READ_S			:	OUT	STD_LOGIC;
				WRITE_S			:	OUT	STD_LOGIC;
				readdata_left	:	IN		STD_LOGIC_VECTOR(23 DOWNTO 0);
				readdata_right	:	IN		STD_LOGIC_VECTOR(23 DOWNTO 0);
				WRITEDATA_LEFT :	OUT 	STD_LOGIC_VECTOR(23 DOWNTO 0);
				WRITEDATA_RIGHT:	OUT 	STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	END COMPONENT;

   SIGNAL s_read_ready, s_write_ready, s_read, s_write	: STD_LOGIC;
   SIGNAL s_readdata_left, s_readdata_right            	: STD_LOGIC_VECTOR(23 DOWNTO 0);
   SIGNAL s_writedata_left, s_writedata_right          	: STD_LOGIC_VECTOR(23 DOWNTO 0);  
	SIGNAL s_reset														: STD_LOGIC;
 
BEGIN
	s_reset <= NOT(master_reset);			-- active high reset
										
	my_clock_gen: clock_generator PORT MAP (CLOCK2_50, s_reset, AUD_XCK);
	my_audio_and_video_config : audio_and_video_config	PORT MAP (CLOCK_50, s_reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
	my_audio_codec : audio_codec PORT MAP(CLOCK_50, s_reset, s_read, s_write, s_writedata_left, s_writedata_right,
										AUD_ADCDAT, AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK, s_read_ready, s_write_ready,
										s_readdata_left, s_readdata_right, AUD_DACDAT);
									
	my_controller : controller	PORT MAP (CLOCK_50, s_reset, s_read_ready, s_write_ready, s_read, s_write,
													s_readdata_left, s_readdata_right, s_writedata_left, s_writedata_right);

END Behavior;
