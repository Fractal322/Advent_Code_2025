`timescale  1ns / 1ps
module puzzle1_2_tb ();
reg clk;
reg reset;
reg [16:0] data_in;
reg wr_en;
wire [31:0] password_reg;

puzzle1_2 uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .wr_en(wr_en),
    .password_reg(password_reg)  
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

integer input_file;
string line;
reg [6:0] letter;
int number;

initial begin
    reset = 1;
    data_in = 18'b0;
    wr_en = 0;
    #15;
    reset = 0;
    input_file = $fopen("input_data_2.txt", "r");
    if (input_file == 0) begin
        $display("Failed to open input file.");
        $finish;
    end

   
end



initial begin
    #20; // Wait for file to open in previous initial block
    while (!$feof(input_file)) begin
        wr_en = 1;
        void'($fgets(line, input_file));
        void'($sscanf(line, "%1s%0d", letter, number));
        $display("Read line: %s. Letter - %1s. Number - %0d. Position - %d", line, letter, number, uut.position);

        data_in = {letter, number[9:0]};
        if (uut.tmp != (uut.shift_reg % 100)) begin
            $display("Error: tmp calculation incorrect. tmp: %0d, expected: %0d", uut.tmp, uut.shift_reg % 100);
            $finish;
        end
        #10; // Wait for one clock cycle
    end
    $fclose(input_file);
    wr_en = 0;
    #10;
    $display("Final password: %0d", password_reg);
    $finish;
end


endmodule