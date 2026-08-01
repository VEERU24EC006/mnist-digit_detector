module argmax(
    input logic signed [31:0] scores[0:9], //10 parallel outputs from mac array
    output logic [3:0] best_digit
);

    always_comb begin
         logic signed [31:0] max_val;
         logic [3:0] best_idx;

        max_val = scores[0];
        best_idx = 4'd0;

        for (int i = 1; i<10; i++)begin
                if(scores[i]>max_val)begin
                        max_val = scores[i];
                        best_idx = i[3:0];
                end
        end

        best_digit = best_idx;
    end

endmodule