This README describes the solution for puzzle number 3.

In this puzzle, the two parts differ in how the input data is processed. In both of them, a new 4-bit number arrives on each clock cycle, while voltages are sent from certain banks. Once all values are read from a bank, the wr_en signal goes low. This acts as a flag indicating that a new sum should be generated.

In the first part, there are only two registers that track which numbers are coming in and how large they are compared to the values already stored. Using a simple sorting approach, each input value can become either the first or the second digit. When no data is being sent (wr_en is low), a new sum is calculated by adding the old sum to the highest possible number from the processed bank.

The second part is more complicated because it requires 12 registers to process the input data. The generation of the most optimal number also happens only when wr_en is low. All input values are stored in the logic [3:0] bank [0:127] array. The maximum size of 128 entries was chosen, but this can be adjusted depending on the capacity of the banks. Each digit in the final voltage for each bank is chosen in order within the possible range, starting from the most significant digit. The possible range depends on how many voltages are present in the bank.

Overall, both systems meet the requirements, but the second part strongly depends on how fast all registers can be compared and on the speed of the final arithmetic.