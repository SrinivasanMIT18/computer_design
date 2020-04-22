// File name:machine_lang_code/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

@16384
D=A;
@s_addr
M=D; //s_addr =16384
@24576
D=A;
@e_addr
M=D; //e_addr =24576

(INF_LOOP)
  @KBD
  D=M;
  @INIT_SET_TO_0
  D; JEQ // if(kbd==0) then INIT_SET_TO_0
  @s_addr
  D=M;
  @i
  M=D;
  (BEGIN_SET_TO_1)
    @i
    D=M;
    @e_addr
    D=D-M;
    @INF_LOOP
    D; JGE // if(i>=24576) then all entry of screen are filled with 1
           // goto INF_LOOP
    @i
    D=M;
    A=D;
    M=-1; // Ram[i] = all_1's
    @i
    M=M+1;
  @BEGIN_SET_TO_1
  0; JMP
  (INIT_SET_TO_0)
  @s_addr
  D=M;
  @i
  M=D;
  (BEGIN_SET_TO_0)
    @i
    D=M;
    @e_addr
    D=D-M;
    @INF_LOOP
    D; JGE // if(i>=24576) then all entry of screen are filled with 0
           // goto INF_LOOP
    @i
    D=M;
    A=D;
    M=0; // Ram[i] = all_0's
    @i
    M=M+1;
  @BEGIN_SET_TO_0
  0; JMP
