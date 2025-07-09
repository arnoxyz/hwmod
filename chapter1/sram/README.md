# SRAM
Write a testbench for a provided SRAM.
## Exercise Details
The testbench should implement one read and one write cycle. To test the implementation write the sequence x"BADC0DEDC0DEBA5E" to the sram addresses 0 to 3. Then read them out using the read cycles. So it should:
### Write
The SRAM has 16 bit long data words so, 2 Byte meaning 4 hex values (x"1234")
```
write to address 0 the values x"BADC"
write to address 1 the values x"0DED"
write to address 2 the values x"C0DE"
write to address 3 the values x"BA5E"
```
### Read
```
read from address 0, the output should be -> x"BADC"
read from address 1, the output should be -> x"0DED"
read from address 2, the output should be -> x"C0DE"
read from address 3, the output should be -> x"BA5E"
```
## Implementation of the SRAM
Ports explained: The postfix `_N` means low active.
```
A     in addr_t     -- Address bus
CE_N  in std_ulogic -- Chip Enable (enable chip for reading/writing)
OE_N  in std_ulogic -- Output Enable (enable reading from the chip)
WE_N  in std_ulogic -- Write Enable (enable writting to the chip)
LB_N  in std_ulogic -- Lower Byte Enable (lower 8 bits D7-D0)
UB_N  in std_ulogic -- Upper Byte Enable (upper 8 bits D15-D8)
IO : inout word_t   -- Data Bus (reading/writing data)
```
Word Datatype as defined in the provided package. Is a 16 Bit Logic Vector.
```
subtype word_t is std_logic_vector(15 downto 0);
```
## Testbench
Testing the read and write cycles from the sram.
### Reading from the SRAM
Get data from the sram.
#### Read Cycle 1
#### Read Cycle 2
### Writing to the SRAM
Write data into the sram.
#### Shortcuts Overview
Overview of the shortcuts for the write timing, (defined in the package)
```
-- Write Time Constraints (T=Time)
TWC   : time := 10 ns;  -- Write Cycle Time (total duration of one write cycle)
TSCE  : time := 8 ns;   -- Chip Enable Active Duration
TAW   : time := 8 ns;   -- (After Write) Address must be valid for this time
THA   : time := 0 ns;   -- (Hold After) Address must be valid after write
TSA   : time := 0 ns;   -- (Setup Address)
TPWB  : time := 8 ns;   -- (Write Pulse Width)
TPWE1 : time := 8 ns;   -- (Write Enalbe) Method 1
TPWE2 : time := 10 ns;  -- (Write Enalbe) Method 2 (longer hold)
TSD   : time := 6 ns;   -- (Setup Time Data) Data must be stable before WE
THD   : time := 0 ns;   -- (Hold Time Data) Data must be valid after WE
THZWE : time := 5 ns;   -- (output disable, To High-Z) Bus goes to high-Z after Write
TLZWE : time := 2 ns;   -- (output enalbe, To Low-Z) Output enabled after WE
```
With the time values above and the [datasheet](https://www.issi.com/WW/pdf/61WV102416ALL.pdf) the testbench can now be written using:
```
statements
wait for [TIME];
```
#### Write Cycle 1
CE Controlled. So the CE signal is the primary used signal to controll this write cycle.
The OE signal can be high or low. (Does not matter). Goal is to set all signals according to the datasheet.
This means setting all these values:
```
Datasheet Name <-> Testbench Name
    ADDRESS    <-> A
    CE         <-> CE_N
    WE         <-> WE_N
    D_Out      <-> IO
    D_In       <-> IO
```
So the statements in the Testbench look like this:
```
A <=
CE_N <=
WE_N <=
IO <=
wait for [TIME];
```

#### Write Cycle 2
#### Write Cycle 3
