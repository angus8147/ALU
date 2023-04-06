ALU

.GLOBAL VGND VDD
.prot
.lib C:\synopsys\cic018.l tt
.unprot

.subckt inv  in  out Vdd  Vgnd
mp0	out	in	Vdd		Vdd		p_18	l=0.18u	w=0.25u
mn0	out	in	Vgnd	Vgnd	n_18	l=0.18u	w=0.25u
.ends

.subckt  nand2  A B  Vout  Vdd  Vgnd
M1 Vout   A Vdd    Vdd 	  p_18  l=0.18u  w=0.25u
M2 Vout   B Vdd    Vdd 	  p_18  l=0.18u  w=0.25u
                                         
M3 Vout   B line34 Vgnd   n_18  l=0.18u  w=0.25u
M4 line34 A Vgnd   Vgnd   n_18  l=0.18u  w=0.25u
.ends

.subckt nor2 Va Vb Vo Vdd Vgnd
M1 Vds Va Vdd Vdd   p_18   l=0.18u w=0.25u 
M2 Vo  Vb Vds Vdd   p_18   l=0.18u w=0.25u 
M3 Vo  Va Vgnd Vgnd n_18   l=0.18u w=0.25u  
M4 Vo  Vb Vgnd Vgnd n_18   l=0.18u w=0.25u  
.ends

.subckt and2 A B Vo Vdd Vgnd
X1 A B Vout Vdd Vgnd nand2
X2 Vout Vo Vdd Vgnd inv
.ends

.subckt or2 A B Vout Vdd Vgnd
X1 A B Vo Vdd Vgnd nor2
X2 Vo Vout Vdd Vgnd inv
.ends

.subckt XOR2 vi1 vi2 vo Vdd Vgnd
Xinv1 vi1 vi1_out Vdd Vgnd inv
Xinv2 vi2 vi2_out Vdd Vgnd inv
Xand1 vi1_out vi2 vand1_out Vdd Vgnd and2
Xand2 vi1 vi2_out vand2_out Vdd Vgnd and2
Xor1  vand1_out vand2_out vo Vdd Vgnd or2
.ends

.subckt half_adder A B C S Vdd Vgnd
X1 A B C Vdd Vgnd and2
X2 A B S Vdd Vgnd XOR2
.ends

.subckt full_adder X Y Ci Co S Vdd Vgnd
X1 X Y vi1 S1_out Vdd Vgnd half_adder
X2 S1_out Ci vi2 S Vdd Vgnd half_adder
X3 vi1 vi2 Co Vdd Vgnd or2
.ends

.subckt and4 A B C D Vout Vdd Vgnd
MP1 Vo A Vdd Vdd p_18 w=0.25u l=0.18u
MP2 Vo B Vdd Vdd p_18 w=0.25u l=0.18u
MP3 Vo C Vdd Vdd p_18 w=0.25u l=0.18u
MP4 Vo D Vdd Vdd p_18 w=0.25u l=0.18u

MN1 Vo D 1    Vgnd  n_18  w=0.25u l=0.18u
MN2 1  C 2    Vgnd  n_18  w=0.25u l=0.18u
MN3 2  B 3    Vgnd  n_18  w=0.25u l=0.18u
MN4 3  A Vgnd Vgnd  n_18  w=0.25u l=0.18u 
X1 Vo Vout Vdd Vgnd inv
.ends

.subckt or4 A B C D Vout Vdd Vgnd  
MP1 1  A   Vdd Vdd p_18 w=0.25u l=0.18u
MP2 2  B    1  Vdd p_18 w=0.25u l=0.18u
MP3 3  C    2  Vdd p_18 w=0.25u l=0.18u
MP4 Vo D    3  Vdd p_18 w=0.25u l=0.18u
MN1 Vo A    Vgnd Vgnd n_18 w=0.25u l=0.18u
MN2 Vo B    Vgnd Vgnd n_18 w=0.25u l=0.18u
MN3 Vo C    Vgnd Vgnd n_18 w=0.25u l=0.18u
MN4 Vo D    Vgnd Vgnd n_18 w=0.25u l=0.18u
X1 Vo Vout Vdd Vgnd inv
.ends

.subckt MUX3 S3 S2 S1 A B X Y Cin newCin Vdd Vgnd 
***control signal
Xcin Cin S3 S3_out Vdd Vgnd or2
XnewCin S3_out newCin Vdd Vgnd inv
Xs2! S2 S2! Vdd Vgnd inv
Xs1! S1 S1! Vdd Vgnd inv

***io i1 i2 i3 
Xi0 A B i0 Vdd Vgnd or2
*i1=A
*i2=A
Xi3 A B! i3 Vdd Vgnd or2

*i4=0
*i5=B
*i6=1
Xi7 B B! Vdd Vgnd inv

Xand0 i0     S3_out  S2! S1! i0_out Vdd Vgnd and4 
Xand1 A      S3_out  S2! S1  i1_out Vdd Vgnd and4 
Xand2 A      S3_out  S2  S1! i2_out Vdd Vgnd and4 
Xand3 i3     S3_out  S2  S1  i3_out Vdd Vgnd and4 

Xand4 Vgnd S3_out S2! S1! i4_out Vdd Vgnd and4
Xand5 B    S3_out S2! S1  i5_out Vdd Vgnd and4
Xand6 Vdd  S3_out S2  S1! i6_out Vdd Vgnd and4
Xand7 B!   S3_out S2  S1  i7_out Vdd Vgnd and4 
Xoutputx  i1_out i2_out i3_out i0_out X Vdd Vgnd or4
Xoutputy  i4_out i5_out i6_out i7_out Y Vdd Vgnd or4

.ends

.subckt ALU A B Cin Cout F S1 S2 S3 
Xmux S3 S2 S1 A B X Y Cin newCin Vdd Vgnd MUX3
Xfull_adder X Y newCin Cout_0 F Vdd Vgnd full_adder
Xand Cout_0 Vgnd Cout Vdd Vgnd and2
C1 F VGND 0.01p $[MIMCAPS] 
.ends

XALU A B Cin Cout F S1 S2 S3 ALU 
v1 A VGND PULSE(0v 1.8v 5n 0.1n 0.1n 4.9n 10n) 
v2 B VGND PULSE(0v 1.8v 5n 0.1n 0.1n 9.9n 20n) 
v3 S1 VGND PULSE(0v 1.8v 5n 0.1n 0.1n 19.9n 40n) 
v4 S2 VGND PULSE(0v 1.8v 5n 0.1n 0.1n 39.9n 80n) 
v5 S3 VGND DC 1.8V 
v6 Cin VGND PULSE(0v 1.8v 5n 0.1n 0.1n 79.9n 160n) 

Vdd  Vdd  0 dc=1.8v
Vgnd Vgnd 0 0

.MEAS TRAN pavg AVG POWER FROM=5.2n TO=161n 
.MEAS TRAN glitch TRIG V(A) VAL=0.3 FALL=3 TARG V(F) VAL=0.3 RISE=2 
.TEMP 27 
.OPTIONS ACCURATE=0 POST=2 
.TRAN 50p 165n 
.END 
