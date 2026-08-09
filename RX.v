//v1 RX, no two-flop synchronizer

module RX(
    input clk, 
    input reset, 
    input rx, 
    output reg [7:0]data_out,
    output reg data_done
);


localparam IDLE=1, START=2, PROCESS=3, STOP=4, DONE=5;
reg [2:0] bit_index;
reg[7:0] shift_reg, tick_counter;
reg[2:0] state;
wire tick;

            //revamp everything for efficiency later

baud_rate_gen#(
    .OVERSAMPLE(16),
    .BAUDRATE(9600),
    
    .CLOCKVALUE(27_000_000)
) rx_baudgen(
    .clk(clk),
    .reset(reset),
    .baud_clock(tick)
);

always@(posedge clk) begin
    if(reset) begin
        shift_reg <= 0;
        bit_index <= 0;
        state <= IDLE;
        tick_counter <= 0;
    end
    else begin
        data_done <= 0;
        case(state)
            IDLE: begin
                if(!rx) begin
                    state <= START;
                    bit_index <= 0;
                    tick_counter <= 0;
                end

                else
                    state <= IDLE;
            end
            START: begin
                if(tick) begin
                    tick_counter <= tick_counter + 1;
                end
                if((tick_counter==8) & !rx) begin
                    state <= PROCESS;
                    tick_counter <= 0;                  //fix tick counting for robustness later
                end
                else if(tick_counter!=8 && !rx)
                    state <= START; //redundant but idt it takes up space
                else begin
                    state <= IDLE;
                    tick_counter <=0;
                end
            end

            PROCESS: begin
                if(tick) 
                    tick_counter <= tick_counter + 1;

                if(tick_counter==8) begin
                    bit_index <= bit_index + 1;
                    shift_reg <= {rx, shift_reg[7:1]};
                    tick_counter <= 0;
                    if(bit_index == 7)
                        state <= STOP;
                end
            end

            STOP: begin
                if(tick) 
                    tick_counter <= tick_counter + 1;

                if(tick_counter==8) begin
                    if(rx) begin
                        data_out <= shift_reg;
                        state <= DONE;
                        tick_counter <= 0;
                    end
                    else
                        state <= IDLE;
                end
            end

            DONE: begin
                data_done <= 1;
                state <= IDLE;
                
            end
        endcase
    end
end
endmodule
