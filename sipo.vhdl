library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SIPO is
	port (
		Reset 	:	in 		std_logic;
		Start 	:	in 		std_logic;
		DataIn 	:	in 		std_logic;
		DataOut	:	out 	std_logic(7 downto 0)
		Valid	:	out 	std_logic
	);
end SIPO;

architecture synth of sipo is

	signal content 	:	std_logic_vector(7 downto 0);
	signal counter	:	std_logic(2 downto 0);
	signal counting :	std_logic;

begin

	-- This signal is at 1 when we are receiving bits
	counting <= Start or not(counter = "000");

	-- This signal is at 1 when we finished receiving bits
	Valid <= counter = "000" and not Start;

	--	This contains the final parralel out when it is available 
	-- 	otherwise it is zeros
	DataOut <= content when counter = "000"
				else (others => '0');

	-- This process does the counting
	count : process(clk)
	begin
		if rising_edge(clk) then
			if counting = '1' then
				counter <= counter + 1;
			end if;
		end if;
	end process;

	-- This process puts the data in the correct place
	fetch : process(clk, counting)
	begin
		if rising_edge(clk) then
			if counting = '1' then
				content <= DataIn & content(6 downto 0);
			end if;
		end if;
	end process;

end architecture ; -- synth