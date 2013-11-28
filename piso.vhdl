library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PISO is
	port (
		Pattern		:	in 		std_logic_vector(7 downto 0);
		DataIn 		:	in 		std_logic;
		Load		:	in 		std_logic;
		Reset		:	in 		std_logic;
		Clk 		:	in 		std_logic;
		Found 		: 	out 	std_logic
	);
end entity; --PISO

architecture synth of piso is

	signal content 		:	std_logic_vector(7 downto 0);
	signal reg_pattern	:	std_logic_vector(7 downto 0);

begin

	load : process(Clk, Load, DataIn)
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				reg_pattern <= (others => '0')
			elsif Load = '1' then
				reg_pattern <= Pattern;
			end if;
		end if;
	end process;

	input_handle : process(Clk, Pattern)
	begin
		if rising_edge(Clk) then
			content <= content(7 downto 1) & DataIn;
		end if;
	end process;

	Found <= '1' when content = reg_pattern else '0';

end architecture ; -- synth