📌 Overview

This repo implements a parameterized bit-counter (popcount) module in SystemVerilog. Given an input vector din of width DATA_WIDTH, the module outputs the number of bits set to 1 on dout.

💡 Approach
My Implementation

The implementation directly adds each input bit to dout:

systemverilog
dout = 0;
for (i = 0; i < DATA_WIDTH; i = i + 1) begin
    dout = dout + din[i];
end

Since every din[i] is either 0 or 1, each 1 automatically increases the count — no explicit comparison is needed.

Reference Implementation

The reference uses a temporary counter and explicitly checks each bit:

systemverilog
if (din[i] == 1'b1)
    temp_dout = temp_dout + 1;
else
    temp_dout = temp_dout + 0;

dout = temp_dout;
⚖️ Comparison
Feature	My Implementation	Reference Implementation
Counting method	Direct addition	if / else check
Temporary variable	Not required	temp_dout required
Code length	Shorter	Longer
Readability	Simple and concise	More explicit
Area	422.91 µm²	539.27 µm²
Max Frequency	434.8 MHz	326.8 MHz
Critical Path	2.300 ns	3.060 ns
📊 Result

My implementation performs better in the synthesis results shown above:

✅ Lower area: 422.91 µm² vs 539.27 µm²
✅ Higher frequency: 434.8 MHz vs 326.8 MHz
✅ Shorter critical path: 2.300 ns vs 3.060 ns

The main advantage is that the direct addition approach avoids the unnecessary explicit if/else logic and temporary assignment, resulting in simpler synthesized logic.

🛠️ Key Takeaway

Both implementations correctly count the number of 1s in the input. The direct accumulation approach is simpler and, in these results, more efficient in both area and performance.
