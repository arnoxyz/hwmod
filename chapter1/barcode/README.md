# Barcode
Gets a string as input like "Hello" and outputs a barcode, representing that information.

# Split Task
Config the input string. For example: "TEST"
## Gen Barcode
The whole barcode is saved as an array of 11 bit wide std logic vectors. The format of the barcode is QUIET AREA [START-SYMBOL [STRING-SYMBOLES] CHECKSUM-SYMBOL END-SYMBOL]. The vectors are saved in the helper pkg and can be easily obtained by just using the ASCII code of the individual character. For example: 'A' is equal to the 33 integer. So in the helper mapping the code representing that character can just be obtained with: code128_table(33).
The Start- and Endsymbol also got a predefined number: start code for A 103, Start Code for B 104 and Stop Code 106 so same with the characters to obtain the code: code128_table(103), code128_table(104), code128_table(106)  
## Checksum Symbol
The checksum must be calculated by just summing up all the symbols and start/endcode values. Then this sum modulo 103 yields the check symbol number. This can now just be added to the barcode with the old code128_table(Check_Symbol_Value) trick. 
## Why checksum? 
By calculating this check symbol and adding the number, you can easily check the barcode for errors. If you get a barcode just summ up all the values and mod the result with 103. If the solution is not 0 something went wrong. 
## Draw/Display Barcode
Now the whole barcode is saved and decoded in an array with each symbol represented as 11 bit wide std logic vector with values '0' and '1'. Drawing is now easy by just drawing black bars when '1' and white bars when '0' is in the respected vector position. The width of each bar is set to 2. So each symbol got a width of 2 (bar width)  times 11 (bit vector). The quite zone before and after the bar can be set to 15 times 2 (bar widt) or any width big enough to gurantee that the barcode is not disrupted when scanned. 
