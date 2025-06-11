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
	-- Split Task: 
	-- 1.) encode input and save it in an array 
	-- 2.) draw barcode from that array
begin
	barcode_maker : process
		----------------------------------CONFIG----------------------------------------------
		constant ACTIVE_CODE : code128_t := CODE_A; -- Select the code that will be generated:
		constant input_str: string := "ab"; 
		----------------------------------GEN-CODE----------------------------------------------
		variable barcode_data : barcode_t(1 to input_str'length) := (others=>(others=>'1')); 
		-- Codes
		variable start_code : std_ulogic_vector(BARCODE_BITS - 1 downto 0);
		variable stop_code : std_ulogic_vector(BARCODE_BITS - 1 downto 0) := code128_table(106);
		-- fill barcode_data with specific data from input_str
		procedure fill_barcode_data is
		begin 
			--Select the code that will be generated:
			case ACTIVE_CODE is 
				when CODE_A =>
					report "Gen Code_A";
					--TODO: handle wrong inputs
					for i in input_str'range loop
						--Direct Mapping of ASCII 0-95";
						barcode_data(i) := code128_table(character'pos(input_str(i)));
					end loop;
				when CODE_B =>
					report "Gen Code_B";
					--TODO: handle wrong inputs
					for i in input_str'range loop
						--Shift ASCII Code: -32 for Mapping
						barcode_data(i) := code128_table(character'pos(input_str(i))-32);
					end loop;
			end case;
		end procedure;
		procedure fill_barcode is 
		begin 
			--Quiet zone

			--Draw start code
			--Start symbol
			case ACTIVE_CODE is 
				when CODE_A =>
					start_code := code128_table(103);
				when CODE_B =>
					start_code := code128_table(104);
				--when CODE_C =>
					--start_code := code128_table(105);
			end case;
			--Encoded data 
			fill_barcode_data;
		end procedure;
		----------------------------------DRAWING----------------------------------------------
		-- Stuff I care later about: (make the drawing look nice)
		-- TODO: adjust drawing window size: Initialize drawing window (having width / 10 as top and bottom margin looks nice,  / 10 works as bar height)
		-- TODO: adjust windows_width -> determine based on input string, 400 ist just a placeholder
		-- TODO: adjust windows_height -> Calculate based on window width
		-- basic drawing stuff init
		variable vhdldraw : vhdldraw_t;
		variable y_pos : natural := 0;
		variable x_pos : natural := 0; 
		-- draw Window
		variable window_width  : natural := 400; 
		variable window_height : natural := 400;          
		constant bar_width : natural := 2; -- defined in wiki (modulo)
		variable bar_height : natural := window_height;           
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
			vhdldraw.init(window_width, window_height); 
			vhdldraw.setColor(Black);
			--TODO: draw Quiet zone
				--vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
				--draw_stats(x_pos,y_pos,quiet_zone,bar_height);
			--TODO: draw start code
			--TODO: draw encoded data
			--for i in barcode_data'range loop
				--draw_symbol(barcode_data(i));
			--end loop;
			--TODO: draw Stop symbol (use stop code)
			--TODO: draw quiet zone 
		vhdldraw.show(input_str & "_barcode.ppm"); -- Show the resulting barcode image
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

	--TODO: 1.) gen code 
	--TODO: 2.) draw barcode
		wait;  
	end process;
end architecture;
