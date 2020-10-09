LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY toplevel IS
   PORT ( CLOCK_50, CLOCK2_50, AUD_DACLRCK   	: IN    STD_LOGIC;
          AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT  	: IN    STD_LOGIC;
          KEY                                	: IN    STD_LOGIC_VECTOR(0 DOWNTO 0);
			 AUD_XCK											: out  STD_LOGIC;
          FPGA_I2C_SDAT                      	: INOUT STD_LOGIC
          --finish the rest of the ports			);
			 );
END toplevel;

ARCHITECTURE Behavior OF toplevel IS
   COMPONENT clock_generator --this component is completed for you
      PORT( CLOCK_27 : IN STD_LOGIC;
            reset    : IN STD_LOGIC;
            AUD_XCK  : OUT STD_LOGIC);
   END COMPONENT;

   COMPONENT audio_and_video_config IS
      --finish this component
		PORT ( CLOCK_50 : IN STD_LOGIC;
				 reset    : IN STD_LOGIC;
				 I2C_SDAT : INOUT STD_LOGIC;
				 I2C_SCLK : OUT STD_LOGIC
				);
   END COMPONENT;   

   --COMPONENT --complete this component

   --END COMPONENT;

   SIGNAL read_ready, write_ready, read_s, write_s 		: STD_LOGIC;
   SIGNAL readdata_left, readdata_right            		: STD_LOGIC_VECTOR(23 DOWNTO 0);
   SIGNAL writedata_left, writedata_right          		: STD_LOGIC_VECTOR(23 DOWNTO 0);   
   SIGNAL reset                                    		: STD_LOGIC;
 
BEGIN
	reset <= NOT(KEY(0));

   	--YOUR "glue" CODE GOES HERE
   	--connect the wires between the components in the correct direction
   
  	my_clock_gen: clock_generator PORT MAP (CLOCK2_50, reset, AUD_XCK);

  
END Behavior;
