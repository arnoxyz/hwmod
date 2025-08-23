[Back](../../)
# Bin2Dec (Binary to Decimal)

# Split Task
## Make it easier by first constraining the input size and set a fixed input
Example:
- Set bin_in (Binary input) as "1101_1011"
Then the outputs should be:
- dec_out (Decimal output) as 219
- bcd_out (Binary Coded Decimal output) as 0010 0001 0101 = 219
### Working on DEC_OUT
#### What is Dec?
Decimal format of numbers. The number 10 as base is used because nobody for sure knows that, but so it is easy to mult and divide by 10 and we also got 10 fingers so thats some causes for 10 as base for the number system.
#### Calculating the output:
Just adding the values at each position. If '1' on position i then add 2^i. If '0' on position i then continue.
Then just output the value to the output dec_out.
### Working on BCD_OUT
#### What is BCD?
Every decimal digit can be represented as a 4 bit binary number.
(1)_10 as "0001", (2)_10 as "0010" and so on until (9)_10 as "0101" and then (10) = ? in hex this wuould just map to "0110" as x"A" but in this representation all numbers from 9 to 15 just get mapped to arbitrary values (the don't matter because you only get 0-9 as inputs because thats the input digits of a decimal number)
#### Calculate the output:
I wrote a function to decode a digit (0-9) into the binary value 1 returns "0001", 2 returns "0010" and so on. Now the only work was to get the digits of the integer. To get the digit just divide by 10 and mod 10 that number.
- (219 / 100) mod 10 = 2
- (219 / 10) mod 10 = 1
- (219 / 1) mod 10 = 9
