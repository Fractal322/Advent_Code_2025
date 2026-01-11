module puzzle1_1(
    input clk,
    input reset,
    input [16:0] data_in,

    output logic [10:0] password_reg
);

logic [6:0] direction;
logic [9:0] shift;
logic [9:0] shift_reg;
logic [7:0] position;
logic [7:0] position_tmp;
logic [10:0] password;
logic [6:0] position_reg;

logic [6:0] tmp;
logic [19:0] tmp_calc;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 10'b0;
        direction <= 8'b0;
        password_reg <= 8'b0;
        position_reg <= 50;
    end else begin
        direction <= data_in[16:10];
        shift_reg <= data_in[9:0];
        position_reg <= position;
        password_reg <= password;
    end
end 


always_comb begin
    position = position_reg;
    password = password_reg;


    if (shift_reg > 99) begin
        tmp_calc = shift_reg * 656;
        shift = shift_reg - (100 * (tmp_calc >> 16));
        tmp = shift;
    end
    else tmp = shift_reg;

    if (direction == 82) begin // right rotation
        position_tmp = position + tmp;
        if (position_tmp > 99) begin
            position = position_tmp - 100;
        end else begin
            position = position + tmp;
        end

        password = (position == 0) ? (password + 1) : password;
    end

    else if (direction == 76) begin // left rotation
        if (position < tmp) begin
            position_tmp = 100 + position;
            position = position_tmp - tmp;
        end else begin
            position = position - tmp;
        end

         password = (position == 0) ? (password + 1) : password;
    end
end

endmodule