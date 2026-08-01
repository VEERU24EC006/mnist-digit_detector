// weight rom holds the weight for 7840 values for all 10 neurons
module weight_rom(
input logic clk,
//no reset needed

input logic[12:0] addr, // read addr , 13 bits as 2^13 = 8192 and we need till 7840
output logic [15:0] dout //the 16 bit weight which is spit out
);
logic [15:0] mem [0:7839]; // 7840 slots, 16 bits wide
//load the python weights into array when fpga is on
initial begin
    // $readmemh reads hexdecimal files
    $readmemh("weights_all.txt", mem);
end
//read operation
always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule