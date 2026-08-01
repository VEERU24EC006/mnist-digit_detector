module fsm(
    input logic clk,
    input logic reset,
    input logic start, 
    output logic clear_macs, 
    output logic [9:0] pixel_addr, 
    output logic [12:0] weight_addr,
    output logic done,
    output logic accumulate_en,
    output logic [3:0] neuron_idx // <-- NEW SIGNAL
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;
    
    state_t current_state, next_state;

    logic [12:0] counter;
    logic [9:0]  pix_counter;
    logic [3:0]  n_counter;
    logic [3:0]  n_counter_delayed; // Handles 1-cycle ROM delay

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            counter <= '0;
            pix_counter <= '0;
            n_counter <= '0;
            n_counter_delayed <= '0;
        end else begin
            current_state <= next_state;
            n_counter_delayed <= n_counter; 
            
            if (current_state == CALC) begin
                counter <= counter + 1'b1;
                
                // Reset pixel address every 784 cycles and increment neuron target
                if (pix_counter == 10'd783) begin
                    pix_counter <= '0;
                    n_counter <= n_counter + 1'b1;
                end else begin
                    pix_counter <= pix_counter + 1'b1;
                end
                
            end else if (current_state == IDLE) begin
                counter <= '0;
                pix_counter <= '0;
                n_counter <= '0;
            end
        end
    end

    assign pixel_addr = pix_counter;
    assign weight_addr = counter;

    always_comb begin
        next_state = current_state;
        clear_macs = 1'b0;
        done = 1'b0;

        case(current_state)
            IDLE: begin
                clear_macs = 1'b1;
                if(start) begin
                    next_state = CALC;
                end
            end
            CALC: begin
                if (counter == 13'd7839) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign accumulate_en = (current_state == CALC) && (counter > 10'd0);
    assign neuron_idx = n_counter_delayed; // Output the delayed target

endmodule