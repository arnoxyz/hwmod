library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.barcode_pkg.all;
use work.vhdldraw_pkg.all;

entity barcode is
end entity;

architecture arch of barcode is
	-- Config:
	constant ACTIVE_CODE : code128_t := CODE_A; -- Select the code that will be generated:
	constant input_str: string := "AB"; 


	-- Stuff I care later about: (make the drawing look nice)
	-- TODO: adjust drawing window size: Initialize drawing window (having width / 10 as top and bottom margin looks nice,  / 10 works as bar height)
	-- TODO: adjust windows_width -> determine based on input string, 400 ist just a placeholder
	-- TODO: adjust windows_height -> Calculate based on window width

	-- barcode stuff
	signal barcode_data : barcode_t(1 to input_str'length); -- 2 barcode symbols AB
begin
	barcode_maker : process

		-- basic drawing stuff init
		variable vhdldraw : vhdldraw_t;
		variable y_pos : natural;
		variable x_pos : natural; 
		-- draw Window
		variable window_width  : natural := 400; 
		variable window_height : natural := 400;          
		constant bar_width : natural := 2; -- defined in wiki (modulo)
		variable bar_height : natural := window_height;           

		-- fill barcode_data with specific data from input_str
		procedure fill_barcode_data is
		begin 
			for i in input_str'range loop
				barcode_data(i) <= code128_table(character'pos(input_str(i)));
			end loop;
			wait for 1 ns;
		end procedure;

		-- widths of different bar-zones:
		constant start_symbol : natural 	:= 11 * bar_width; 
		constant symbol_width : natural 	:= 11 * bar_width; 
		constant quiet_zone   : natural 	:= 15 * bar_width;  
		constant check_width  : natural 	:= 11 * bar_width;
		constant stop_width   : natural 	:= 15 * bar_width; 

		-- input a barcode like 11010000100 and draws it accordingly
		procedure draw_symbol(code : std_ulogic_vector(10 downto 0)) is
		begin 
			report(to_string(code));
			-- vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
			-- draw_stats(x_pos,y_pos,quiet_zone,bar_height);
		end procedure;

		-- for debugging
		procedure draw_stats(x : natural; y : natural; w : natural; h: natural) is
		begin 
			report("Draw stats:  " & 
				"x=" & to_string(x_pos) & " " & 
				"y=" & to_string(y_pos) & " " & 
				"width="  & to_string(quiet_zone) & " " & 
				"height=" & to_string(bar_height));
		end procedure;

	begin
		vhdldraw.init(window_width, window_height); 
		vhdldraw.setColor(Black);


		--(from Wikipedia)
		--A Code 128 barcode has seven sections:
			--Quiet zone
			vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
			draw_stats(x_pos,y_pos,quiet_zone,bar_height);

			--Start symbol

			--Encoded data 
			fill_barcode_data;
			for i in barcode_data'range loop
				draw_symbol(barcode_data(i));
			end loop;

			--Check symbol (mandatory) 
				--TODO:-> Check digit calculation, 11 Modules per Symbol so check (SumSymbols) % 11 == 0

			--Stop symbol
			--Final bar (often considered part of the stop symbol)
			--Quiet zone

		vhdldraw.show(input_str & "_barcode.ppm"); -- Show the resulting barcode image
		wait;  
	end process;
end architecture;
