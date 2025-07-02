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
		constant width : natural := 400;
		constant height : natural := 300;
		variable bar_width : natural := width / arr'length;
	begin
		draw.init(width, height);
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
		variable sorted_arr : int_arr_t(5 downto 0) := (5,4,3,2,1,0);
    variable output_number : natural := 0;
	begin
    --test_cases;

    -- draw only positive bars (for now)
    draw_array(sorted_arr, output_number);
		wait;
	end process;
end architecture;
