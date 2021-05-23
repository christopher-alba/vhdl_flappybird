LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( clk, vert_sync, left_click, pause, reset	: IN std_logic;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  state : IN STD_LOGIC_VECTOR(1 downto 0);
		  bird_on_signal: OUT std_logic);
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0) := "0011001000";
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL mouse_state 			: STD_logic;
SIGNAL gravity 				: std_logic_vector(9 downto 0);
BEGIN  
         
gravity <= CONV_STD_LOGIC_VECTOR(3,10) when pause = '0' else CONV_STD_LOGIC_VECTOR(0,10);
size <= CONV_STD_LOGIC_VECTOR(8,10);
ball_x_pos <= CONV_STD_LOGIC_VECTOR(50,11);

bird_on_signal <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) and (state = "01" or state = "10"))  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';

Move_Ball: process (clk, vert_sync)	
begin
	if(reset = '0') then
		ball_y_pos <= "0011001000";
	elsif (rising_edge(vert_sync)) then	
			if (left_click = '1' and mouse_state = '0' and pause = '0') then
				if ('0' & ball_y_pos <= CONV_STD_LOGIC_VECTOR(78,10)) then
					ball_y_pos <= CONV_STD_LOGIC_VECTOR(0,10) + size;
				else 
					ball_y_pos <= ball_y_pos - 70;
				end if;
			elsif (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size)) then	
				null;
			else 
				ball_y_pos <= ball_y_pos +  gravity;
		end if;
		
		mouse_state <= left_click;
	end if;
	
end process Move_Ball;
END behavior;

