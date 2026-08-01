module top (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    output logic [3:0]  predicted_digit,
    output logic        done
);
    
    logic [9:0]  pixel_addr;       
    logic [12:0] weight_addr;

    logic clear_macs;
    logic acc_en;
    logic [3:0] current_neuron; // <-- NEW WIRE

    logic [15:0] pixel_data;   
    logic [15:0] weight_data;  

    logic signed [31:0] mac_scores [0:9];
    logic signed [31:0] final_score[0:9];
    
    fsm u_fsm (
        .clk(clk),
        .reset(reset),
        .start(start),
        .pixel_addr(pixel_addr),
        .weight_addr(weight_addr),
        .done(done),
        .accumulate_en(acc_en),
        .clear_macs(clear_macs),
        .neuron_idx(current_neuron) // <-- CONNECTED WIRE
    );

    pixel_rom u_pixel_rom(
        .clk(clk),
        .addr(pixel_addr),
        .dout(pixel_data)
    );

    weight_rom  u_weight_bram (
        .clk(clk),
        .addr(weight_addr),
        .dout(weight_data)
    );

    genvar i;
    generate
        for (i = 0; i < 10; i++) begin : gen_mac_array
            
            logic [31:0] current_bias;  

            bias_rom u_bias_brom (
                .clk(clk),
                .addr(i[3:0]),
                .dout(current_bias)
            );

            mac_unit mac (
                .clk(clk),
                .reset(reset),
                // THE MAGIC FIX: Only accumulate when the FSM points to this specific MAC
                .accumulate_en(acc_en && (current_neuron == i[3:0])), 
                .clear(clear_macs),
                .pixel($signed(pixel_data)),   
                .weight($signed(weight_data)), 
                .bias_in($signed(current_bias)), 
                .acc_out(mac_scores[i]),
                .final_score(final_score[i])
            );
        end
    endgenerate

    argmax u_argmax(
        .scores(final_score),
        .best_digit(predicted_digit)
    );

endmodule