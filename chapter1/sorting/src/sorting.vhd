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

	procedure draw_only_pos_bars(arr : int_arr_t; nr : inout integer) is
		variable draw : vhdldraw_t;
		constant window_width : natural := 400;
		constant window_height : natural := 300;
		variable bar_width : natural := window_width / arr'length;
		variable bar_height : natural := 0;
    variable bar_x : natural := 0;
    variable bar_y : natural := window_height;
    constant offset : natural := 30;
    constant scaled_range : integer := window_height - (2*offset);
	begin
		draw.init(window_width, window_height);

		for i in arr'low to arr'high loop
      -- for debugging
			report "(" & to_string(i) & ") " & to_string(arr(i));
      report to_string(integer(real(arr(i))/real(arr(arr'high)) * real(scaled_range)));

      -- scale bar
      bar_height := integer(real(arr(i))/real(arr(arr'high)) * real(scaled_range)) + offset; 
      bar_y := window_height - bar_height;

      -- draw bar
      draw.setColor(Red);
      draw.fillRectangle(bar_x + bar_width*i, bar_y, bar_width, bar_height);
      draw.setLineWidth(1);
      draw.setColor(Black);
      draw.drawRectangle(bar_x + bar_width*i, bar_y, bar_width, bar_height);
    end loop;

    draw.show("sorted" & to_string(nr) & ".ppm");
    nr := nr + 1;
	end procedure;

	procedure draw_only_neg_bars(arr : int_arr_t; nr : inout integer) is
		variable draw : vhdldraw_t;
		constant window_width : natural := 400;
		constant window_height : natural := 300;
		variable bar_width : natural := window_width / arr'length;
		variable bar_height : natural := 0;
    variable bar_x : natural := 0;
    variable bar_y : natural := 0;
    constant offset : natural := 30;
    constant scaled_range : integer := window_height - (2*offset);
	begin
		draw.init(window_width, window_height);

		report to_string(arr(arr'low));

		for i in arr'low to arr'high loop
      -- for debugging
			report "(" & to_string(i) & ") " & to_string(arr(i));

      -- scale bar
      bar_height := abs(arr(i)) * 25;

      -- draw bar
      draw.setColor(Blue);
      draw.fillRectangle(bar_x + bar_width*i, bar_y, bar_width, bar_height);
      draw.setLineWidth(1);
      draw.setColor(Black);
      draw.drawRectangle(bar_x + bar_width*i, bar_y, bar_width, bar_height);
    end loop;

    draw.show("sorted" & to_string(nr) & ".ppm");
    nr := nr + 1;
	end procedure;


	procedure draw_array(arr : int_arr_t; nr : inout integer) is
		variable draw : vhdldraw_t;
		constant window_width : natural := 400;
		constant window_height : natural := 300;

		variable bar_width : natural := window_width / arr'length;
		variable bar_height : natural := 0;
    variable bar_x : natural := 0;
    variable bar_y : natural := window_height;

    constant offset : natural := 30;
    constant scaled_range : integer := window_height - (2*offset);
	begin
    --draw positive bars
    --draw_only_pos_bars(arr, nr);

    draw_only_neg_bars(arr, nr);

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
		variable sorted_arr_pos : int_arr_t(3 downto 0) := (5,4,3,2);
		variable sorted_arr_neg : int_arr_t(3 downto 0) := (-1,-2,-3,-4);
		variable sorted_arr_mixed : int_arr_t(-5 to 5) := (91,89,78,67,56,45,34,-12,-15,-23,-42);
    variable output_number : natural := 0;
	begin
    --test_cases;

    -- draw only positive bars
    -- draw_array(sorted_arr_pos, output_number);

    -- draw only negative bars
    draw_array(sorted_arr_neg, output_number);
		wait;
	end process;
end architecture;
