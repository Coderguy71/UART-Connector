module ALU(
    input [3:0]  A,
    input [3:0]  B,
    input[2:0] Operation,
    output reg [7:0] result
);
//Change to localparam Add = 3'b001 etc
always @(*) begin
    case(Operation)
        3'b001: 
            result = A + B;
        3'b010:
            result = A - B;
        3'b011: 
            result = A * B;
        3'b100:
            result = A << B;
        3'b101:
            result = A >> B;

        default: 
            result = 0;
    endcase


end




endmodule
