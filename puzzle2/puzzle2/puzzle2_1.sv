module puzzle2_1(
    input clk,
    input reset,
    input wr_en,
    input [63:0] id1,
    input [63:0] id2,

    output logic valid,
    output logic [63:0] sum
);

logic [63:0] id1_reg;
logic [63:0] id2_reg;
logic [63:0] sum_reg;
logic valid_id;
logic [4:0] check;

logic rdy;
logic rdy_reg;
logic [4:0] fig_number;
logic [63:0] number;

localparam logic [63:0] P10_11 = 64'd100_000_000_000;
localparam logic [63:0] P10_12 = 64'd1_000_000_000_000;
localparam logic [63:0] P10_13 = 64'd10_000_000_000_000;
localparam logic [63:0] P10_14 = 64'd100_000_000_000_000;
localparam logic [63:0] P10_15 = 64'd1_000_000_000_000_000;
localparam logic [63:0] P10_16 = 64'd10_000_000_000_000_000;
localparam logic [63:0] P10_17 = 64'd100_000_000_000_000_000;
localparam logic [63:0] P10_18 = 64'd1_000_000_000_000_000_000;
localparam logic [63:0] P10_19 = 64'd10_000_000_000_000_000_000;
localparam logic [63:0] P10_20 = 64'd100_000_000_000_000_000_000;
localparam logic [63:0] P10_21 = 64'd1_000_000_000_000_000_000_000;


always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        id1_reg <= 64'b0;
        id2_reg <= 64'b0;
        valid <= 0;
        rdy_reg <= 0;
        sum <= 64'b0;

    end 
    else begin
    if (wr_en) begin
        id1_reg <= id1;
        id2_reg <= id2;
        
    end
    if (!wr_en) valid <= rdy;
    sum <= sum_reg;
    end
end

always_comb begin
    valid_id = 0;
    sum_reg = sum;
    rdy = 0;
    if (wr_en || !rdy) begin
        number = id1_reg;
        check = 0;
        while (number <= id2_reg) begin
            // Determine number of digits
            if (number > 0 && number < 10) fig_number = 1;
            else if (number >= 10 && number < 100) fig_number = 2;
            else if (number >= 100 && number < 1000) fig_number = 3;
            else if (number >= 1000 && number < 10000) fig_number = 4;
            else if (number >= 10000 && number < 100000) fig_number = 5;
            else if (number >= 100000 && number < 1000000) fig_number = 6;
            else if (number >= 1000000 && number < 10000000) fig_number = 7;
            else if (number >= 10000000 && number < 100000000) fig_number = 8;
            else if (number >= 100000000 && number < 1000000000) fig_number = 9;
            else if (number >= 1000000000 && number < P10_11) fig_number = 10;
            else if (number >= P10_11 && number < P10_12) fig_number = 11;
            else if (number >= P10_12 && number < P10_13) fig_number = 12;
            else if (number >= P10_13 && number < P10_14) fig_number = 13;
            else if (number >= P10_14 && number < P10_15) fig_number = 14;
            else if (number >= P10_15 && number < P10_16) fig_number = 15;
            else if (number >= P10_16 && number < P10_17) fig_number = 16;
            else if (number >= P10_17 && number < P10_18) fig_number = 17;
            else if (number >= P10_18 && number < P10_19) fig_number = 18;
            else if (number >= P10_19 && number < P10_20) fig_number = 19;
            else if (number >= P10_20 && number < P10_21) fig_number = 20;// 100000000000000000000 is 10^20 and max 64-bit number is less than 10^20
            else fig_number = 0;

            valid_id = is_valid_id(number, fig_number);

            if (!valid_id) begin
                sum_reg += number;
                number++;
                check++;
            end
            else number++;
        end
        
    end
    rdy = 1;
end

function logic is_valid_id(input [63:0] id, input [4:0] fig_num);
    // Implement validation logic here
    // For example, check if the ID meets certain criteria
    logic [4:0] temp_fig;
    logic [31:0] val1;
    logic [31:0] val2;
    temp_fig = 0;

    if (fig_num == 0) return 1;
    else if (fig_num[0] == 1) return 1; // Odd number of digits
    else if (fig_num[0] == 0) begin
        temp_fig = fig_num >> 1;
        val1 = id / (10 ** temp_fig);
        val2 = id % (10 ** temp_fig);
        if (val1 != val2) return 1;
        else return 0;  
    end

endfunction

endmodule