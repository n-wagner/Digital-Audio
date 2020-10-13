LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY controller IS
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
END controller;

ARCHITECTURE BEHAVIORAL OF controller IS
	SIGNAL s_current_sample_left  : STD_LOGIC_VECTOR(23 DOWNTO 0);
	SIGNAL s_current_sample_right : STD_LOGIC_VECTOR(23 DOWNTO 0);
BEGIN

	

	control_proc : process (CLOCK_50)
	begin
		if (reset = '1') then --active high reset
			READ_S <= '0';
			WRITE_S <= '0';
			s_current_sample_left <= "000000000000000000000000";
			s_current_sample_right <= "000000000000000000000000";
		else
			READ_S <= read_ready;
			WRITE_S <= write_ready;
			if (write_ready = '1') then
				s_current_sample_left <= readdata_left;
				s_current_sample_right <= readdata_right;
			else
				s_current_sample_left <= s_current_sample_left;
				s_current_sample_right <= s_current_sample_right;
			end if;

		end if;
		WRITEDATA_LEFT <= s_current_sample_left;
		WRITEDATA_RIGHT <= s_current_sample_right;
	end process;

END BEHAVIORAL;