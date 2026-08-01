// pixel rom holds 784 image pixels
module pixel_rom(
input logic clk,
//no reset needed,
input logic[9:0] addr, // read addr , 10 bits as 2^10 = 1024 and we need till 784
output logic [15:0] dout //the 16 bit weight which is spit out
);

logic [15:0] mem [0:783]; // 10 bits 0-9

initial begin
    // $readmemh reads hexdecimal files
    $readmemh("pixels.txt", mem);
end
//read operation
always @(posedge clk) begin
        dout <= mem[addr];
    end
endmodule