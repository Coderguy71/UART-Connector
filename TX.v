module TX(
    input clk,
    input reset,
    input [7:0] data_in,
    input start,
    output reg tx,
    output reg busy
);

localparam IDLE = 2'd0;
localparam DATA = 2'd1;
localparam STOP = 2'd2;

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] shift_reg;

wire tick;

baud_rate_gen #(
    .OVERSAMPLE(1),
    .BAUDRATE(9600),
    .CLOCKVALUE(27_000_000)
) tx_baudgen (
    .clk(clk),
    .reset(reset),
    .baud_clock(tick)
);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        bit_index <= 0;
        shift_reg <= 0;
    end
    else begin
        case (state)

            IDLE: begin
                tx <= 1'b1;
                busy <= 1'b0;

                if (start) begin
                    shift_reg <= data_in;
                    bit_index <= 0;
                    tx <= 1'b0;
                    busy <= 1'b1;
                    state <= DATA;
                end
            end

            DATA: begin
                if (tick) begin
                    tx <= shift_reg[0];

                    if (bit_index == 7) begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 1;
                        shift_reg <= {1'b0, shift_reg[7:1]};
                    end
                end
            end

            STOP: begin
                if (tick) begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    state <= IDLE;
                end
            end

            default: begin
                state <= IDLE;
                tx <= 1'b1;
                busy <= 1'b0;
                bit_index <= 0;
            end

        endcase
    end
end

endmodule
