// File name:machine_lang_code/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@R2
M=0;
@i
M=0;
@sum
M=0;
(begin_of_loop)
  @i
  D=M;
  @R1
  D=D-M;
  @end_of_loop
  D; JGE // if(i>=R1) end_of_loop
  @R0
  D=M;
  @sum
  M=D+M; 
  @i
  M=M+1;
@begin_of_loop
0; JMP
(end_of_loop)
@sum
D=M;
@R2
M=D;
(end)
@end
0; JMP
