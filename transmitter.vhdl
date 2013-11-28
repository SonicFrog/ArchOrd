library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity transmitter is
	port (
		start 	:	in 	std_logic;
		memdata	:	in	std_logic_vector(7 downto 0);
		memaddr :	in	std_logic_vector(7 downto 0);
		acknum	:	in	std_logic_vector(7 downto 0);
		clk		:	in	std_logic;
		reset	:	in	std_logic;
		num		:	out	std_logic_vector(7 downto 0);
		data	:	out	std_logic_vector(7 downto 0);
		valid	:	out	std_logic
	);
end transmitter;

architecture synth of transmitter is

	signal countNotZero		:	std_logic;
	signal wordcount 		: 	std_logic_vector(7 downto 0);
	signal next_wordcount	:	std_logic_vector(7 downto 0);
	signal enable			:	std_logic;
	signal lastack			:	std_logic_vector(7 downto 0);

begin

	enable <= start or countNotZero;
	
	countNotZero <= '0' when wordcount = 0 else '1';

	num <= wordcount;
	memaddr <= wordcount;


	-- This processh handles changing the state synchronously
	switch : process(clk, next_wordcount)
	begin
		if reset = '1' then
			wordcount <= (others => '0');
		elsif rising_edge(clk) then
			wordcount <= next_wordcount;
		end if;
	end process;

	-- This process handles the changing of the address of the word
	count : process(clk, lastack, enable)
	begin
		next_wordcount <= wordcount;
		if lastack + 4 = wordcount then
			wordcount <= lastack + 1;
		elsif enable = '1' then
			next_wordcount <= wordcount + 1;
		end if;
	end process;

	-- This process does stuff related to the ACK
	ack : process(clk, acknum, ack)
	begin
		if reset = '1' then
			lastack <= (others => '0');
		elsif rising_edge(clk) then
			if ack = '1' then
				lastack <= acknum;
			end if;
		end if;
	end process;


end architecture ; -- synth