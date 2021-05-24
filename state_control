LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity state_control is
	port(b2, b1, b0, game_over: IN STD_LOGIC;			
			state : OUT STD_LOGIC_VECTOR(1 downto 0));
end entity state_control;

architecture a of state_control is
begin
	process(b2, b1, b0, game_over)
	variable temp : STD_LOGIC_VECTOR(1 downto 0) := "00";
	begin -- 00 mainmenu 01 game 10 training 11 death screen		
		
		if (b0 = '0') then -- go to training mode
			temp := "10";
		elsif (b1 = '0') then -- start level 1
			temp := "01";
		elsif (b2 = '0') then -- main menu
			temp := "00";
		elsif (rising_edge(game_over)) then
			temp := "11";
		end if;
		
	state <= temp;
	end process;
end a;
