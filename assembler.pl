# Name : assembler.pl
# Author : Sri Srinivasan P
# This script convert assembly code to Machine language code for Hack computer
#!/usr/bin/perl -w
$argCnt = 0;
while ($argCnt < $#ARGV) {
  if ($ARGV[$argCnt] =~ /-i/g) {
    $argCnt = $argCnt + 1;
    $ip_fh = $ARGV[$argCnt];
#    print "$ARGV[$argCnt]";
  }
  if($ARGV[$argCnt] =~ /-h/g) {
    print "This script convert assembly code to Machine language code for Hack computer";
    exit;
  }
  $argCnt = $argCnt + 1;
}

@ip = `cat $ip_fh`;
my @ip_name = split( '\.',$ip_fh) ;
#print "ip_name : $ip_name[0]\n";
$op = "$ip_name[0]" . '.' . "hack";
open($fh,">", $op);
my @arr1 ;
foreach my $line (@ip) {
  if($line =~ /^\/\//) {
  } elsif ($line =~ /^\s*\n/) {
  } else {
#    print "$line";
    push (@arr1,$line);
  }
}
%comp = (
 "0"   ,   "0101010",
 "1"   ,   "0111111",
 "-1"  ,   "0111010",
 "D"   ,   "0001100",
 "A"   ,   "0110000",
 "!D"  ,   "0001101",
 "!A"  ,   "0110001",
 "-D"  ,   "0001111",
 "-A"  ,   "0110011",
 "D+1" ,   "0011111",
 "A+1" ,   "0110111",
 "D-1" ,   "0001110",
 "A-1" ,   "0110010",
 "D+A" ,   "0000010",
 "D-A" ,   "0010011",
 "A-D" ,   "0000111",
 "D&A" ,   "0000000",
 "D|A" ,   "0010101",
 "M"   ,   "1110000",
 "!M"  ,   "1110001",
 "-M"  ,   "1110011",
 "M+1" ,   "1110111",
 "M-1" ,   "1110010",
 "D+M" ,   "1000010",
 "D-M" ,   "1010011",
 "M-D" ,   "1000111",
 "D&M" ,   "1000000",
 "D|M" ,   "1010101"
);

%dest = (
 "null"  ,   "000",
 "M"     ,   "001",
 "D"     ,   "010",
 "MD"    ,   "011",
 "A"     ,   "100",
 "AM"    ,   "101",
 "AD"    ,   "110",
 "AMD"   ,   "111"
);

%jump = (
 "nul"  ,   "000",
 "JGT"  ,   "001",
 "JEQ"  ,   "010",
 "JGE"  ,   "011",
 "JLT"  ,   "100",
 "JNE"  ,   "101",
 "JLE"  ,   "110",
 "JMP"  ,   "111"
);

%sym_val = (
  "R0"     , "0", 
  "R1"     , "1", 
  "R2"     , "2", 
  "R3"     , "3", 
  "R4"     , "4", 
  "R5"     , "5", 
  "R6"     , "6", 
  "R7"     , "7", 
  "R8"     , "8", 
  "R9"     , "9", 
  "R10"    , "10", 
  "R11"    , "11", 
  "R12"    , "12", 
  "R13"    , "13", 
  "R14"    , "14", 
  "R15"    , "15",
  "SCREEN" , "16384",
  "KBD"    , "24576",
  "SP"     , "0",
  "LCL"    , "1",
  "ARG"    , "2",
  "THIS"   , "3",
  "THAT"   , "4"
);
my @arr_in1;
my $inst_no = 0;
foreach my $line (@arr1) {
  if($line =~ /\((\S+)\)/) {
#    print "$1 : $inst_no\n";
    $sym_val{$1} = $inst_no ;
  } else {
#    print "$inst_no : $line";
    push (@arr_in1, $line);
    $inst_no = $inst_no +1;
  }
}

my @arr_in2;
my $var_addr = 16;
foreach my $line (@arr_in1) {
#  print "$line";
  chomp $line ;
  if($line =~ /\@\d+/) {
#    print "$line\n";
    push (@arr_in2, $line);
  } elsif ($line =~ /\@(\S+)/) {
#    print "Symbol : $1\n";
    my $cur_sym = $1;
    if (exists($sym_val{$1})) {
#      print "$1 : $sym_val{$1} exists already!\n";
      my $tmp = "@" . "$sym_val{$1}";
      push (@arr_in2,$tmp);
    } else {
#      print "$line : $var_addr\n";
      $sym_val{$1} = $var_addr ;
      my $tmp = "@" . "$var_addr";
      push (@arr_in2,$tmp);
      $var_addr = $var_addr + 1;
    }
  } else {
    push (@arr_in2, $line);
  }
}

#while ( ($k,$v) = each %sym_val) {
#  print "$k => $v \n";
#}

foreach my $line (@arr_in2) {
  print "$line\n";
#  chomp $line;
  if($line =~ /^\s*\@(\d+)/) {
#    print "$line\n";
#    print "$1\n";
    my $bin = sprintf ("%0*b",16, $1);
#    print  "$bin\n";
#    my $tmp = "@" . "$bin";
    push (@arr2, $bin);
  } else {
     if($line =~ /^\s*(\S+)\s*=\s*(\S+)\s*;\s*(\S+)/) {
#       print "case :1\n";
#       print "Comp : $2\n";
#       print "Dest : $1\n";
#       print "Jump : $3\n";
       my $code  = "111" . "$comp{$2}" . "$dest{$1}" . "$jump{$3}";
#       print  "$code\n";
       push (@arr2, $code);
     } elsif($line =~ /^\s*(\S+)\s*=\s*(\S+)\s*/) {
#       print "case :2\n";
#       print "Comp : $2\n";
#       print "Dest : $1\n";
       my $code  = "111" . "$comp{$2}" . "$dest{$1}" . "000";
#       print  "$code\n";
       push (@arr2, $code);
     } elsif($line =~ /^\s*(\S+)\s*;\s*(\S+)\s*/) {
#       print "case :2\n";
#       print "Comp : $1\n";
#       print "Jump : $2\n";
       my $code  = "111" . "$comp{$1}" . "000" . "$jump{$2}";
#       print  "$code\n";
       push (@arr2, $code);
     }
  }
}

foreach $line (@arr2) {
  print $fh "$line\n";
}
