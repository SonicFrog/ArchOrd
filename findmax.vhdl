library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity maxfinder is
	port (
		startaddr 	:	in	std_logic_vector(15 downto 0);
		len			:	in	std_logic_vector(15 downto 0);
		start 		:	in	std_logic;
		reset_n		:	in 	std_logic;
		clk 		:	in	std_logic;
		rddata		:	in	std_logic_vector(7 downto 0);
		rdaddr		:	out	std_logic_vector(15 downto 0);
		max 		:	out std_logic_vector(255 downto 0);
		done		:	out	std_logic
	);
end maxfinder;

architecture synth of findmax is

	type state is (S, R, C);

	signal current_state, future_state : state;
	signal shift_reg	:	std_logic_vector(255 downto 0);

	signal current_max, future_max	:	std_logic_vector(255 downto 0);
	signal address, future_address	:	std_logic_vector(15 downto 0);
	signal current_len, future_len	:	std_logic_vector(15 downto 0);

begin

	rdaddr <= address;

	max <= current_max;

	sync_state : process(clk) 
	begin
		if reset_n = '0' then
			current_state <= S;
			shift_reg <= (others => '0');
			current_max <= (others => '0');
			address <= (others => '0');
		elsif rising_edge(clk) then
			current_state <= future_state;
			current_max <= future_max;
			current_len <= future_len;
			address <= future_address;
			current_max <= future_max;
		end if;
	end process;

	state_proc : process(rddata, len_left)
	begin

		future_state <= current_state;
		future_address <= address;
		future_len <= current_len;
		future_address <= address;
		future_max <= current_max
		done <= '0';


		case current_state is
			when S => -- Waiting for start
				if start = '1' then
					future_state <= R;
					address <= startaddr;
					len_left <= len;
				end if;

			when R => -- Reading the number from memory
				shift_reg <= shift_reg(247 downto 8) & rddata(7 downto 0);
				if rddata(7) = '1' then
					future_state <= C;
				else
					future_address <= address + 1;
					future_len <= len_left - 1;
				end if;

			when C => -- Done reading doing the comparison
				if current_max < shift_reg then
					future_max <= shift_reg;
				end if;

				if current_len = 0 then
					future_state <= E;
				else
					future_state <= R;
				end if;

			when E => -- Read up until staddr + len
				done <= '1';
				future_state <= S;

			when others => 
				future_state <= S

		end case;

	end process;


end architecture ; -- synth