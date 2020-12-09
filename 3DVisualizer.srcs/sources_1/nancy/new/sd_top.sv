`timescale 1ns / 1ps

module sd_top(input logic clk,
                    input logic sd_cd,
                    input logic rst, // replace w/ your system reset
                    input logic read,
                    input logic btnu, btnr, btnl, btnc,
                    inout [3:0] sd_dat,
                    output logic [9:0] addra,
                    output logic wea,
                    output logic [15:0] dina,
                    output logic sd_reset,
                    output logic sd_sck,
                    output logic sd_cmd
    );


    assign sd_dat[2:1] = 2'b11;
    assign sd_reset = 0;
    

    // generate 25 mhz clock for sd_controller

    logic read_sync[3];
    logic prev_read;
    // sd_controller inputs
    logic rd;                   // read enable
    logic wr;                   // write enable
    logic [7:0] din;            // data to sd card
    logic [31:0] addr;          // starting address for read/write operation
    logic [10:0] count;
    logic reading;

    // sd_controller outputs
    logic ready;                // high when ready for new read/write operation
    logic [7:0] dout;           // data from sd card
    logic byte_available;       // high when byte available for read
    logic byte_available_prev;
    logic ready_for_next_byte;  // high when ready for new byte to be written

    // handles reading from the SD card
    logic prev;
    logic [7:0] prev_byte;
    assign addra = count >> 1;
    assign dina = {prev_byte, dout};
    logic second;
    
    sd_controller sd(.reset(rst), .clk(clk), .cs(sd_dat[3]), .mosi(sd_cmd),
                     .miso(sd_dat[0]), .sclk(sd_sck), .ready(ready), .address(addr),
                     .rd(rd), .dout(dout), .byte_available(byte_available),
                     .wr(wr), .din(din), .ready_for_next_byte(ready_for_next_byte));
                     
    //ila_0 u_ila (.clk(clk), .probe0(count), .probe1(reading), .probe2(dout), .probe3(wea), .probe4(dina), 
    //             .probe5(rd), .probe6(ready));
    always_ff @(posedge clk) begin
        if (rst) begin
            read_sync <= {0,0,0};
            addr <= 0;
            byte_available_prev <= byte_available;
            prev_read <= 0;
            rd <= 0;
            count <= 0;
            reading <= 0;
            prev <= 0;
            second <= 1;
        end else if (btnu) addr <= 'h01bb3800;
        else if (btnc) addr <= 'h03050c00;
        else if (btnl) addr <= 'h049e7e00;
        else if (btnr) addr <= 0;
        else begin
            byte_available_prev <= byte_available;
            read_sync[0] <= read;
            read_sync[1] <= read_sync[0];
            read_sync[2] <= read_sync[1];
            prev_read <= read_sync[2];
            if (reading) begin
                rd <= 0;
                if (byte_available && !byte_available_prev) begin
                    count <= count + 1;
                    if (!prev) begin
                        prev <= 1;
                    end else begin
                        prev <= 0;
                        prev_byte <= dout;
                        if (count == 1023 || count == 2047) reading <= 0;
                        if (count == 511 || count == 1535) begin
                            second <= 1;
                            reading <= 0;
                        end
                    end
                end
            end else if (((read_sync[2] == ~prev_read) || second) && ready) begin
                second <= 0;
                reading <= 1;
                rd <= 1;
                addr <= addr + 512;
                if (!second) count <= read_sync[2] ? 1024 : 0;
            end
         end
    end
    
    always_comb begin
        if (reading && byte_available && !byte_available_prev && !prev) begin
                    wea = 1;
        end else wea = 0;
    end
                   
   

endmodule
