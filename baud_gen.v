module baud_rate_gen#(
    parameter OVERSAMPLE = 16,
    parameter BAUDRATE = 9600, 
    parameter CLOCKVALUE = 27_000_000
    )(
    input clk,
    input reset,
    output reg baud_clock
);

localparam Baud_val = ((CLOCKVALUE)/(BAUDRATE * OVERSAMPLE)) - 1; //local param so noone can accidently assign baud_val 
reg[11:0] count; //used $clog2(2812)=12 since thats the largest value needed to be held. This is wasteful rightnow since rx doesn't need that much (175) *TO BE CHANGED*

always @(posedge clk) begin
    baud_clock <= 0;

    if(reset)
        count <= 0;
    else if (Baud_val == count) begin
        baud_clock <= 1;
        count <= 0;
    end
    else
        count <= count+1;
end


endmodule
