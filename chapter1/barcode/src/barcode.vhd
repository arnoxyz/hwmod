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
	-- Stuff I care later about: (make the drawing look nice)
	-- TODO: adjust drawing window size: Initialize drawing window (having width / 10 as top and bottom margin looks nice,  / 10 works as bar height)
	-- TODO: adjust windows_width -> determine based on input string, 400 ist just a placeholder
	-- TODO: adjust windows_height -> Calculate based on window width

begin
	barcode_maker : process
		-- basic drawing stuff init
		variable vhdldraw : vhdldraw_t;
		variable y_pos : natural;
		variable x_pos : natural; 

		-- draw Window
		variable window_width  : natural := 400; 
		variable window_height : natural := 400;          

		constant input_str: string := "A"; 
		constant bar_width : natural := 2; -- defined in wiki (modulo)
		variable bar_height : natural := window_height;           

		-- widths of different bar-zones:
		constant start_symbol : natural 	:= 11 * bar_width; 
		constant symbol_width : natural 	:= 11 * bar_width; 
		constant quiet_zone   : natural 	:= 15 * bar_width;  
		constant check_width  : natural 	:= 11 * bar_width;
		constant stop_width   : natural 	:= 15 * bar_width; 

		-- for debugging
		procedure draw_stats(x : natural; y : natural; w : natural; h: natural) is
		begin 
			report("Draw stats:  " & 
				"x=" & to_string(x_pos) & " " & 
				"y=" & to_string(y_pos) & " " & 
				"width="  & to_string(quiet_zone) & " " & 
				"height=" & to_string(bar_height));
		end procedure;

		-- TODO: draw bar 
			-- (bar-space, bar-space, bar-space)
			-- Example
			-- "11010000100",  -- 103 (Start Code A)
			-- vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);

	begin
		vhdldraw.init(window_width, window_height); 
		vhdldraw.setColor(Black);


		--(from Wikipedia)
		--A Code 128 barcode has seven sections:
			--Quiet zone
			vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
			draw_stats(x_pos,y_pos,quiet_zone,bar_height);

			--Start symbol
			-- TODO: add procedure that draws bars according to specification (3 bars width)

			--Encoded data 
			--Check symbol (mandatory) 
				--TODO:-> Check digit calculation, 11 Modules per Symbol so check (SumSymbols) % 11 == 0
			--Stop symbol
			--Final bar (often considered part of the stop symbol)
			--Quiet zone

		vhdldraw.show(input_str & "_barcode.ppm"); -- Show the resulting barcode image
		wait;  
	end process;
end architecture;
