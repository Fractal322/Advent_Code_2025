`timescale  1ns / 1ps
module puzzle3_1_tb ();
reg clk;
reg rst_n;
reg [3:0] data_in;
reg wr_en;
reg bank_end;
wire [31:0] sum;

puzzle3_1 uut (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .wr_en(wr_en),
    .bank_end(bank_end),
    .sum(sum)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

integer input_file;
string line;
int number;

initial begin
    rst_n = 0;
    data_in = 0;
    wr_en = 0;
    bank_end = 0;
    input_file = $fopen("puzzle3_1.txt", "r");
    if (input_file == 0) begin
        $display("Failed to open input file.");
        $finish;
    end
    #10;
    rst_n = 1;

    while (!$feof(input_file)) begin
        void'($fgets(line, input_file));
        wr_en = 1;

        for (int i = 0; i < line.len(); i = i + 1) begin
            if (line[i+1] == "\n" || line[i+1] == "\r") begin
                bank_end = 1;
            end else begin
                bank_end = 0;
            end
            if (line[i] == "\n" || line[i] == "\r") begin
                wr_en = 0;
                data_in = 0;
                #10;
                continue;
            end
            data_in = line[i];
            data_in = data_in - "0"; // Convert ASCII to integer
            #10;
        end

        wr_en = 0;
        data_in = 0;
    end
    $fclose(input_file);
    #10;
    $display("Final sum: %0d", sum);
    $finish;
       
end

endmodule