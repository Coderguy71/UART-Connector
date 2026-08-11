module ALU_Testbench;
    reg[3:0]  A, B;
    reg[2:0] Operation;
    wire[7:0] result;
    integer pass_count = 0;
    integer test_count = 0;
    

    ALU ALUtest (
        .A(A),
        .B(B),
        .Operation(Operation),
        .result(result)
    );

    task run_test; 
        input[3:0] Ain, Bin;
        input[2:0] Operationin;
        input[7:0] Expected_result;
        input[127:0] test_name;
        begin 
            A = Ain;
            B = Bin;
            Operation = Operationin;
            #10;
            test_count = test_count + 1;
            if(result == Expected_result) begin
                pass_count = pass_count + 1;
                $display("%s: PASS (result=%0d)", test_name, result);
            end else begin
                $display("%s: FAIL (expected=%d, result=%0d)", test_name, Expected_result, result);
            end
        end
    endtask

    initial begin
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, ALU_Testbench);

        run_test(4'd1, 4'd1, 3'b001, 8'd2, "ADD");
        run_test(4'd1, 4'd1, 3'b010, 8'd0, "SUBTRACT");
        run_test(4'd1, 4'd1, 3'b011, 8'd1, "MULTIPLY");
        run_test(4'd1, 4'd1, 3'b100, 8'd2, "SHIFT_LEFT");
        run_test(4'd1, 4'd1, 3'b101, 8'd0, "SHIFT_RIGHT");
        run_test(4'd1, 4'd1, 3'b111, 8'd0, "OP_ERROR");
        run_test(4'd0, 4'd1, 3'b010, 8'd255, "SUB_OVERFLOW");
        run_test(4'd15, 4'd15, 3'b011, 8'd225, "MULT_MAX");
        run_test(4'd15, 4'd4, 3'b100, 8'd240, "SHIFTL_OVER");
        run_test(4'd15, 4'd2, 3'b101, 8'd3, "SHIFTR_TEST2");

        $display("---");
        $display("%0d/%0d tests passed", pass_count, test_count);
        $finish;
    end

endmodule
