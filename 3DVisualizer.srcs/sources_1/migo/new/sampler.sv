`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 02:48:20 AM
// Design Name: 
// Module Name: sampler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sampler(
    input logic clk,
    input logic rst,
    output logic [9:0] addrb,
    input logic [15:0] doutb,
    output logic read,
    output logic [15:0]data_out,
    output logic last_out,
    output logic valid_out,
    input logic ready_out
    );
    parameter SAMPLE_COUNT = 2268;//gets approximately (will generate audio at approx 48 kHz sample rate.
    logic [12:0] sample_counter;
    
    //ila_0 ila1 (.clk(clk), .probe0(addrb), .probe1(read), .probe2(doutb), .probe3(sample_counter), .probe4(ready_out));
    

    always_ff @(posedge clk)begin
        if (rst) begin
            sample_counter <= 0;
            addrb <= 0;
            last_out <= 0;
            valid_out <= 0;
            data_out <= 0;
            read <= 0;
        end else begin
            if (sample_counter == SAMPLE_COUNT)begin
                if (ready_out) begin
                    sample_counter <= 16'b0;
                    addrb <= addrb + 1;
                    last_out <= addrb == 1023;
                    valid_out <= 1;
                    data_out <= doutb;
                    if (addrb == 511) read <= 0;
                    else if (addrb == 1023) read <= 1;
                end
            end else begin
                valid_out <= 0;
                sample_counter <= sample_counter + 16'b1;
            end
        end
    end
        
endmodule
