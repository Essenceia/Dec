# Decoder 

Decoder logic, output is returned withing the same clock cycle.

![Decoder waves!](/doc/wave.png)

## Instructions 

![Occurence rate of instructions!](/doc/plot/instr.png)

## RTL 

|instr|dst reg|src reg|src addr|inst logic|op min|op max|op min bin|op max bin|bit mask|notes|
| --- | ---- | ------ | ----- | -------- | ----- | ---- | -------- | ------- | ------ | ---- |
|IADD_RS|R|R|src = dst|dst = dst + (src << mod.shift) (+ imm32)|0|15|0|1111| 0000XXXX \| 0XXX_XXXX & ~0111_11XX|0,2578125|
|IADD_M|R|R|src = 0|dst = dst + [mem]|16|22|10000|10110 | 00010XXX & ~XXXXX111||
|ISUB_R|R|R|src = imm32|dst = dst - src|23|38| 10111 | 100110 | 0001_0111 \| 0001_1XXX \| ( XX10_0XXX & ~ XXXX_X111 )||
|ISUB_M|R|R|src = 0|dst = dst - [mem]|39|45| 100111 | 101101 | 0010_XXXX & ( XXXX_0111 \| ( XXXX_1XXX & ~XXXX_X11X ) ) ||
|IMUL_R|R|R|src = imm32|dst = dst * src|46|61| 101110 | 111101 | 10_111X \| (11_XXXX & ~XX_111X )||
|IMUL_M|R|R|src = 0|dst = dst * [mem]|62|65|111110|1000001|lt64 : 11_111X,  ge64 : 00_000X||
|IMULH_R_|R|R|src = dst|dst = (dst * src) >> 64| 66 | 69 | 1000010 | 1000101 | 00_0XXX & ( 01X \| ( 1XX & ~11X ) ) ||
|IMULH_M|R|R|src = 0|dst = (dst * [mem]) >> 64|70|70|1000110 | 1000110|8'b01000110||
|ISMULH_R|R|R|src = dst|dst = (dst * src) >> 64 (signed)|71|74|1000111 | 1001010 | 00_XXXX & ( 0111 \| ( 10XX & ~11 ) )||
|ISMULH_M|R|R|src = 0|dst = (dst * [mem]) >> 64 (signed)|75|75|1001011|1001011|8'b01001011||
|IMUL_RCP|R|-|-|dst = 2x / imm32 * dst|76|83|1001100|1010011|0X_XXXX & ( X0_11XX \| X1_00XX ) ||
|INEG_R|R|-|-|dst = -dst|84|85|1010100|1010101|8'b0101010X||
|IXOR_R|R|R|src = imm32|dst = dst ^ src|86|100 | 1010110 | 1100100 | ( 01_XXXX & ( 011X \| 1XXX )) \| ( 10_0XXX & ( 0XX \| 100 ))||
|IXOR_M|R|R|src = 0|dst = dst ^ [mem]|101|105| 1100101 | 1101001 | 10_XXXX & ( ( 01XX & ~01 ) \| 100X )||
|IROR_R|R|R|src = imm32|dst = dst >>> src|106|113|1101010|1110001|( 10_1XXX & ~00X ) \| 11_000X||
|IROL_R|R|R|src = imm32|dst = dst <<< src|114|115|1110010|1110011|8'b0111001X||
|ISWAP_R|R|R|src = dst|temp = src; src = dst; dst = temp|116|119|1110100|1110111|8'b011101XX||
|FSWAP_R|F+E|-||(dst0, dst1) = (dst1, dst0)|120|123|1111000|1111011|8'b011110XX||
|FADD_R|F|A||(dst0, dst1) = (dst0 + src0, dst1 + src1)|124|139|1111100|10001011|lt127 : 111_11XX    ge127 :  1000_1011 : 1000_XXXX & ( 0XXX \| 10XX  ) |0111_1100 -> 1101_0101|
|FADD_M|F|R||(dst0, dst1) = (dst0 + [mem][0], dst1 + [mem][1])|140|144|10001100|10010000|100X_XXXX & ( 0_11XX \|  1_000  )||
|FSUB_R|F|A||(dst0, dst1) = (dst0 - src0, dst1 - src1)|145|160|10010001|10100000|10XX_XXXX & ( ( 01_XXXX & ~000X) \| 10_0000 )||
|FSUB_M|F|R||(dst0, dst1) = (dst0 - [mem][0], dst1 - [mem][1])|161|165|10100001|10100101|8'b10100XXX  & ~000 & ~11X|
|FSCAL_R|F|-||(dst0, dst1) = (-2x0 * dst0, -2x1 * dst1)|166|171|10100110|10101011|1010_0110 -> 1010_1011 : 1010_XXXX &  ( 011X \| 10XX )||
|FMUL_R|E|A||(dst0, dst1) = (dst0 * src0, dst1 * src1)|172|203|10101100|11001011|1010_1100 -> 1100_1011 : 1010_11XX \| (1100_XXXX & ~11XX )||
|FDIV_M|E|R||(dst0, dst1) = (dst0 / [mem][0], dst1 / [mem][1])|204|207|11001100|11001111|8'b110011XX||
|FSQRT_R|E|-||(dst0, dst1) = (√dst0, √dst1)|208|213|11010000|11010101|1101_0000 -> 1101_0101 : 1101_XXXX & ( 0XXX & ~X11X )||
|CFROUND|-|R||fprc = src >>> imm32|214|214|11010110|11010110|8'b11010110|1101_0110 -> 1111_1111|
|CBRANCH|R|-||dst = dst + cimm (conditional jump)|215|239|11010111|11101111|1101_0111 -> 1110_1111  :11XX_XXXX  &  ( ( 01_XXXX & ( 1XXX \| 0111 ) ) \|  10_XXXX ) ||
|ISTORE|R|R||[mem] = src|240|255|11110000|11111111|8'b1111XXXX||
