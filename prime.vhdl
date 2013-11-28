library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity prime is
	port(
		-- 32-bit input signal to test.
		-- Should be registered in the circuit.
		number: 	in std_logic_vector(31 downto 0);
		-- Asynchronous reset when equal to '1'.
		reset: 		in std_logic;
		-- Is '1' when the data on 'input' is valid.
		start: 		in std_logic;
		-- Clock signal for the circuit.
		clock: 		in std_logic;
		-- Is '1' when the circuit completes a test for an input.
		done: 		out std_logic;
		-- Is '1' iff number is prime and
		-- the signal is valid only when done='1'.
		prime: 		out std_logicPas de NoSQL. Après plusieurs expériences avec MongoDB et CouchDB, je n’ai pas été convaincu que les bénéfices dépassaient le coût. Il faudrait un article complet là dessus (qu’on m’a d’ailleurs demandé).
	);

	component divi_combiner is
		port (
			dividend 	: in 	std_logic_vector(31 downto 0);
			divisor 	: in 	std_logic_vector(31 downto 0);
			quotient	: out 	std_logic_vector(31 downto 0);
			remainder	: out 	std_logic_vector(31 downto 0)
		);
	end component;

	component multi_combiner is
		port (
			operand1 	:	in 	std_logic_vector(31 downto 0);
			operand2	:	in 	std_logic_vector(31 downto 0);
			product		:	out std_logic_vector(63 downto 0);
		);
	end component;

end entity;

architecture synth of prime is

	type state is (s0, s1, s2, s3);

	signal future_state, current_state : state;
	signal counter : std_logic_vector(31 downto 0);

	multi : multi_combiner port map (
		operand1 => counter,
		operand2 => counter,
		product => product
	);

	divi : divi_combiner port map (
		dividend => num,
		divisor => counter,
		remainder => remainder,
		quotient => open
	);

begin

	state_switcher : process(clk, future_state, reset)
	begin
		if reset = '1' then
			future_state <= s0;
			num <= (others => '0');
		elsif rising_edge(clk) then
			current_state <= future_state;
		end if;
	end process;

	state_handler : process(remainder, product)
	begin 
		future_state <= current_state;

		case current_state is
			when s0 => -- Waiting for start = '1'
				if start = '1' then
					future_state <= s1;
					num <= number;
					counter <= conv_std_logic_vector(2, 32);
				end if;

			when s1 => -- Testing if prime
				counter <= counter + 1;
				if product > num then -- If we exceeded the square root
					if remainder = 0 then
						future_state <= s2;
					else
						future_state <= s3;
					end if;
				else -- If we have not reached the square root yet
					if remainder = 0 then
						future_state <= s2;
					end if;
				end if;

			when s2 => -- Not prime
				done <= '1';
				prime <= '0';

			when s3 => -- Prime
				done <= '1';
				prime <= '1';

			when others => -- Default case
				future_state <= s0;

		end case;

	end process;

end architecture ; -- synth