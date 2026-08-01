// MAC UNIT
// combinational part of the MAC unit
module mac_unit(
    input logic  clk,
    input logic reset,
    input logic clear,
    input logic accumulate_en,
    input signed [15:0] pixel,
    input signed [15:0] weight,
    input signed [31:0] bias_in,
    output logic signed [31:0] acc_out,
    output logic signed [31:0] final_score // accumulated score for this neuron
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        acc_out <= '0;
    end

   else if (clear) begin
        acc_out <= '0;
    end
    else if (accumulate_en) begin
    acc_out <= acc_out + (weight * pixel);
    end
  end     
  
  assign final_score = acc_out + bias_in;   

endmodule
