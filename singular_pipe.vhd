LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity singular_pipe is
	PORT
		( clk, vert_sync, reset, pause	: IN std_logic;
        pixel_row, pixel_column			: IN std_logic_vector(9 DOWNTO 0);
		  random_in								: IN STD_logic_vector(7 downto 0);
		  state	 								: IN STD_logic_vector(1 downto 0);
		  next_speed							: IN STD_logic;
		  pipe_on_signal, increment_score, start_next_level : OUT std_logic);
END singular_pipe;

ARCHITECTURE behaviour of singular_pipe is
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL pipe_x_motion			: std_logic_vector(9 DOWNTO 0);
SIGNAL random_number			: std_logic_vector(7 downto 0);
SIGNAL pipe_gap_pos			: std_logic_vector(9 downto 0);

begin


pipe_gap_pos <= CONV_STD_LOGIC_VECTOR(400,10);
size <= CONV_STD_LOGIC_VECTOR(20,10);

pipe_on_signal <= '0' when (('0' & pixel_row <= '0' & ((pipe_gap_pos - ("00" & random_number)) + 75)) and ('0' & pixel_row >= '0' & ((pipe_gap_pos - ("00" & random_number)) - 75))) else
				'1' when (('0' & pipe_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & pipe_x_pos + size)) 
				 else '0' ;

pipe_x_motion <= 	CONV_STD_LOGIC_VECTOR(0,10) when pause = '1' -- motion zero when paused
						else CONV_STD_LOGIC_VECTOR(2,10) when state = "00" -- speed 1 when level 1
						else CONV_STD_LOGIC_VECTOR(3,10) when state = "01" -- speed 2 when level 2
						else CONV_STD_LOGIC_VECTOR(20,10) when state = "10" -- speed 3 when level 3
						else null;

increment_score <= '1' when pipe_x_pos = (CONV_STD_LOGIC_VECTOR(0,10) + size) else '0';
start_next_level <= '1' when next_speed = '1' else '0';
								 		 
Generate_Pipe: process (clk, vert_sync)  
begin
	if (rising_edge(vert_sync)) then		
		if(pipe_x_pos < CONV_STD_LOGIC_VECTOR(0,10) + size) then
					random_number <= random_in;
					pipe_x_pos <= CONV_STD_LOGIC_VECTOR(660,11);
		else 
			pipe_x_pos <= pipe_x_pos - pipe_x_motion;
		end if;	
	end if;
	if(reset = '0' or next_speed = '1') then
			pipe_x_pos <= CONV_STD_LOGIC_VECTOR(460,11);
	end if;
end process Generate_Pipe;

END behaviour;