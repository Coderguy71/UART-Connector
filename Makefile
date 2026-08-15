ALU_TOP = ALU_Testbench
ALU_SRCS = ALU.v ALU_Testbench.v


TX_TOP = TX_Testbench
TX_SRCS = TX.v TX_Testbench.v BAUD_RATE_GEN.v


RX_TOP = RX_Testbench
RX_SRCS = RX.v RX_Testbench.v BAUD_RATE_GEN.v



alu: $(ALU_SRCS)
	verilator --binary --trace $(ALU_SRCS) --top-module $(ALU_TOP)
	./obj_dir/V$(ALU_TOP)


tx: $(TX_SRCS)
	verilator --binary --trace -Wno-WIDTHEXPAND -Wno-TIMESCALEMOD $(TX_SRCS) --top-module $(TX_TOP)
	./obj_dir/V$(TX_TOP)


rx: $(RX_SRCS)
	verilator --binary --trace -Wno-WIDTHEXPAND -Wno-TIMESCALEMOD $(RX_SRCS) --top-module $(RX_TOP)
	./obj_dir/V$(RX_TOP)


alu_wave:
	gtkwave alu_wave.vcd &


tx_wave:
	gtkwave tx_wave.vcd &


rx_wave:
	gtkwave rx_wave.vcd &


clean:
	rm -rf obj_dir *.vcd
