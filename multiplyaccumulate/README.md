# Pipelined Multiply-Accumulate (MAC) Unit

A parameterized **Pipelined Multiply-Accumulate (MAC) Unit** designed using SystemVerilog, implementing a two-stage architecture to perform multiplication and accumulation in separate clocked stages.

## 1. Overview

A Multiply-Accumulate (MAC) unit performs two operations:

1. Multiplication of two input operands.
2. Addition of the resulting product to a running accumulator.

The fundamental operation is:

\[
SUM_{new} = SUM_{old} + (A \times B)
\]

MAC units are widely used in Digital Signal Processing (DSP), FIR filters, dot-product calculations, and signal-processing architectures.

This project implements a pipelined MAC architecture that separates multiplication and accumulation into two stages, allowing a new input sample to be accepted every clock cycle.

## 2. Architecture

The design consists of two pipeline stages.

### Stage 1: Multiplication

- Accepts unsigned operands `A` and `B`.
- Performs multiplication.
- Stores the product in `product_stage`.
- Delays `valid_in` and `accum_clr` using pipeline registers.

### Stage 2: Accumulation

- Uses the delayed valid signal to identify valid products.
- Adds the stored product to the running result.
- If `accum_clr` is asserted for the corresponding sample, the previous accumulated value is discarded and replaced by the current product.
- Holds the previous result when no valid sample is available.

### Pipeline Flow

```text
       INPUT
      A and B
         |
         v
+----------------------+
|     STAGE 1          |
|                      |
|   Multiplication     |
|      A x B           |
|                      |
|  Product Register   |
|  Valid Register     |
|  Clear Register     |
+----------------------+
         |
         v
+----------------------+
|     STAGE 2          |
|                      |
|    Accumulation      |
|                      |
|  SUM = SUM + PRODUCT |
|                      |
|  Clear / Restart     |
+----------------------+
         |
         v
+----------------------+
|       OUTPUT         |
|                      |
|       result         |
|      valid_out       |
+----------------------+
```

## 3. Design Specifications

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | Clock signal |
| `rst_n` | Input | Synchronous active-low reset |
| `valid_in` | Input | Indicates a valid input sample |
| `accum_clr` | Input | Restarts accumulation for the corresponding valid sample |
| `A` | Input | First unsigned operand |
| `B` | Input | Second unsigned operand |
| `valid_out` | Output | Indicates completion of a valid sample |
| `result` | Output | Accumulated multiplication result |

### Parameters

| Parameter | Default Value | Description |
|---|---:|---|
| `DATA_WIDTH` | 8 | Width of input operands |
| `ACC_WIDTH` | 32 | Width of accumulator and output |

## 4. RTL Implementation

```systemverilog
module pipeline_multiply_accumulate #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  valid_in,
    input  logic                  accum_clr,
    input  logic [DATA_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0] B,
    output logic                  valid_out,
    output logic [ACC_WIDTH-1:0]  result
);

    logic [2*DATA_WIDTH-1:0] product_stage;
    logic                    valid_pipe;
    logic                    clr_pipe;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            product_stage <= '0;
            valid_pipe    <= 1'b0;
            clr_pipe      <= 1'b0;
        end else begin
            product_stage <= A * B;
            valid_pipe    <= valid_in;
            clr_pipe      <= accum_clr;
        end
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            result    <= '0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_pipe;

            if (valid_pipe) begin
                result <= clr_pipe
                    ? ACC_WIDTH'(product_stage)
                    : result + ACC_WIDTH'(product_stage);
            end
        end
    end

endmodule
```

## 5. Functional Verification

The design was tested against multiple functional scenarios to verify accumulation, pipeline behavior, clear functionality, and handling of invalid input cycles.

| Test Case | Input / Condition | Expected Behaviour |
|---|---|---|
| Basic Accumulation | A=3, B=4 for 5 cycles | Result builds: 12, 24, 36, 48, 60 |
| Mid-stream Clear | Accumulation followed by `accum_clr` | Previous sum is discarded and accumulation restarts |
| Bubble Injection | Alternating `valid_in` values | Invalid cycles are ignored |
| Maximum Operands | A=255, B=255 for 4 cycles | Result reaches 260100 |
| Back-to-back Clear | Three consecutive valid samples with `accum_clr=1`, A=7, B=8 | Result restarts at 56 for every sample |

<text_placeholder />

### Verification Results

<escape>✓</escape> All listed test scenarios passed successfully.

The verification checks covered:
- Correct multiplication and accumulation.
- Proper accumulator restart behaviour.
- Handling of invalid input cycles.
- Back-to-back valid samples.
- Accumulation with maximum 8-bit unsigned operands.

## 6. Synthesis Comparison

The implementation was compared against a reference implementation using the same evaluation platform.

Both implementations successfully passed the verification tests.

| Metric | My Implementation | Reference Implementation |
|---|---:|---:|
| Verification Status | PASSED | PASSED |
| Area | 40.8% | 13.8% |
| Performance | 18.5% | 60% |

### Comparison Analysis

- Both implementations achieved successful functional verification.
- My implementation reported higher area utilization compared to the reference.
- The reference implementation demonstrated lower area utilization and higher reported performance.

The comparison highlights the importance of RTL architecture, coding efficiency, and optimization in achieving better hardware performance.

*Note: Area and performance values are percentages reported by the evaluation platform.*

## 7. Conclusion

Successfully designed and verified a parameterized pipelined MAC unit using SystemVerilog. The project provided practical experience with sequential logic design, pipeline registers, valid-signal handling, and accumulator control.

The synthesis comparison also demonstrated how different RTL implementations of the same functionality can produce significantly different area and performance results.

**Key Focus Areas:** RTL Design | SystemVerilog | Pipelining | Sequential Logic | Functional Verification | Synthesis Analysis
