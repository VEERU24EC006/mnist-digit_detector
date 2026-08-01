module bias_rom(
    input logic clk,
    input logic [3:0] addr, // 4 bits can hold 0-9 as 2^4 = 16
    output logic [31:0] dout // to match bias_in width
);

//  32 bit data (to fit 10 neuron biases)

logic [31:0] mem [0:9];

initial begin
    $readmemh("bias_all.txt",mem);
end

always_ff @(posedge clk) begin
        dout <= mem[addr];
end
endmodule
