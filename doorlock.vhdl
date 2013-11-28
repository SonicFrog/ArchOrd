library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity doorlock is
	port (
		keyon 		:	in	std_logic;
		keycode		:	in	std_logic(2 downto 0);
		reset		:	in	std_logic;
		clk			:	in	std_logic;
		opendoor	:	out	std_logic
	);
end entity; --doorlock

architecture synth of doorlock is
	
	type	state is (s0, s1, s2);
	signal 	current_state, future_state : state;

	signal code	:	std_logic_vector(11 downto 0);

begin

	shift : process(clk, shift_left, shift_right)
	begin
		if rising_edge(clk) then
			if shift_left = '1' then
				code <= code(11 downto 3) & keycode;
			elsif shift_right = '1' then
				code <= "000" & code(8 downto 0);
			end if;
		end if;
	end process;

	sync : process(clk)
	begin
		if reset = '1' then
			current_state <= s0;
		elsif rising_edge(clk) then
			current_state <= future_state;
		end if;
	end process;

	handle_state : process(current_state, keyon, keycode)
	begin
		future_state <= current_state;
		opendoor <= '0';

		case current_state is
			when s0 =>
				if keyon = '1' then
					future_state <= s1;
					if keycode = "111" then
						shift_right <= '1';
					else
						shift_left <= '1';
					end if;
				end if;


			when s1 => 
				if code = "011110010101" then 	-- code is 3625
					future_state <= s2;
				else 							-- code is fake
					future_state <= s0;
				end if;


			when s2 =>
				opendoor <= '1';
				future_state <= s0;

			when others =>
				future_state <= s0;

		end case;
	end process;

end architecture ; -- synth