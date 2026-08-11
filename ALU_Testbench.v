module ALU_Testbench;
    reg[3:0]  A, B;
    reg[2:0] Operation;
    wire[7:0] result;
    

    ALU ALUtest (
        .A(A),
        .B(B),
        .Operation(Operation),
        .result(result)
    );

    initial begin
      //originally used: $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result); //%d means decimal and %b mean binary
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b001;
         #10;
         if (result == 8'd2)
            $display("ADD: PASS (result=%d)", result);
        else
            $display("ADD: FAIL (result=%d)", result);
        
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b010;
         #10;
         if (result == 8'd0)
            $display("SUB: PASS (result=%d)", result);
        else
            $display("SUB: FAIL (result=%d)", result);

        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b011;
         #10;
         if (result == 8'd1)
            $display("MULT: PASS (result=%d)", result);
        else
            $display("MULT: FAIL (result=%d)", result);
        
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b100;
         #10;
         if (result == 8'd2)
            $display("SHIFT LEFT: PASS (result=%d)", result);
        else
            $display("SHIFT LEFT: FAIL (result=%d)", result);

        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b101;
         #10;
         if (result == 8'd0)
            $display("SHIFT RIGHT: PASS (result=%d)", result);
        else
            $display("SHIFT RIGHT: FAIL (result=%d)", result);

        $finish;
    end

endmodule
