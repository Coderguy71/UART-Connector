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






endmodule




