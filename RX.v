module RX(
    input clk,
    input reset,
    input rx_in,
    output reg [7:0] data_out,
    output reg data_done
);

localparam IDLE    = 3'd0;
localparam START   = 3'd1;
localparam DATA    = 3'd2;
localparam STOP    = 3'd3;

reg [2:0] state;
reg [2:0] bit_index;
reg [7:0] shift_reg;
reg [3:0] tick_counter;

reg sync_stage1, rx;
wire tick;

baud_rate_gen #(
    .OVERSAMPLE(16),
    .BAUDRATE(9600),
    .CLOCKVALUE(27_000_000)
) rx_baudgen (
    .clk(clk),
    .reset(reset),
    .baud_clock(tick)
);

always @(posedge clk) begin
    if (reset) begin
        sync_stage1 <= 1'b1;
        rx <= 1'b1;
    end
    else begin
        sync_stage1 <= rx_in;
        rx <= sync_stage1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_index <= 0;
        shift_reg <= 0;
        tick_counter <= 0;
        data_out <= 0;
        data_done <= 0;
    end
    else begin
        data_done <= 0;

        if (tick) begin
            case (state)

                IDLE: begin
                    tick_counter <= 0;
                    bit_index <= 0;

                    if (!rx)
                        state <= START;
                end

                START: begin
                    if (tick_counter == 7) begin
                        tick_counter <= 0;

                        if (!rx)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                    else begin
                        tick_counter <= tick_counter + 1;
                    end
                end

                DATA: begin
                    if (tick_counter == 15) begin
                        tick_counter <= 0;

                        // Sample current data bit
                        shift_reg[bit_index] <= rx;

                        if (bit_index == 7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1;
                        end
                    end
                    else begin
                        tick_counter <= tick_counter + 1;
                    end
                end

                STOP: begin
                    if (tick_counter == 15) begin
                        tick_counter <= 0;

                        if (rx) begin
                            data_out <= shift_reg;
                            data_done <= 1;
                        end

                        state <= IDLE;
                    end
                    else begin
                        tick_counter <= tick_counter + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                    tick_counter <= 0;
                    bit_index <= 0;
                end

            endcase
        end
    end
end

endmodule
