library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ProgCounter is
	port (
		Reset		:	in	std_logic;
		Clk 		:	in	std_logic;
		MaxCount	:	in	std_logic_vector(3 downto 0);
		Load		:	in	std_logic;
		Count 		:	out	std_logic_vector(3 downto 0):
		Zero		:	out	std_logic
	);
end entity; --ProgCounter

architecture synth of progcounter is

	signal max_value 		: std_logic_vector(3 downto 0);
	signal current_value 	: std_logic_vector(3 downto 0);

begin

	Zero <= current_value = 0;

	--Process handling reset and setting the maximum count
	load : process(Clk, Reset, MaxCount)
	begin
		if falling_edge(clk) then 
			if Reset = '1' then
				current_value <= (others => '0');
			elsif Load = '1' then
				max_value <= MaxCount;
			end if;
		end if;
	end process;

	--Process handling the counting
	counting : process(clk)
	begin 
		if falling_edge(clk) then 
			current_value <= current_value + 1;
		end if;
	end process;

end architecture ; -- synth