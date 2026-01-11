module puzzle3_1 (
    input clk,
    input rst_n,
    input [3:0] data_in,
    input wr_en,
    input bank_end,

    output logic [31:0] sum
);

logic enable;

logic [3:0] tmp1;
logic [3:0] tmp2;
logic [31:0] sum_next;

logic [3:0] tmp1_next;
logic [3:0] tmp2_next;


always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        tmp1 <= 4'd0;
        tmp2 <= 4'd0;
        sum <= 32'd0;

        enable <= 1'b0;
    end 
    else begin
        enable <= wr_en;
        tmp1 <= tmp1_next;
        tmp2 <= tmp2_next;
        
        sum <= sum_next;
    end
    
end

always_comb begin

    if (!enable & wr_en) begin
        tmp1_next = data_in;
        tmp2_next = 0;
    end
    else if (data_in > tmp1 && !bank_end) begin
        tmp1_next = data_in;
        tmp2_next = 0;
    end
    else if (tmp1 >= data_in && data_in > tmp2 && !bank_end) tmp2_next = data_in;
    else if (bank_end && data_in > tmp2) tmp2_next = data_in;
    else begin
        tmp1_next = tmp1;
        tmp2_next = tmp2;
    end

    if (!wr_en) sum_next = tmp1 * 10 + tmp2 + sum;
    else sum_next = sum;

end

endmodule