LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity state_control is
	port(clk, b2, b1, b0, game_over: IN STD_LOGIC;			
			state : OUT STD_LOGIC_VECTOR(1 downto 0));
end entity state_control;

architecture a of state_control is
-- FSM signals
type state_type is (s_menu, s_regular, s_training, s_over);
signal state_s, next_state : state_type := s_menu;

begin
	--synchronously move to next state
	sync_proc : process(clk, b2) 
	begin
		if (b2 = '0') then
			state_s <= s_menu;
		elsif (rising_edge(clk)) then
			state_s <= next_state;
		end if;
	end process;
	
	--asynchronously decide next state based only on current state and inputs
	next_states_fn: process(state_s, b1, b2, b0, game_over) 
	begin
		case(state_s) is
			when s_menu =>
				if (b0 = '0') then 					
					next_state <= s_training;
				elsif (b1 = '0') then				
					next_state <= s_regular;
				else 									
					next_state <= s_menu;
				end if;
				
			when s_training =>
				if (game_over = '1') then 
					next_state <= s_over;
				elsif (b2 = '0') then 
					next_state <= s_menu;	
				else
					next_state <= s_training;
				end if;
				
			when s_regular =>
				if (game_over = '1') then 
					next_state <= s_over;
				elsif (b2 = '0') then 
					next_state <= s_menu;
				else
					next_state <= s_regular;
				end if;
				
			when s_over =>
				if (b2 = '0') then
					next_state <= s_menu;
				else 
					next_state <= s_over;
				end if;
				
		end case;
	end process;
	
	outputs:process(state_s)
		begin
			case state_s is
				when s_menu =>
					state <= "00";
				when s_training =>
					state <= "10";
				when s_regular =>
					state <= "01";
				when s_over =>
					state <= "11";
			end case;
		end process;
end a;