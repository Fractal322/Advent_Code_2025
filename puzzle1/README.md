This README describes the solution for puzzle number 1.

The input data is read from a text file in the testbench. A new input line is read on every fresh clock cycle. Letters are processed using ASCII encoding. The new position after each rotation is also calculated within one clock cycle in both parts.

In the first part, fixed-point division (lines 41–43) is used for the position calculation, which helps to reduce resource usage. While processing the input data, two cases are considered: rotation below 99 and rotation above 100, because in the first case the dial reaches the starting position at least once.

The second part, unfortunately, requires more arithmetic resources because the remainder must be calculated. Using this remainder, the number of 100-rotations (when the dial returns to the original position) can be determined.

Overall, the performance depends on the number of rotations, since all lines are processed in series. However, using only two registers — a 17-bit input and an 11-bit output — keeps the number of external pins low. In addition, the most complex arithmetic block required is only a 10-bit multiplier.