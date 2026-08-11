# UART-Interfaced 4-Bit ALU on FPGA
 
A Verilog implementation of a 4-bit ALU controlled entirely over UART, built on the Sipeed Tang Nano 20K (Gowin GW2AR-18). Since the board has no physical switches or a 7-segment display, 
UART serves as the primary interface for both sending operands/opcodes to the ALU and reading back results. This can also be utilized in a variety of projects. 

## Status
This project is being built and documented incrementally as a portfolio piece, with each module simulated and verified before moving to the next. Currently V1 of the RX, TX, and BAUD_RATE_GEN are published. 
 
| Module | Status |
|---|---|
| `BAUD RATE GEN` | ✅ done|
| UART `TX` | ✅ done|
| UART `RX` | ✅ done|
| ALU CORE | ✅ done|
| ALU TESTBENCH | ✅ done|
| RX TWO-FLOP SYNCRHONIZER | ❌ not started |
| TX TESTBENCH | ❌ not started |
| RX TESTBENCH | ❌ not started |
| COMMAND PARSER | ❌ not started |
| TOP-LEVEL INTEGRATION | ❌ not started |
| PiIN CONSTRAINTS (`.cst`) | ❌ not started |
| END TO END TESTING | ❌ not started |
