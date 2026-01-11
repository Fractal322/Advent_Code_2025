`timescale  1ns / 1ps
module puzzle2_1_tb ();
reg clk;
reg reset;
reg wr_en;
reg [63:0] id1;
reg [63:0] id2;
wire valid;
wire [63:0] sum;

string line;
int file_rd;
string pairs[$];
integer data_file;


initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

puzzle2_1 uut (
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .id1(id1),
    .id2(id2),
    .valid(valid),
    .sum(sum)  
);

initial begin
    reset = 1;
    id1 = 64'b0;
    id2 = 64'b0;
    wr_en = 0;
    file_rd = 0;
    #15;
    reset = 0;

    data_file = $fopen("C:/Users/egorp/IC_design_projects/ADVENT_CHALLENGE/puzzle2/puzzle2/puzzle2_1.txt", "r");
    if (data_file == 0) begin
        $display("Failed to open input file.");
        $finish;
    end
    
    while ($fgets(line, data_file) != 0) begin
        string pair_array[$];
        byte line_array[];
        int pos, i;
        string pair;
        
        // Convert string to byte array
        line_array = new[line.len()];
        for (i = 0; i < line.len(); i++) begin
            line_array[i] = line[i];
        end
        
        // Parse comma-separated pairs from the line
        pos = 0;
        pair = "";
        for (i = 0; i < line.len(); i++) begin
            if (line_array[i] == ",") begin
                if (pair.len() > 0) begin
                    pair_array.push_back(pair);
                    pair = "";
                end
            end else begin
                pair = {pair, string'(line_array[i])};
            end
        end
        // Add last pair if exists
        if (pair.len() > 0) begin
            pair_array.push_back(pair);
        end
        
        // Add all pairs from this line to the main array
        foreach (pair_array[i]) begin
            pairs.push_back(pair_array[i]);
            $display("Read pair: %s", pair_array[i]);
        end
    end
    $fclose(data_file);
    file_rd = 1;
    #10;
end

initial begin
    #20; // Wait for file to open in previous initial block
    if (file_rd) begin
       
    foreach (pairs[i]) begin
        if ($sscanf(pairs[i], "%d-%d", id1, id2) == 2) begin
            $display("Pair %0d: a=%0d b=%0d", i, id1, id2);
            wr_en = 1;
            #10;
            wr_en = 0;
            while (!valid) begin
                #10;
            end
            
        end
        else begin
            $error("Parse error in pair %0d: %s", i, pairs[i]);
        end

    end

    
    
    end
    $display("Final sum: %0d", sum);
end


endmodule