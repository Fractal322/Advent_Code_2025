module puzzle3_2 (
    input clk,
    input rst_n,
    input [3:0] data_in,
    input wr_en,
    input bank_end,

    output logic [63:0] sum
);

logic enable;

logic [6:0] tmp [0:11];
logic [6:0] tmp_next [0:11];
logic [63:0] sum_next;


logic [3:0] bank [0:127];
logic [6:0] bank_capacity;

// combinational logic registers
logic [6:0] search_range [0:11];
logic [6:0] tmp_place [0:11];
logic [6:0] place_shift;

localparam logic [63:0] P10_10 = 64'd10_000_000_000;
localparam logic [63:0] P10_11 = 64'd100_000_000_000;

always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 12; i = i + 1) begin
            tmp[i] <= 4'd0;
        end
        for (int i = 0; i < 128; i = i + 1) begin
            bank[i] <= 4'd0;
        end
        bank_capacity <= 7'd0;
        sum <= 32'd0;
        enable <= 1'b0;
    end 
    else begin
        enable <= wr_en;
        if (enable) begin
            for (int i = 0; i < 12; i = i + 1) begin
                bank_capacity <= bank_capacity + 1;
                bank[bank_capacity] <= data_in;
            end
        end
        else begin
            for (int i = 0; i < 12; i = i + 1) begin
                tmp[i] <= tmp_next[i];
            end
            bank_capacity <= 0;
        end
        if (!enable && rst_n) sum <= sum + sum_next;
    end
    
end

always_comb begin
    sum_next = 32'd0;
    if (!enable && rst_n) begin
        // Reset all numbers
        for (int i = 0; i < 12; i = i + 1) begin
            tmp_next[i] = 0;
            search_range[i] = bank_capacity - 12 + i;
            tmp_place[i] = i;
        end
        place_shift = 0;
        $display("Now lets search for max numbers");
        // Find 12 largest numbers
        for (int i = 0; i < 12; i++) begin
           for (int j = place_shift; j < search_range[i]; j++) begin
                if (bank[j] > tmp_next[i]) begin
                    tmp_next[i] = bank[j];
                    tmp_place[i] = j;
                    $display("New tmp_next[%0d] = %0d", i, tmp_next[i]);
                end
           end
           place_shift = tmp_place[i] + 1;
        end
    end
    else begin
    place_shift = 0;
    for (int i = 0; i < 12; i = i + 1) begin
        tmp_next[i] = tmp[i];
    end
end

    for (int i = 0; i < 12; i = i + 1) begin
        if (i != 0 && i != 1) begin
            sum_next = sum_next + (tmp_next[i] * (10 ** (11 - i)));
        end
        else if (i == 0) begin
            sum_next = sum_next + (tmp_next[i] * P10_11);
        end
        else if (i == 1) begin
            sum_next = sum_next + (tmp_next[i] * P10_10);
        end
    end

end

endmodule