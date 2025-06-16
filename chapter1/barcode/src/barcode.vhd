library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_pkg.all;
use work.barcode_pkg.all;
use work.vhdldraw_pkg.all;

entity barcode is
end entity;

-- Split Task: 
-- 1.) encode input and save it in an array 
-- 2.) draw barcode from that array
architecture arch of barcode is
	----------------------------------CONFIG----------------------------------------------
	constant ACTIVE_CODE : code128_t := CODE_A; -- Select the code that will be generated:
	constant input_str: string := "HW-MOD 2024"; 
	--here signals for debuging (make sim_gui)
	signal barcode : barcode_t(1 to input_str'length+3) := (others=>(Others=>'1'));
begin
	barcode_maker : process
		----------------------------------GEN-CODE----------------------------------------------
		constant start_code_A_value : integer := 103;
		constant start_code_B_value : integer := 104;
		variable check_symbol_value : integer := 0;
		constant stop_value : integer := 106;
		variable start_code : std_ulogic_vector(BARCODE_BITS - 1 downto 0);
		variable stop_code : std_ulogic_vector(BARCODE_BITS - 1 downto 0) := code128_table(stop_value);
		procedure fill_barcode is 
		begin 
			case ACTIVE_CODE is 
				when CODE_A =>
					start_code := code128_table(103);
				when CODE_B =>
					start_code := code128_table(104);
			end case;

			-- BARCODE [START-SYMBOL [DATA] STOP-SYMBOL]
			barcode(1) <= start_code;
			case ACTIVE_CODE is 
				when CODE_A =>
					report "Gen Code_A"; --Direct Mapping of ASCII 0-95";
					for i in input_str'range loop
						barcode(i+1) <= code128_table(character'pos(input_str(i)));
					end loop;
				when CODE_B =>
					report "Gen Code_B"; --Shift ASCII Code: -32 for Mapping
					for i in input_str'range loop
						barcode(i+1) <= code128_table(character'pos(input_str(i))-32);
					end loop;
			end case;
			barcode(input_str'length+2) <= code128_table(check_symbol_value);
			barcode(input_str'length+3) <= stop_code;
			wait for 1 ns;
		end procedure;


		procedure calc_checksum is 
			variable sym_sum : integer;
		begin 
			case ACTIVE_CODE is 
				when CODE_A =>
					sym_sum := start_code_A_value + stop_value;
					for i in input_str'range loop
						sym_sum := sym_sum + character'pos(input_str(i));
					end loop;
				when CODE_B =>
					sym_sum := start_code_B_value + stop_value;
					for i in input_str'range loop
						sym_sum := sym_sum + character'pos(input_str(i))-32;
					end loop;
			end case;
			check_symbol_value := sym_sum mod 103;
		end procedure;
		----------------------------------DRAWING----------------------------------------------
		-- Stuff I care later about: (make the drawing look nice)
		constant bar_width : natural := 2; -- defined in wiki (modulo)
		-- widths of different bar-zones:
		constant start_symbol : natural 	:= 11 * bar_width; 
		constant symbol_width : natural 	:= 11 * bar_width; 
		constant quiet_zone   : natural 	:= 15 * bar_width;  
		constant check_width  : natural 	:= 11 * bar_width;
		constant stop_width   : natural 	:= 15 * bar_width; 
		-- draw Window
		variable window_width  : natural := input_str'length*symbol_width+2*quiet_zone;
		variable window_height : natural := window_width;          
		variable bar_height : natural := window_height-20; 
		-- 
		-- basic drawing stuff init
		variable vhdldraw : vhdldraw_t;
		variable y_pos : natural := 10;
		variable x_pos : natural := 0; 
		-- input a barcode like 11010000100 and draws it accordingly
		procedure draw_symbol(code : std_ulogic_vector(10 downto 0)) is
		begin 
			-- report(to_string(code));
			--To draw the barcode: map values in the vector (1s to black bars, 0s to white bars)
			for i in code'range loop
				if code(i) = '1' then 
					vhdldraw.setColor(Black);
				else 
					vhdldraw.setColor(White);
				end if;
				vhdldraw.fillRectangle(x_pos, y_pos, bar_width, bar_height);
				x_pos := x_pos+1;
			end loop;

		end procedure;

		-- iterate through barcode array and draw every symbol (code that is saved in that array)
		procedure draw_barcode is 
		begin 
			vhdldraw.init(window_width, window_height); 

			--draw Quiet zone
			vhdldraw.setColor(White);
			vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
			x_pos := x_pos+quiet_zone;

			--draw barcode (includes start, stop code)
			for i in barcode'range loop
				draw_symbol(barcode(i));
			end loop;

			--draw Quiet zone 
			vhdldraw.setColor(White);
			vhdldraw.fillRectangle(x_pos, y_pos, quiet_zone, bar_height);
			x_pos := x_pos+quiet_zone;

			vhdldraw.show(input_str & "_barcode.ppm"); -- Show the resulting barcode image
		end procedure;

		-- whole barcode generating 
		procedure gen_barcode is 
		begin 
			-- the checksum
			calc_checksum;
			-- gen code 
			fill_barcode;
			-- draw barcode
			draw_barcode;
		end procedure;

	begin

		gen_barcode;
		wait;  
	end process;
end architecture;
