module TX(
    input clk,
    input reset,
    input [7:0]data_in,
    input start,
    output reg tx,
    output reg busy
);



localparam IDLE=1, START=2, PROCESS=3, STOP=4;
reg[1:0] state;
wire tick;
reg[2:0] bit_index;
reg[7:0] shift_reg;

baud_rate_gen#(         //new instantiation ive never done, first part is the module name with the parameters and the second one is the instance name with ports
    .OVERSAMPLE(1),
    .BAUDRATE(9600),
    .CLOCKVALUE(27_000_000)
) tx_baudgen (
    .clk(clk),
    .reset(reset),
    .baud_clock(tick)
);


always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        tx <= 1;
        busy <= 0;
        bit_index <= 0;
    end 
    else begin
        case(state)
            IDLE: begin
                tx <= 1;
                if (start) begin
                    busy <= 1;
                    shift_reg <= data_in;
                    state <= START;
                end
            end

            START: begin
                tx <= 0;
                if (tick)
                    state <= PROCESS:
            end

            PROCESS: begin
                tx <= shift_reg[0];
                if(tick) begin
                    if(bit_index == 3'b111)
                        state <= STOP;
                    else begin
                        bit_index <= bit_index + 1;
                        shift_reg <= shift_reg >> 1;  //first time using logical right shift operation. its also shift_reg <= {1'b0, shift_reg[7:1]}
                    end
                end
            end

            STOP: begin
                tx <= 1;
                if (tick) begin
                    bit_index <= 0;
                    busy <= 0;
                    state <= IDLE;
                end

                end
        endcase
    end
end
        




endmodule
