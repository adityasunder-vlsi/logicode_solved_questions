Divisibility by 3 — SystemVerilog
Problem
Design a sequential SystemVerilog circuit that reads a binary number one bit at a time and asserts dout when the value represented by the input stream is divisible by 3.

The design uses a clock and an active-low synchronous reset.
My Approach
I used a remainder-based approach. For every new input bit, the binary value represented so far updates as:
next_value = 2 × current_value + din
So the remainder modulo 3 can be updated directly:
assign next_rem = (2 * rem + din) % 3;
On each rising clock edge, rem stores the next remainder. The output is asserted when the updated remainder is zero:
dout <= (next_rem == 0);
This makes the logic concise and expresses the mathematical relationship directly in RTL.
Testing
The implementation passed the site's functional testbench.
Area and Performance
The results shown by the tool were:
- Area: 73.4% (as reported by the tool)
- Performance: 3.9% (as reported by the tool)
- Status: Passed
The reference implementation reports an area of 128.87 µm², a maximum frequency of 2127.7 MHz, and a critical path of 0.470 ns.

These figures are shown in different formats, so they do not establish an exact percentage improvement between the two implementations. A fair comparison requires absolute area and timing results measured under the same synthesis settings and constraints.
Result
This problem helped me practice converting a mathematical remainder update into sequential SystemVerilog RTL.

Although my arithmetic-based implementation is concise and passed the functional testbench, the reference FSM-based implementation may offer better timing. The % 3 operation can infer additional combinational logic, so shorter RTL does not necessarily produce faster hardware.
