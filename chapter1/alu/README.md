[Back](../../)
# Implement and Simu an ALU (Arithmetic-Logic-Unit)
ALU is part of a processor unit and does arithmetical operations like add, sub of vectors/numbers and also logical operations like and, or, xor of vectors/numbers.


## Entity/Interface of the Unit:
### Inputs:
- op  = operation, what operation should be executed by the alu, example: alu_add = adds a+b
- a,b = input numbers, represented as std_ulogic_vectors, example: a="0001", b="0010"
### Outputs:
- r   = result of the operation, example: r = a+b
- z   = flag, extra information of the result, example: '1' if A=B and '0' if A!=B
### Generic:
- DATA_WIDTH = Width of the vectors/numbers a,b,r (the input and output length is always the same)
### Example:
- DATA_WIDTH = 4
- op = ALU_ADD
- a  = "0000"
- b  = "0001"
Result should then be:
- r  = "0001" (result of a+b)
- z  = "-" (don't care = meaning the output value is of no intrest, when op=ALU_ADD)

## Operations to implement
The operations of the ALU are defined in the following table:

|op       | R                       | Z          | Meaning |
|---------|-------------------------|------------|---------|
|ALU_NOP  | B                       | don't care | do nothing|
|ALU_SLT  | A < B ? 1 : 0, signed   | not R(0)   | Set Less Than, interpret inputs as signed values|
|ALU_SLTU | A < B ? 1 : 0, unsigned | not R(0)   | Set Less Than interpret inputs as unsigned values|
|ALU_SLL  | A sll B(x downto 0)     | don't care | Shift Left Logical, mult by 2, adds 0 to the right side of the vector|
|ALU_SRL  | A srl B(x downto 0)     | don't care | Shift Right Logical,  divide by 2, adds 0 to the left side of the vector|
|ALU_SRA  | A sra B(x downto 0)     | don't care | Shift Right Arithemtical, divide by 2, but preserves the sign bit (if the number is negative adds 1 to the left side, if its positive adds 0 to the left side) |
|ALU_ADD  | A + B, signed           | don't care | Adds the numbers, interpret inputs as signed values|
|ALU_SUB  | A - B, signed           | A = B      | Subs the numbers, interpret inputs as signed values
|ALU_AND  | A and B                 | don't care | Logical AND operation |
|ALU_OR   | A or B                  | don't care | Logical OR operation |
|ALU_XOR  | A xor B                 | don't care | Logical XOR operation |



## Shift Operation in Detail:
- A sll B(x downto 0)
- Meaning "Shift Logic Left" the input A by the value saved in B from (x downto 0).
### Derive the value x:
- constant x : integer := log2c(DATA_WIDTH);
#### Example: DATA_WIDTH = 4
- get how many bits you need to represent that number: log2c(4) = 2, because 2^4 = 4
- A sll B(x=4 downto 0) so A sll B(4 dowto 0), but then there would be 5 so -1 to x
#### Final Result:
- A sll B(4-1 downto 0)
- A sll B(x-1 downto 0)
### Little fun with Conversions (STD_ULOGIC, SIGNED/UNSIGNED, INTEGER):
- Output r is a std_ulogic_vector
- r <= std_ulogic_vector(---)
- To performe shift operation there can be used the shift_left(vector as signed/unsigned, length as integer) function
- shift by 2, shift_left("0001", 2), result is "0100"
- r <= std_ulogic_vector(shift_left(---))
- shift_left(---) = shift_left(unsigned(a), to_integer(unsigned(b(x-1 downto 0))))
### Complete Result:
- r <= std_ulogic_vector(shift_left(unsigned(a), to_integer(unsigned(b(x-1 downto 0)))))
