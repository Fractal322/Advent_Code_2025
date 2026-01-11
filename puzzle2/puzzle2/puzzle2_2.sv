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

localparam logic [63:0] P10_10 = 64'd10_000_000_000;
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
            else if (number >= 1000000000 && number < P10_10) fig_number = 10;
            else if (number >= P10_10 && number < P10_11) fig_number = 11;
            else if (number >= P10_11 && number < P10_12) fig_number = 12;
            else if (number >= P10_12 && number < P10_13) fig_number = 13;
            else if (number >= P10_13 && number < P10_14) fig_number = 14;
            else if (number >= P10_14 && number < P10_15) fig_number = 15;
            else if (number >= P10_15 && number < P10_16) fig_number = 16;
            else if (number >= P10_16 && number < P10_17) fig_number = 17;
            else if (number >= P10_17 && number < P10_18) fig_number = 18;
            else if (number >= P10_18 && number < P10_19) fig_number = 19;
            else if (number >= P10_19 && number < P10_20) fig_number = 20;// 100000000000000000000 is 10^20 and max 64-logic number is less than 10^20
            else fig_number = 0;

            valid_id = is_valid_id(number, fig_number);

            if (!valid_id) begin
                sum_reg += number;
                $display("The number is: %d", number);
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
    logic result;

    case (fig_num)
        1: result = len_1(id);
        2: result = len_2(id);
        3: result = len_3(id);
        4: result = len_4(id);
        5: result = len_5(id);
        6: result = len_6(id);
        7: result = len_7(id);
        8: result = len_8(id);
        9: result = len_9(id);
        10: result = len_10(id);
        11: result = len_11(id);
        12: result = len_12(id);
        13: result = len_13(id);
        14: result = len_14(id);
        15: result = len_15(id);
        16: result = len_16(id);
        17: result = len_17(id);
        18: result = len_18(id);
        19: result = len_19(id);
        default: result = 1;
    endcase

    return result; 

endfunction

function logic len_1(input [63:0] id);
    return 1;
endfunction

function logic len_2 (input [63:0] id);
    logic [31:0] val [0:1];
    val[0] = id / 10;
    val[1] = id % 10;
    if (val[0] == val[1]) return 0;
    else return 1;
endfunction

function logic len_3 (input [63:0] id);
    logic [31:0] val [0:2];
    logic equal;
    val[0] = id / 100;
    val[1] = (id / 10) % 10;
    val[2] = id % 10;
    equal = 1;
    for (int i = 1; i < 3; i++) begin
        equal &= (val[i] == val[0]);
    end

    if (equal) begin
        $display("numbers are: %0d, %0d, %0d", val[0], val[1], val[2]);
        return 0;
    end
    return 1;
endfunction

function logic len_4 (input [63:0] id);
    logic [31:0] val [0:5];
    logic eq0123, eq45;
    val[0] = id / 1000;
    val[1] = (id / 100) % 10;
    val[2] = (id / 10) % 10;
    val[3] = id % 10;

    val[4] = id / 100;
    val[5] = id % 100;

    eq0123 = (val[0] == val[1]) &&
             (val[1] == val[2]) &&
             (val[2] == val[3]);

    eq45 = (val[4] == val[5]);

    return (eq0123 || eq45) ? 0 : 1;
endfunction

function logic len_5 (input [63:0] id);
    logic [31:0] val [0:4];
    logic all_equal;
    val[0] = id / 10000;
    val[1] = (id / 1000) % 10;
    val[2] = (id / 100) % 10;
    val[3] = (id / 10) % 10;
    val[4] = id % 10;

    all_equal = 1;
    for (int i = 1; i < 5; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;
endfunction

function logic len_6 (input [63:0] id);
    logic [31:0] val [0:10];
    logic eq0_5, eq6_7, eq8_10;
    val[0] = id / 100000;
    val[1] = (id / 10000) % 10;
    val[2] = (id / 1000) % 10;
    val[3] = (id / 100) % 10;
    val[4] = (id / 10) % 10;
    val[5] = id % 10;

    val[6] = id / 1000;
    val[7] = id % 1000;

    val[8] = id / 10000;
    val[9] = (id / 100) % 100;
    val[10] = id % 100;

    eq0_5 = 1;
    for (int i = 1; i <= 5; i++) eq0_5 &= (val[i] == val[0]);

    eq6_7 = (val[6] == val[7]);

    eq8_10 = (val[8] == val[9]) && (val[9] == val[10]);

    return (eq0_5 || eq6_7 || eq8_10) ? 0 : 1;
endfunction

function logic len_7 (input [63:0] id);
    logic [31:0] val [0:6];
    logic all_equal;
    val[0] = id / 1000000;
    val[1] = (id / 100000) % 10;
    val[2] = (id / 10000) % 10;
    val[3] = (id / 1000) % 10;
    val[4] = (id / 100) % 10;
    val[5] = (id / 10) % 10;
    val[6] = id % 10;

    all_equal = 1;
    for (int i = 1; i < 7; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;
endfunction

function logic len_8 (input [63:0] id);
    logic [31:0] val [0:13];
    logic eq0_7, eq8_9, eq10_13;
    val[0] = id / 10000000;
    val[1] = (id / 1000000) % 10;
    val[2] = (id / 100000) % 10;
    val[3] = (id / 10000) % 10;
    val[4] = (id / 1000) % 10;
    val[5] = (id / 100) % 10;
    val[6] = (id / 10) % 10;
    val[7] = id % 10;

    val[8] = id / 10000;
    val[9] = id % 10000;

    val[10] = id / 1000000;
    val[11] = (id / 10000) % 100;
    val[12] = (id / 100) % 100;
    val[13] = id % 100;

    eq0_7 = 1;
    for (int i = 1; i <= 7; i++) eq0_7 &= (val[i] == val[0]);

    eq8_9 = (val[8] == val[9]);

    eq10_13 = 1;
    for (int i = 11; i <= 13; i++) eq10_13 &= (val[i] == val[10]);

    return (eq0_7 || eq8_9 || eq10_13) ? 0 : 1;
endfunction

function logic len_9 (input [63:0] id);
    logic [31:0] val [0:11];
    logic eq0_8, eq9_11;

    val[0] = id / 100000000;
    val[1] = (id / 10000000) % 10;
    val[2] = (id / 1000000) % 10;
    val[3] = (id / 100000) % 10;
    val[4] = (id / 10000) % 10;
    val[5] = (id / 1000) % 10;
    val[6] = (id / 100) % 10;
    val[7] = (id / 10) % 10;
    val[8] = id % 10;

    val[9] = id / 1000000;
    val[10] = (id / 1000) % 1000;
    val[11] = id % 1000;

    eq0_8 = 1;
    for (int i = 1; i <= 8; i++) eq0_8 &= (val[i] == val[0]);

    eq9_11 = 1;
    for (int i = 10; i <= 11; i++) eq9_11 &= (val[i] == val[9]);

    return (eq0_8 || eq9_11) ? 0 : 1;

endfunction

function logic len_10 (input [63:0] id);
    logic [31:0] val [0:16];
    logic eq0_9, eq10_11, eq12_16;

    val[0] = id / 1000000000;
    val[1] = (id / 100000000) % 10; 
    val[2] = (id / 10000000) % 10;
    val[3] = (id / 1000000) % 10;
    val[4] = (id / 100000) % 10;
    val[5] = (id / 10000) % 10;
    val[6] = (id / 1000) % 10;
    val[7] = (id / 100) % 10;
    val[8] = (id / 10) % 10;
    val[9] = id % 10;

    val[10] = id / 100000;
    val[11] = id % 100000;

    val[12] = id / 100000000;
    val[13] = (id / 1000000) % 100;
    val[14] = (id / 10000) % 100;
    val[15] = (id / 100) % 100;
    val[16] = id % 100;

    eq0_9 = 1;
    for (int i = 1; i <= 9; i++) eq0_9 &= (val[i] == val[0]);

    eq10_11 = (val[10] == val[11]);

    eq12_16 = 1;
    for (int i = 13; i <= 16; i++) eq12_16 &= (val[i] == val[12]);

    return (eq0_9 || eq10_11 || eq12_16) ? 0 : 1;


endfunction

function logic len_11 (input [63:0] id);
 logic [31:0] val [0:10];
 logic all_equal;

    val[0] = id / P10_10;
    val[1] = (id / 1000000000) % 10; 
    val[2] = (id / 100000000) % 10;
    val[3] = (id / 10000000) % 10;
    val[4] = (id / 1000000) % 10;
    val[5] = (id / 100000) % 10;
    val[6] = (id / 10000) % 10;
    val[7] = (id / 1000) % 10;
    val[8] = (id / 100) % 10;
    val[9] = (id / 10) % 10;
    val[10] = id % 10;

    all_equal = 1;
    for (int i = 1; i <= 10; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;   
endfunction

function logic len_12 (input [63:0] id);
    logic [31:0] val [0:26];
    logic eq0_11, eq12_13, eq14_19, eq20_22, eq23_26;
    val[0] = id / P10_11;
    val[1] = (id / P10_10) % 10;
    val[2] = (id / 1000000000) % 10;
    val[3] = (id / 100000000) % 10;
    val[4] = (id / 10000000) % 10;
    val[5] = (id / 1000000) % 10;
    val[6] = (id / 100000) % 10;
    val[7] = (id / 10000) % 10;
    val[8] = (id / 1000) % 10;
    val[9] = (id / 100) % 10;
    val[10] = (id / 10) % 10;
    val[11] = id % 10;

    val[12] = id / 1000000;
    val[13] = id % 1000000;

    val[14] = id / P10_10;
    val[15] = (id / 100000000) % 100;
    val[16] = (id / 1000000) % 100;
    val[17] = (id / 10000) % 100;
    val[18] = (id / 100) % 100;
    val[19] = id % 100;

    val[20] = id / 100000000;
    val[21] = (id / 10000) % 10000;
    val[22] = id % 10000;

    val[23] = id / 1000000000;
    val[24] = (id / 1000000) % 1000;
    val[25] = (id / 1000) % 1000;
    val[26] = id % 1000;

    eq0_11 = 1;
    for (int i = 1; i <= 11; i++) eq0_11 &= (val[i] == val[0]);

    eq12_13 = (val[12] == val[13]);

    eq14_19 = 1;
    for (int i = 15; i <= 19; i++) eq14_19 &= (val[i] == val[14]);

    eq20_22 = 1;
    for (int i = 21; i <= 22; i++) eq20_22 &= (val[i] == val[20]);

    eq23_26 = 1;
    for (int i = 24; i <= 26; i++) eq23_26 &= (val[i] == val[23]);

    return (eq0_11 || eq12_13 || eq14_19 || eq20_22 || eq23_26) ? 0 : 1;


endfunction

function logic len_13 (input [63:0] id);
    logic [31:0] val [0:12];
    logic all_equal;
    val[0] = id / P10_12;
    val[1] = (id / P10_11) % 10;
    val[2] = (id / P10_10) % 10;
    val[3] = (id / 1000000000) % 10;
    val[4] = (id / 100000000) % 10;
    val[5] = (id / 10000000) % 10;
    val[6] = (id / 1000000) % 10;
    val[7] = (id / 100000) % 10;
    val[8] = (id / 10000) % 10;
    val[9] = (id / 1000) % 10;
    val[10] = (id / 100) % 10;
    val[11] = (id / 10) % 10;
    val[12] = id % 10;

    all_equal = 1;
    for (int i = 1; i <= 12; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;

endfunction

function logic len_14 (input [63:0] id);
    logic [31:0] val [0:22];
    logic eq0_13, eq14_15, eq16_22;

    val[0] = id / P10_13;
    val[1] = (id / P10_12) % 10;
    val[2] = (id / P10_11) % 10;
    val[3] = (id / P10_10) % 10;
    val[4] = (id / 1000000000) % 10;
    val[5] = (id / 100000000) % 10;
    val[6] = (id / 10000000) % 10;
    val[7] = (id / 1000000) % 10;
    val[8] = (id / 100000) % 10;
    val[9] = (id / 10000) % 10;
    val[10] = (id / 1000) % 10;
    val[11] = (id / 100) % 10;
    val[12] = (id / 10) % 10;
    val[13] = id % 10;

    val[14] = id / 10000000;
    val[15] = id % 10000000;

    val[16] = id / P10_12;
    val[17] = (id / P10_10) % 100;
    val[18] = (id / 100000000) % 100;
    val[19] = (id / 1000000) % 100;
    val[20] = (id / 10000) % 100;
    val[21] = (id / 100) % 100;
    val[22] = id % 100;

    eq0_13 = 1;
    for (int i = 1; i <= 13; i++) eq0_13 &= (val[i] == val[0]);

    eq14_15 = (val[14] == val[15]);

    eq16_22 = 1;
    for (int i = 17; i <= 22; i++) eq16_22 &= (val[i] == val[16]);

    return (eq0_13 || eq14_15 || eq16_22) ? 0 : 1;
endfunction


function logic len_15 (input [63:0] id);
    logic [31:0] val [0:22];
    logic eq0_14, eq15_19, eq20_22;

    val[0] = id / P10_14;
    val[1] = (id / P10_13) % 10;
    val[2] = (id / P10_12) % 10;
    val[3] = (id / P10_11) % 10;
    val[4] = (id / P10_10) % 10;
    val[5] = (id / 1000000000) % 10;
    val[6] = (id / 100000000) % 10;
    val[7] = (id / 10000000) % 10;
    val[8] = (id / 1000000) % 10;
    val[9] = (id / 100000) % 10;
    val[10] = (id / 10000) % 10;
    val[11] = (id / 1000) % 10;
    val[12] = (id / 100) % 10;
    val[13] = (id / 10) % 10;
    val[14] = id % 10;

    val[15] = id / P10_12;
    val[16] = (id / 1000000000) % 1000;
    val[17] = (id / 1000000) % 1000;
    val[18] = (id / 1000) % 1000;
    val[19] = id % 1000;

    val[20] = id / P10_10;
    val[21] = (id / 100000) % 100000;
    val[22] = id % 100000;

    eq0_14 = 1;
    for (int i = 1; i <= 14; i++) eq0_14 &= (val[i] == val[0]);

    eq15_19 = 1;
    for (int i = 16; i <= 19; i++) eq15_19 &= (val[i] == val[15]);

    eq20_22 = 1;
    for (int i = 21; i <= 22; i++) eq20_22 &= (val[i] == val[20]);

    return (eq0_14 || eq15_19 || eq20_22) ? 0 : 1;



endfunction

function logic len_16 (input [63:0] id);
    logic [31:0] val [0:29];
    logic eq0_15, eq16_17, eq18_25, eq26_29;

    val[0] = id / P10_15;
    val[1] = (id / P10_14) % 10;
    val[2] = (id / P10_13) % 10;
    val[3] = (id / P10_12) % 10;
    val[4] = (id / P10_11) % 10;
    val[5] = (id / P10_10) % 10;
    val[6] = (id / 1000000000) % 10;
    val[7] = (id / 100000000) % 10;
    val[8] = (id / 10000000) % 10;
    val[9] = (id / 1000000) % 10;
    val[10] = (id / 100000) % 10;
    val[11] = (id / 10000) % 10;
    val[12] = (id / 1000) % 10;
    val[13] = (id / 100) % 10;
    val[14] = (id / 10) % 10;
    val[15] = id % 10;

    val[16] = id / 100000000;
    val[17] = id % 100000000;

    val[18] = id / P10_14;
    val[19] = (id / P10_12) % 100;
    val[20] = (id / P10_10) % 100;
    val[21] = (id / 100000000) % 100;
    val[22] = (id / 1000000) % 100;
    val[23] = (id / 10000) % 100;
    val[24] = (id / 100) % 100;
    val[25] = id % 100;

    val[26] = id / P10_12;
    val[27] = (id / 100000000) % 10000;
    val[28] = (id / 10000) % 10000;
    val[29] = id % 10000;

    eq0_15 = 1;
    for (int i = 1; i <= 15; i++) eq0_15 &= (val[i] == val[0]);

    eq16_17 = (val[16] == val[17]);

    eq18_25 = 1;
    for (int i = 19; i <= 25; i++) eq18_25 &= (val[i] == val[18]);

    eq26_29 = 1;
    for (int i = 27; i <= 29; i++) eq26_29 &= (val[i] == val[26]);

    return (eq0_15 || eq16_17 || eq18_25 || eq26_29) ? 0 : 1;


endfunction

function logic len_17 (input [63:0] id);
    logic [31:0] val [0:16];
    logic all_equal;

    val[0] = id / P10_16;
    val[1] = (id / P10_15) % 10;
    val[2] = (id / P10_14) % 10;
    val[3] = (id / P10_13) % 10;
    val[4] = (id / P10_12) % 10;
    val[5] = (id / P10_11) % 10;
    val[6] = (id / P10_10) % 10;
    val[7] = (id / 1000000000) % 10;
    val[8] = (id / 100000000) % 10;
    val[9] = (id / 10000000) % 10;
    val[10] = (id / 1000000) % 10;
    val[11] = (id / 100000) % 10;
    val[12] = (id / 10000) % 10;
    val[13] = (id / 1000) % 10;
    val[14] = (id / 100) % 10;
    val[15] = (id / 10) % 10;
    val[16] = id % 10;

    all_equal = 1;
    for (int i = 1; i <= 16; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;


endfunction

function logic len_18 (input [63:0] id);
    logic [31:0] val [0:37];
    logic eq0_17, eq18_19, eq20_28, eq29_31, eq32_37;

    val[0] = id / P10_17;
    val[1] = (id / P10_16) % 10;
    val[2] = (id / P10_15) % 10;
    val[3] = (id / P10_14) % 10;
    val[4] = (id / P10_13) % 10;
    val[5] = (id / P10_12) % 10;
    val[6] = (id / P10_11) % 10;
    val[7] = (id / P10_10) % 10;
    val[8] = (id / 1000000000) % 10;
    val[9] = (id / 100000000) % 10;
    val[10] = (id / 10000000) % 10;
    val[11] = (id / 1000000) % 10;
    val[12] = (id / 100000) % 10;
    val[13] = (id / 10000) % 10;
    val[14] = (id / 1000) % 10;
    val[15] = (id / 100) % 10;
    val[16] = (id / 10) % 10;
    val[17] = id % 10;

    val[18] = id / 1000000000;
    val[19] = id % 1000000000;

    val[20] = id / P10_16;
    val[21] = (id / P10_14) % 100;
    val[22] = (id / P10_12) % 100;
    val[23] = (id / P10_10) % 100;
    val[24] = (id / 100000000) % 100;
    val[25] = (id / 1000000) % 100;
    val[26] = (id / 10000) % 100;
    val[27] = (id / 100) % 100;
    val[28] = id % 100;

    val[29] = id / P10_12;
    val[30] = (id / 1000000) % 1000000;
    val[31] = id % 1000000;

    val[32] = id / P10_15;
    val[33] = (id / P10_12) % 1000;
    val[34] = (id / 1000000000) % 1000;
    val[35] = (id / 1000000) % 1000;
    val[36] = (id / 1000) % 1000;
    val[37] = id % 1000;

    eq0_17 = 1;
    for (int i = 1; i <= 17; i++) eq0_17 &= (val[i] == val[0]);

    eq18_19 = (val[18] == val[19]);

    eq20_28 = 1;
    for (int i = 21; i <= 28; i++) eq20_28 &= (val[i] == val[20]);

    eq29_31 = 1;
    for (int i = 30; i <= 31; i++) eq29_31 &= (val[i] == val[29]);

    eq32_37 = 1;
    for (int i = 33; i <= 37; i++) eq32_37 &= (val[i] == val[32]);

    return (eq0_17 || eq18_19 || eq20_28 || eq29_31 || eq32_37) ? 0 : 1;

endfunction

function logic len_19 (input [63:0] id);
    logic [31:0] val [0:18];
    logic all_equal;

    val[0] = id / P10_18;
    val[1] = (id / P10_17) % 10;
    val[2] = (id / P10_16) % 10;
    val[3] = (id / P10_15) % 10;
    val[4] = (id / P10_14) % 10;
    val[5] = (id / P10_13) % 10;
    val[6] = (id / P10_12) % 10;
    val[7] = (id / P10_11) % 10;
    val[8] = (id / P10_10) % 10;
    val[9] = (id / 1000000000) % 10;
    val[10] = (id / 100000000) % 10;
    val[11] = (id / 10000000) % 10;
    val[12] = (id / 1000000) % 10;
    val[13] = (id / 100000) % 10;
    val[14] = (id / 10000) % 10;
    val[15] = (id / 1000) % 10;
    val[16] = (id / 100) % 10;
    val[17] = (id / 10) % 10;
    val[18] = id % 10;

    all_equal = 1;
    for (int i = 1; i <= 18; i++) all_equal &= (val[i] == val[0]);

    return all_equal ? 0 : 1;

endfunction

function logic len_20 (input [63:0] id);
    logic [31:0] val [0:40];
    logic eq0_19, eq20_21, eq22_31, eq32_35, eq36_40;

    val[0] = id / P10_19;
    val[1] = (id / P10_18) % 10;
    val[2] = (id / P10_17) % 10;
    val[3] = (id / P10_16) % 10;
    val[4] = (id / P10_15) % 10;
    val[5] = (id / P10_14) % 10;
    val[6] = (id / P10_13) % 10;
    val[7] = (id / P10_12) % 10;
    val[8] = (id / P10_11) % 10;
    val[9] = (id / P10_10) % 10;
    val[10] = (id / 1000000000) % 10;
    val[11] = (id / 100000000) % 10;
    val[12] = (id / 10000000) % 10;
    val[13] = (id / 1000000) % 10;
    val[14] = (id / 100000) % 10;
    val[15] = (id / 10000) % 10;
    val[16] = (id / 1000) % 10;
    val[17] = (id / 100) % 10;
    val[18] = (id / 10) % 10;
    val[19] = id % 10;

    val[20] = id / P10_10;
    val[21] = id % P10_10;

    val[22] = id / P10_18;
    val[23] = (id / P10_16) % 100;
    val[24] = (id / P10_14) % 100;
    val[25] = (id / P10_12) % 100;
    val[26] = (id / P10_10) % 100;
    val[27] = (id / 100000000) % 100;
    val[28] = (id / 1000000) % 100;
    val[29] = (id / 10000) % 100;
    val[30] = (id / 100) % 100;
    val[31] = id % 100;

    val[32] = id / P10_15;
    val[33] = (id / P10_10) % 100000;
    val[34] = (id / 100000) % 100000;
    val[35] = id % 100000;

    val[36] = id / P10_16;
    val[37] = (id / P10_12) % 10000;
    val[38] = (id / 100000000) % 10000;
    val[39] = (id / 10000) % 10000;
    val[40] = id % 10000;

    eq0_19  = 1;
    for (int i = 1; i <= 19; i++) eq0_19 &= (val[i] == val[0]);

    eq20_21 = (val[20] == val[21]);

    eq22_31 = 1;
    for (int i = 23; i <= 31; i++) eq22_31 &= (val[i] == val[22]);

    eq32_35 = 1;
    for (int i = 33; i <= 35; i++) eq32_35 &= (val[i] == val[32]);

    eq36_40 = 1;
    for (int i = 37; i <= 40; i++) eq36_40 &= (val[i] == val[36]);

    return (eq0_19 || eq20_21 || eq22_31 || eq32_35 || eq36_40) ? 0 : 1;


endfunction

endmodule