module CommandParser(
    input reset, clk, rx_in;
    input data_done;
    output reg [2:0] opcode;
    output reg [3:0] A, B;
    output reg ALUready;
);

endmodule

wire [7:0] data_out;
wire data_done;
reg[1:0] counter;

RX rx_parser(
    .clk(clk),
    .reset(reset),
    .rx_in(rx_in),
    .data_out(data_out),
    .data_done(data_done)
)

always @(posedge clk) begin
    if(reset) begin
        data_out <= 0;
        A <= 0;
        B <= 0;
        ALUready <= 0;
        data_done <= 0;
        counter <= 0;
    end
    else begin
        ALUready <= 0;
        if(data_done) begin
            counter <= counter + 1;
            case(counter) begin
                2'b01: opcode <= data_out[2:0];
                2'b10: A <= data_out[3:0];
                2'b11: begin
                     B <= data_out[3:0];
                     ALUready <= 1;
                end
            end
            endcase
        end
    end
end





