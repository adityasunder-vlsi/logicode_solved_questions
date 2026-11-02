# Digital Stopwatch – SystemVerilog

## Overview
A 24-hour digital stopwatch designed using SystemVerilog. The design uses three independent counters to track seconds, minutes, and hours.

## Features
- Seconds counter: 0–59
- Minutes counter: 0–59
- Hours counter: 0–23
- Automatic cascading counter rollover.
- Asynchronous active-high reset.
- Synthesizable RTL using `always_ff`.

## Design Architecture
The stopwatch consists of three sequential counter blocks:

- **Seconds:** Increments every clock cycle and resets at 59.
- **Minutes:** Increments whenever seconds reach 59.
- **Hours:** Increments whenever both minutes and seconds reach 59, resetting at 23.

## Synthesis Results

| Metric | Original Implementation | Optimized Implementation |
|---|---:|---:|
| Area | 61.7% | 20.1% |
| Performance | 14.9% | 82.5% |

*Results reported by the HDL evaluation platform. Values are platform-specific.*

## Conclusion

The original stopwatch design successfully implements a cascaded counter system using SystemVerilog. Although functionally correct, its synthesis results showed higher area utilization (61.7%) and lower performance (14.9%). This provided an opportunity to explore RTL optimization techniques, demonstrating how coding structure and sequential logic design can significantly impact hardware area and timing performance.
