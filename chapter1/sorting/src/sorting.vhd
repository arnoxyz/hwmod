library ieee;
use ieee.math_real.all;

use work.vhdldraw_pkg.all;
use work.math_pkg.all;

entity sorting is
end entity;

architecture arch of sorting is
	type int_arr_t is array(integer range<>) of integer;

	procedure print_array(int_arr : int_arr_t) is
	begin
		report "Printing Array";
		for i in int_arr'high downto int_arr'low loop
			--report "int_arr(" & to_string(i) & ") = " & to_string(int_arr(i));
			report "(" & to_string(i) & ") " & to_string(int_arr(i));
		end loop;
		report "--------";
	end procedure;

  procedure swap(data : inout int_arr_t; i : integer; j : integer) is
    variable tmp : integer;
  begin
    tmp := data(i);
    data(i) := data(j);
    data(j) := tmp;
  end procedure;

  procedure partition(data : inout int_arr_t; low : in integer; high : in integer; pivot : out integer) is
    variable i, j  : integer;
  begin
    pivot := data(high);
    i := low - 1;

    for j in low to high - 1 loop
        if data(j) <= pivot then
            i := i + 1;
            swap(data, i, j);
        end if;
    end loop;

    swap(data, i + 1, high);
    pivot := i + 1;
  end procedure;

  procedure quicksort_helper(data : inout int_arr_t; left : integer; right : integer) is
    variable pivot : integer;
  begin 
    -- for testing
    --swap(data, 1, 0);
    --partition(data, 1, 0, pivot);

    -- recursive quicksort
    if left < right then
        partition(data, left, right, pivot);
        quicksort_helper(data, left, pivot - 1);
        quicksort_helper(data, pivot + 1, right);
    end if;
  end procedure;

	procedure quicksort(data : inout int_arr_t) is
	begin
    quicksort_helper(data, data'low, data'high);
	end procedure;

	procedure sort(data : inout int_arr_t) is
	begin
		quicksort(data);
		-- mergesort(data);
	end procedure;

  procedure draw_array(arr : int_arr_t; nr : inout integer) is
		variable draw : vhdldraw_t;
		constant window_width : natural := 400;
		constant window_height : natural := 300;

		variable bar_width : natural := window_width / arr'length;
		variable bar_height : integer := 0;
    variable bar_x : integer := 0;
    variable bar_y : integer  := 0;

    constant high_val : integer := arr(arr'high);
    constant low_val : integer := arr(arr'low);
    constant val_range : integer := high_val - low_val;
    constant zero_line : integer := integer((real(high_val) / real(val_range)) * real(window_height));
    constant offset : integer := 15;
	begin
		draw.init(window_width, window_height);


		for i in arr'low to arr'high loop
        bar_x := integer(bar_width) * (i - arr'low);

        -- scale bar
        bar_height := integer((real((real(abs(arr(i))) / real(val_range)) * real(window_height - 2*offset))) + real(offset));

        if arr(i) >= 0 then
            bar_y := zero_line - bar_height;
            draw.setColor(Red);
        else
            bar_y := zero_line;
            draw.setColor(Blue);
        end if;

        -- draw bar
        draw.fillRectangle(bar_x, bar_y, bar_width, bar_height);
        draw.setLineWidth(1);
        draw.setColor(Black);
        draw.drawRectangle(bar_x, bar_y, bar_width, bar_height);
   end loop;

    draw.show("sorted" & to_string(nr) & ".ppm");
    nr := nr + 1;
	end procedure;

  procedure test_cases is
		variable arr0 : int_arr_t(-10 downto -19) := (10, 9, 8, 7, 6, 5, 4, 3, 2, 1);
		variable arr1 : int_arr_t(-5 to 5) := (-12, 45, 78, -23, 56, 89, 34, 67, 91, -15, -42);
		variable arr2 : int_arr_t(5 downto 0) := (-10, -11, -12, -13, -17, -22);
    variable output_number : natural := 0; -- for naming exported drawing files
  begin
		sort(arr0);
		print_array(arr0);
		draw_array(arr0, output_number);

		sort(arr1);
		print_array(arr1);
		draw_array(arr1, output_number);

		sort(arr2);
		print_array(arr2);
		draw_array(arr2, output_number);
  end procedure;

begin

	main : process is
	begin
    test_cases;
		wait;
	end process;
end architecture;
