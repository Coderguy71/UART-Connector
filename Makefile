TOP = ALU_Testbench
SRCS = ALU.v ALU_Testbench.v

sim: $(SRCS)
	verilator --binary --trace $(SRCS) --top-module $(TOP)
	./obj_dir/V$(TOP)

wave:
	gtkwave alu_wave.vcd &

clean: 
	rm -rf obj_dir *.vcd
