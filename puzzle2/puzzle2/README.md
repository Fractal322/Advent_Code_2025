This README describes the solution for puzzle number 2.

The system designed for this puzzle unfortunately uses a lot of arithmetic resources, and in some cases the calculations can go beyond 32-bit. Similar to puzzle 1, each input range is processed in series, with one range handled per clock cycle. Because of this, the ID range becomes a critical factor when choosing the clock frequency. In both parts, there are two 64-bit inputs, and during each clock cycle every number within the given range is processed. This is not the most efficient algorithm and it is time-consuming, but it is reliable, since it guarantees that every number is checked.

In the first part, each number is split into two separate values if the number of digits is even (otherwise it is not considered), and these two parts are then compared. Integer division and the modulo operation are required for this, and these are the most complex and time-consuming operations in this part.

The second part is even more demanding in terms of arithmetic hardware, because it requires many division and modulo operations. For each value, all possible patterns are considered depending on the length of the input number. The worst case is when processing a number with 20 digits.

Overall, these solutions may not be the most time- or area-efficient, but they ensure that all possible cases and patterns are fully processed.