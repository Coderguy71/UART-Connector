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
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b001;
         #10;
      	 $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result); //%d means decimal and %b mean binary
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b010;
         #10;
      	 $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result);
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b011;
         #10;
      	 $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result);
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b100;
         #10;
      	 $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result);
        assign A = 4'b0001;
        assign B = 4'b0001;
        assign Operation = 3'b101;
         #10;
      	 $display("A=%d B=%d Op=%b Result=%d", A, B, Operation, result);  
        $finish;
    end

endmodule
