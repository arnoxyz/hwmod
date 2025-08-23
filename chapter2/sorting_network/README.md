[Back](../../)
# Sorting Network
Sorting by using a pipeline like structure that compares two lines and swaps if the upper lines values is bigger than the lower line. Implemented using 4 lines and the structure [Sorting network for 4 inputs, 5 CEs, 3 layers](https://bertdobbelaere.github.io/sorting_networks.html), (4inputs=4lines, laysers=stages)
## Implementation and Simulation
Write boilerplate code for the tb (uut, basic stimulus, clk_gen) and sync process with just dummy values for the implementation. The split the line input into 4 lines using the generic DATA WIDTH.
![start](./img/start.png)
<br>
After that create stage1 and simulate the behavior.
<br>
![add stage 1](./img/stage1.png)
<br>
Then just add all stages and output the values from theline to the sorted output.
<br>
![add all stages ](./img/all_stages.png)
<br>
The last step was creating a counter to count the cc until the pipeline is done. Because the actual clk on the fpga board is real fast I use >=5 cc instead of the =5, makes the design less error prone.
<br>
![add counter for done signal](./img/counter.png)
<br>
After that the simulate can be easy done with the wait until done is equal to 1. So I simulated more data inputs.
<br>
![final simulation](./img/more_data_sim.png)
## Test on the fpga Board
After the simulation is done with no spottet bugs anymore, it is time to test my design on the fpga board. I checked the design with the rtl viewer to see if my assumptions are right. The inputs are sampled when the start signal is on.
![rtl viewer of inputs](./img/rtl_view1_sampling.png)
<br>
The outputs are visible and also the counter implementation using a register and an adder.
![rtl viewer of outputs](./img/rtl_view2_output.png)
<br>
After that just make qdownload_remote and testing on the fpga board using remote.py -i.
