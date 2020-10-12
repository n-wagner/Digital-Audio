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
		if (reset = '0') then --active low reset
			READ_S <= '0';
			WRITE_S <= '0';
			s_current_sample_left <= "000000000000000000000000";
			s_current_sample_right <= "000000000000000000000000";
		elsif rising_edge(CLOCK_50) then
			if (read_ready = '1') then
				s_current_sample_left <= readdata_left;
				s_current_sample_right <= readdata_right;
				READ_S <= '1';
				WRITE_S <= '0';
			elsif (write_ready = '1') then
				WRITEDATA_LEFT <= s_current_sample_left;
				WRITEDATA_RIGHT <= s_current_sample_right;
				READ_S <= '0';
				WRITE_S <= '1';
			else
				s_current_sample_left <= s_current_sample_left;
				s_current_sample_right <= s_current_sample_right;
				READ_S <= '0';
				WRITE_S <= '0';
			end if;
		end if;
	end process;

END BEHAVIORAL;