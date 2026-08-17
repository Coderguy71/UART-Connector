module CommandParser(
    input reset, clk, rx_in,
    input data_done,
    output reg [2:0] opcode,
    output reg [3:0] A, B,
    output reg ALUready
);

wire [7:0] data_out;
reg [1:0] counter;

RX rx_parser(
    .clk(clk),
    .reset(reset),
    .rx_in(rx_in),
    .data_out(data_out),
    .data_done(data_done)
);

always @(posedge clk) begin
    if(reset) begin
        A <= 0;
        B <= 0;
        opcode <= 0;
        ALUready <= 0;
        counter <= 0;
    end
    else begin
        ALUready <= 0;
        if(data_done) begin
            case(counter)
                2'b00: begin
                    opcode  <= data_out[2:0];
                    counter <= counter + 1;
                end
                2'b01: begin
                    A       <= data_out[3:0];
                    counter <= counter + 1;
                end
                2'b10: begin
                    B        <= data_out[3:0];
                    ALUready <= 1;
                    counter  <= 0;
                end
                default: counter <= 0;
            endcase
        end
    end
end

endmodule
