@ Copyright 2019-2020 Mark Owen
@ http://www.quinapalus.com
@ E-mail: qfp@quinapalus.com
@
@ This file is free software: you can redistribute it and/or modify
@ it under the terms of version 2 of the GNU General Public License
@ as published by the Free Software Foundation.
@
@ This file is distributed in the hope that it will be useful,
@ but WITHOUT ANY WARRANTY; without even the implied warranty of
@ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@ GNU General Public License for more details.
@
@ You should have received a copy of the GNU General Public License
@ along with this file.  If not, see <http://www.gnu.org/licenses/> or
@ write to the Free Software Foundation, Inc., 51 Franklin Street,
@ Fifth Floor, Boston, MA  02110-1301, USA.

.syntax unified
.cpu cortex-m0plus
.thumb

@ exported symbols

.global __aeabi_fadd
.global __aeabi_fsub
.global __aeabi_fmul
.global __aeabi_fdiv
.global qfp_fcmp
.global _fsqrt
.global _ffix
.global qfp_float2fix
.global _ffixu
.global qfp_float2ufix
.global _fflt
.global qfp_fix2float
.global _ffltu
.global qfp_ufix2float
.global _ll_sto_f
.global qfp_fix642float
.global _ll_uto_f
.global qfp_ufix642float
@ .global qfp_fcos
@ .global qfp_fsin
@ .global qfp_ftan
@ .global qfp_fatan2
@ .global qfp_fexp
@ .global qfp_fln

.global __aeabi_dadd
.global __aeabi_dsub
.global __aeabi_dmul
.global __aeabi_ddiv
.global _dsqrt
@ .global qfp_dcos
@ .global qfp_dsin
@ .global qfp_dtan
@ .global qfp_datan2
@ .global qfp_dexp
@ .global qfp_dln
.global qfp_dcmp

.global _ll_sfrom_f
.global qfp_float2fix64
.global _ll_ufrom_f
.global qfp_float2ufix64

.global _dfix
.global qfp_double2fix
.global _dfixu
.global qfp_double2ufix
.global _ll_sfrom_d
.global qfp_double2fix64
.global _ll_ufrom_d
.global qfp_double2ufix64

.global _dflt
.global qfp_fix2double
.global _dfltu
.global qfp_ufix2double
.global _ll_sto_d
.global qfp_fix642double
.global _ll_uto_d
.global qfp_ufix642double

.global __aeabi_d2f
.global __aeabi_f2d

qfp_lib_start:

@ exchange r0<->r1, r2<->r3
xchxy:
 push {r0,r2,r14}
 mov r0,r1
 mov r2,r3
 pop {r1,r3,r15}

@ IEEE single in r0-> signed (two's complemennt) mantissa in r0 9Q23 (24 significant bits), signed exponent (bias removed) in r2
@ trashes r4; zero, denormal -> mantissa=+/-1, exponent=-380; Inf, NaN -> mantissa=+/-1, exponent=+640
unpackx:
 lsrs r2,r0,#23 @ save exponent and sign
 lsls r0,#9     @ extract mantissa
 lsrs r0,#9
 movs r4,#1
 lsls r4,#23
 orrs r0,r4     @ reinstate implied leading 1
 cmp r2,#255    @ test sign bit
 uxtb r2,r2     @ clear it
 bls 1f         @ branch on positive
 rsbs r0,#0     @ negate mantissa
1:
 subs r2,#1
 cmp r2,#254    @ zero/denormal/Inf/NaN?
 bhs 2f
 subs r2,#126   @ remove exponent bias: can now be -126..+127
 bx r14

2:              @ here with special-case values
 cmp r0,#0
 mov r0,r4      @ set mantissa to +1
 bpl 3f
 rsbs r0,#0     @ zero/denormal/Inf/NaN: mantissa=+/-1
3:
 subs r2,#126   @ zero/denormal: exponent -> -127; Inf, NaN: exponent -> 128
 lsls r2,#2     @ zero/denormal: exponent -> -508; Inf, NaN: exponent -> 512
 adds r2,#128   @ zero/denormal: exponent -> -380; Inf, NaN: exponent -> 640
 bx r14

@ normalise and pack signed mantissa in r0 nominally 3Q29, signed exponent in r2-> IEEE single in r0
@ trashes r4, preserves r1,r3
@ r5: "sticky bits", must be zero iff all result bits below r0 are zero for correct rounding
packx:
 lsrs r4,r0,#31 @ save sign bit
 lsls r4,r4,#31 @ sign now in b31
 bpl 2f         @ skip if positive
 cmp r5,#0
 beq 11f
 adds r0,#1     @ fiddle carry in to following rsb if sticky bits are non-zero
11:
 rsbs r0,#0     @ can now treat r0 as unsigned
packx0:
 bmi 3f         @ catch r0=0x80000000 case
2:
 subs r2,#1     @ normalisation loop
 adds r0,r0
 beq 1f         @ zero? special case
 bpl 2b         @ normalise so leading "1" in bit 31
3:
 adds r2,#129   @ (mis-)offset exponent
 bne 12f        @ special case: highest denormal can round to lowest normal
 adds r0,#0x80  @ in special case, need to add 256 to r0 for rounding
 bcs 4f         @ tripped carry? then have leading 1 in C as required
12:
 adds r0,#0x80  @ rounding
 bcs 4f         @ tripped carry? then have leading 1 in C as required (and result is even so can ignore sticky bits)
 cmp r5,#0
 beq 7f         @ sticky bits zero?
8:
 lsls r0,#1     @ remove leading 1
9:
 subs r2,#1     @ compensate exponent on this path
4:
 cmp r2,#254
 bge 5f         @ overflow?
 adds r2,#1     @ correct exponent offset
 ble 10f        @ denormal/underflow?
 lsrs r0,#9     @ align mantissa
 lsls r2,#23    @ align exponent
 orrs r0,r2     @ assemble exponent and mantissa
6:
 orrs r0,r4     @ apply sign
1:
 bx r14

5:
 movs r0,#0xff  @ create infinity
 lsls r0,#23
 b 6b

10:
 movs r0,#0     @ create zero
 bx r14

7:              @ sticky bit rounding case
 lsls r5,r0,#24 @ check bottom 8 bits of r0
 bne 8b         @ in rounding-tie case?
 lsrs r0,#9     @ ensure even result
 lsls r0,#10
 b 9b

.align 2
.ltorg

@ signed multiply r0 1Q23 by r1 4Q23, result in r0 7Q25, sticky bits in r5
@ trashes r3,r4
mul0:
 uxth r3,r0      @ Q23
 asrs r4,r1,#16  @ Q7
 muls r3,r4      @ L*H, Q30 signed
 asrs r4,r0,#16  @ Q7
 uxth r5,r1      @ Q23
 muls r4,r5      @ H*L, Q30 signed
 adds r3,r4      @ sum of middle partial products
 uxth r4,r0
 muls r4,r5      @ L*L, Q46 unsigned
 lsls r5,r4,#16  @ initialise sticky bits from low half of low partial product
 lsrs r4,#16     @ Q25
 adds r3,r4      @ add high half of low partial product to sum of middle partial products
                 @ (cannot generate carry by limits on input arguments)
 asrs r0,#16     @ Q7
 asrs r1,#16     @ Q7
 muls r0,r1      @ H*H, Q14 signed
 lsls r0,#11     @ high partial product Q25
 lsls r1,r3,#27  @ sticky
 orrs r5,r1      @ collect further sticky bits
 asrs r1,r3,#5   @ middle partial products Q25
 adds r0,r1      @ final result
 bx r14

.thumb_func
qfp_fcmp:
 lsls r2,r0,#1
 lsrs r2,#24
 beq 1f
 cmp r2,#0xff
 bne 2f
1:
 lsrs r0,#23     @ clear mantissa if NaN or denormal
 lsls r0,#23
2:
 lsls r2,r1,#1
 lsrs r2,#24
 beq 1f
 cmp r2,#0xff
 bne 2f
1:
 lsrs r1,#23     @ clear mantissa if NaN or denormal
 lsls r1,#23
2:
 movs r2,#1      @ initialise result
 eors r1,r0
 bmi 4f          @ opposite signs? then can proceed on basis of sign of x
 eors r1,r0      @ restore y
 bpl 1f
 rsbs r2,#0      @ both negative? flip comparison
1:
 cmp r0,r1
 bgt 2f
 blt 3f
5:
 movs r2,#0
3:
 rsbs r2,#0
2:
 subs r0,r2,#0
 bx r14
4:
 orrs r1,r0
 adds r1,r1
 beq 5b
 cmp r0,#0
 bge 2b
 b 3b

@ convert float to signed int, rounding towards -Inf, clamping
.thumb_func
_ffix:
 movs r1,#0      @ fall through

@ convert float in r0 to signed fixed point in r0, clamping
.thumb_func
qfp_float2fix:
 push {r4,r14}
 bl unpackx
 movs r3,r2
 adds r3,#130
 bmi 6f          @ -0?
 add r2,r1       @ incorporate binary point position into exponent
 subs r2,#23     @ r2 is now amount of left shift required
 blt 1f          @ requires right shift?
 cmp r2,#7       @ overflow?
 ble 4f
3:               @ overflow
 asrs r1,r0,#31  @ +ve:0 -ve:0xffffffff
 mvns r1,r1      @ +ve:0xffffffff -ve:0
 movs r0,#1
 lsls r0,#31
5:
 eors r0,r1      @ +ve:0x7fffffff -ve:0x80000000 (unsigned path: 0xffffffff)
 pop {r4,r15}
1:
 rsbs r2,#0      @ right shift for r0, >0
 cmp r2,#32
 blt 2f          @ more than 32 bits of right shift?
 movs r2,#32
2:
 asrs r0,r0,r2
 pop {r4,r15}
6:
 movs r0,#0
 pop {r4,r15}

@ unsigned version
.thumb_func
_ffixu:
 movs r1,#0      @ fall through
.thumb_func
qfp_float2ufix:
 push {r4,r14}
 bl unpackx
 add r2,r1       @ incorporate binary point position into exponent
 movs r1,r0
 bmi 5b          @ negative? return zero
 subs r2,#23     @ r2 is now amount of left shift required
 blt 1b          @ requires right shift?
 mvns r1,r0      @ ready to return 0xffffffff
 cmp r2,#8       @ overflow?
 bgt 5b
4:
 lsls r0,r0,r2   @ result fits, left shifted
 pop {r4,r15}


@ convert uint64 to float, rounding
.thumb_func
_ll_uto_f:
 movs r2,#0       @ fall through

@ convert unsigned 64-bit fix to float, rounding; number of r0:r1 bits after point in r2
.thumb_func
qfp_ufix642float:
 push {r4,r5,r14}
 cmp r1,#0
 bpl 3f          @ positive? we can use signed code
 lsls r5,r1,#31  @ contribution to sticky bits
 orrs r5,r0
 lsrs r0,r1,#1
 subs r2,#1
 b 4f

@ convert int64 to float, rounding
.thumb_func
_ll_sto_f:
 movs r2,#0       @ fall through

@ convert signed 64-bit fix to float, rounding; number of r0:r1 bits after point in r2
.thumb_func
qfp_fix642float:
 push {r4,r5,r14}
3:
 movs r5,r0
 orrs r5,r1
 beq ret_pop45   @ zero? return +0
 asrs r5,r1,#31  @ sign bits
2:
 asrs r4,r1,#24  @ try shifting 7 bits at a time
 cmp r4,r5
 bne 1f          @ next shift will overflow?
 lsls r1,#7
 lsrs r4,r0,#25
 orrs r1,r4
 lsls r0,#7
 adds r2,#7
 b 2b
1:
 movs r5,r0
 movs r0,r1
4:
 rsbs r2,#0
 adds r2,#32+29
 b packret

@ convert signed int to float, rounding
.thumb_func
_fflt:
 movs r1,#0      @ fall through

@ convert signed fix to float, rounding; number of r0 bits after point in r1
.thumb_func
qfp_fix2float:
 push {r4,r5,r14}
1:
 movs r2,#29
 subs r2,r1      @ fix exponent
packretns:       @ pack and return, sticky bits=0
 movs r5,#0
packret:         @ common return point: "pack and return"
 bl packx
ret_pop45:
 pop {r4,r5,r15}


@ unsigned version
.thumb_func
_ffltu:
 movs r1,#0      @ fall through
.thumb_func
qfp_ufix2float:
 push {r4,r5,r14}
 cmp r0,#0
 bge 1b          @ treat <2^31 as signed
 movs r2,#30
 subs r2,r1      @ fix exponent
 lsls r5,r0,#31  @ one sticky bit
 lsrs r0,#1
 b packret

@ All the scientific functions are implemented using the CORDIC algorithm. For notation,
@ details not explained in the comments below, and a good overall survey see
@ "50 Years of CORDIC: Algorithms, Architectures, and Applications" by Meher et al.,
@ IEEE Transactions on Circuits and Systems Part I, Volume 56 Issue 9.

@ Register use:
@ r0: x
@ r1: y
@ r2: z/omega
@ r3: coefficient pointer
@ r4,r12: m
@ r5: i (shift)

cordic_start: @ initialisation
 movs r5,#0   @ initial shift=0
 mov r12,r4
 b 5f

cordic_vstep: @ one step of algorithm in vector mode
 cmp r1,#0    @ check sign of y
 bgt 4f
 b 1f
cordic_rstep: @ one step of algorithm in rotation mode
 cmp r2,#0    @ check sign of angle
 bge 1f
4:
 subs r1,r6   @ negative rotation: y=y-(x>>i)
 rsbs r7,#0
 adds r2,r4   @ accumulate angle
 b 2f
1:
 adds r1,r6   @ positive rotation: y=y+(x>>i)
 subs r2,r4   @ accumulate angle
2:
 mov r4,r12
 muls r7,r4   @ apply sign from m
 subs r0,r7   @ finish rotation: x=x{+/-}(y>>i)
5:
 ldmia r3!,{r4} @ fetch next angle from table and bump pointer
 lsrs r4,#1   @ repeated angle?
 bcs 3f
 adds r5,#1   @ adjust shift if not
3:
 mov r6,r0
 asrs r6,r5   @ x>>i
 mov r7,r1
 asrs r7,r5   @ y>>i
 lsrs r4,#1   @ shift end flag into carry
 bx r14

@ CORDIC rotation mode
cordic_rot:
 push {r6,r7,r14}
 bl cordic_start   @ initialise
1:
 bl cordic_rstep
 bcc 1b            @ step until table finished
 asrs r6,r0,#14    @ remaining small rotations can be linearised: see IV.B of paper referenced above
 asrs r7,r1,#14
 asrs r2,#3
 muls r6,r2        @ all remaining CORDIC steps in a multiplication
 muls r7,r2
 mov r4,r12
 muls r7,r4
 asrs r6,#12
 asrs r7,#12
 subs r0,r7        @ x=x{+/-}(yz>>k)
 adds r1,r6        @ y=y+(xz>>k)
cordic_exit:
 pop {r6,r7,r15}

@ CORDIC vector mode
cordic_vec:
 push {r6,r7,r14}
 bl cordic_start   @ initialise
1:
 bl cordic_vstep
 bcc 1b            @ step until table finished
4:
 cmp r1,#0         @ continue as in cordic_vstep but without using table; x is not affected as y is small
 bgt 2f            @ check sign of y
 adds r1,r6        @ positive rotation: y=y+(x>>i)
 subs r2,r4        @ accumulate angle
 b 3f
2:
 subs r1,r6        @ negative rotation: y=y-(x>>i)
 adds r2,r4        @ accumulate angle
3:
 asrs r6,#1
 asrs r4,#1        @ next "table entry"
 bne 4b
 b cordic_exit

@ .thumb_func
@ qfp_fsin:            @ calculate sin and cos using CORDIC rotation method
@  push {r4,r5,r14}
@  movs r1,#24
@  bl qfp_float2fix    @ range reduction by repeated subtraction/addition in fixed point
@  ldr r4,pi_q29
@  lsrs r4,#4          @ 2pi Q24
@ 1:
@  subs r0,r4
@  bge 1b
@ 1:
@  adds r0,r4
@  bmi 1b              @ now in range 0..2pi
@  lsls r2,r0,#2       @ z Q26
@  lsls r5,r4,#1       @ pi Q26 (r4=pi/2 Q26)
@  ldr r0,=#0x136e9db4 @ initialise CORDIC x,y with scaling
@  movs r1,#0
@ 1:
@  cmp r2,r4           @ >pi/2?
@  blt 2f
@  subs r2,r5          @ reduce range to -pi/2..pi/2
@  rsbs r0,#0          @ rotate vector by pi
@  b 1b
@ 2:
@  lsls r2,#3          @ Q29
@  adr r3,tab_cc       @ circular coefficients
@  movs r4,#1          @ m=1
@  bl cordic_rot
@  adds r1,#9          @ fiddle factor to make sin(0)==0
@  movs r2,#0          @ exponents to zero
@  movs r3,#0
@  movs r5,#0          @ no sticky bits
@  bl clampx
@  bl packx            @ pack cosine
@  bl xchxy
@  bl clampx
@  b packretns         @ pack sine

@ .thumb_func
@ qfp_fcos:
@  push {r14}
@  bl qfp_fsin
@  mov r0,r1           @ extract cosine result
@  pop {r15}

@ @ force r0 to lie in range [-1,1] Q29
@ clampx:
@  movs r4,#1
@  lsls r4,#29
@  cmp r0,r4
@  bgt 1f
@  rsbs r4,#0
@  cmp r0,r4
@  ble 1f
@  bx r14
@ 1:
@  movs r0,r4
@  bx r14

@ .thumb_func
@ qfp_ftan:
@  push {r4,r5,r6,r14}
@  bl qfp_fsin         @ sine in r0/r2, cosine in r1/r3
@  b fdiv_n            @ sin/cos

@ .thumb_func
@ qfp_fexp:
@  push {r4,r5,r14}
@  movs r1,#24
@  bl qfp_float2fix    @ Q24: covers entire valid input range
@  asrs r1,r0,#16      @ Q8
@  ldr r2,=#5909       @ log_2(e) Q12
@  muls r2,r1          @ estimate exponent of result Q20 (always an underestimate)
@  asrs r2,#20         @ Q0
@  lsls r1,r0,#6       @ Q30
@  ldr r0,=#0x2c5c85fe @ ln(2) Q30
@  muls r0,r2          @ accurate contribution of estimated exponent
@  subs r1,r0          @ residual to be exponentiated, guaranteed ≥0, < about 0.75 Q30

@ @ here
@ @ r1: mantissa to exponentiate, 0...~0.75 Q30
@ @ r2: first exponent estimate

@  movs r5,#1          @ shift
@  adr r3,ftab_exp     @ could use alternate words from dtab_exp to save space if required
@  movs r0,#1
@  lsls r0,#29         @ x=1 Q29

@ 3:
@  ldmia r3!,{r4}
@  subs r4,r1,r4
@  bmi 1f
@  movs r1,r4          @ keep result of subtraction
@  movs r4,r0
@  lsrs r4,r5
@  adcs r0,r4          @ x+=x>>i with rounding

@ 1:
@  adds r5,#1
@  cmp r5,#15
@  bne 3b

@ @ here
@ @ r0: exp a Q29 1..2+
@ @ r1: ε (residual x where x=a+ε), < 2^-14 Q30
@ @ r2: first exponent estimate
@ @ and we wish to calculate exp x=exp a exp ε~(exp a)(1+ε)

@  lsrs r3,r0,#15      @ exp a Q14
@  muls r3,r1          @ ε exp a Q44
@  lsrs r3,#15         @ ε exp a Q29
@  adcs r0,r3          @ (1+ε) exp a Q29 with rounding

@  b packretns         @ pack result

@ .thumb_func
@ qfp_fln:
@  push {r4,r5,r14}
@  asrs r1,r0,#23
@  bmi 3f              @ -ve argument?
@  beq 3f              @ 0 argument?
@  cmp r1,#0xff
@  beq 4f              @ +Inf/NaN
@  bl unpackx
@  adds r2,#1
@  ldr r3,=#0x2c5c85fe @ ln(2) Q30
@  lsrs r1,r3,#14      @ ln(2) Q16
@  muls r1,r2          @ result estimate Q16
@  asrs r1,#16         @ integer contribution to result
@  muls r3,r2
@  lsls r4,r1,#30
@  subs r3,r4          @ fractional contribution to result Q30, signed
@  lsls r0,#8          @ Q31

@ @ here
@ @ r0: mantissa Q31
@ @ r1: integer contribution to result
@ @ r3: fractional contribution to result Q30, signed

@  movs r5,#1          @ shift
@  adr r4,ftab_exp     @ could use alternate words from dtab_exp to save space if required

@ 2:
@  movs r2,r0
@  lsrs r2,r5
@  adcs r2,r0          @ x+(x>>i) with rounding
@  bcs 1f              @ >=2?
@  movs r0,r2          @ keep result
@  ldr r2,[r4]
@  subs r3,r2
@ 1:
@  adds r4,#4
@  adds r5,#1
@  cmp r5,#15
@  bne 2b

@ @ here
@ @ r0: residual x, nearly 2 Q31
@ @ r1: integer contribution to result
@ @ r3: fractional part of result Q30

@  asrs r0,#2
@  adds r0,r3,r0

@  cmp r1,#0
@  bne 2f

@  asrs r0,#1
@  lsls r1,#29
@  adds r0,r1
@  movs r2,#0
@  b packretns

@ 2:
@  lsls r1,#24
@  asrs r0,#6          @ Q24
@  adcs r0,r1          @ with rounding
@  movs r2,#5
@  b packretns

@ 3:
@  ldr r0,=#0xff800000 @ -Inf
@  pop {r4,r5,r15}
@ 4:
@  ldr r0,=#0x7f800000 @ +Inf
@  pop {r4,r5,r15}

@ .align 2
@ ftab_exp:
@ .word 0x19f323ed   @ log 1+2^-1 Q30
@ .word 0x0e47fbe4   @ log 1+2^-2 Q30
@ .word 0x0789c1dc   @ log 1+2^-3 Q30
@ .word 0x03e14618   @ log 1+2^-4 Q30
@ .word 0x01f829b1   @ log 1+2^-5 Q30
@ .word 0x00fe0546   @ log 1+2^-6 Q30
@ .word 0x007f80aa   @ log 1+2^-7 Q30
@ .word 0x003fe015   @ log 1+2^-8 Q30
@ .word 0x001ff803   @ log 1+2^-9 Q30
@ .word 0x000ffe00   @ log 1+2^-10 Q30
@ .word 0x0007ff80   @ log 1+2^-11 Q30
@ .word 0x0003ffe0   @ log 1+2^-12 Q30
@ .word 0x0001fff8   @ log 1+2^-13 Q30
@ .word 0x0000fffe   @ log 1+2^-14 Q30

@ .thumb_func
@ qfp_fatan2:
@  push {r4,r5,r14}

@ @ unpack arguments and shift one down to have common exponent
@  bl unpackx
@  bl xchxy
@  bl unpackx
@  lsls r0,r0,#5  @ Q28
@  lsls r1,r1,#5  @ Q28
@  adds r4,r2,r3  @ this is -760 if both arguments are 0 and at least -380-126=-506 otherwise
@  asrs r4,#9
@  adds r4,#1
@  bmi 2f         @ force y to 0 proper, so result will be zero
@  subs r4,r2,r3  @ calculate shift
@  bge 1f         @ ex>=ey?
@  rsbs r4,#0     @ make shift positive
@  asrs r0,r4
@  cmp r4,#28
@  blo 3f
@  asrs r0,#31
@  b 3f
@ 1:
@  asrs r1,r4
@  cmp r4,#28
@  blo 3f
@ 2:
@ @ here |x|>>|y| or both x and y are ±0
@  cmp r0,#0
@  bge 4f         @ x positive, return signed 0
@  ldr r0,pi_q29  @ x negative, return +/- pi
@  asrs r1,#31
@  eors r0,r1
@  b 7f
@ 4:
@  asrs r0,r1,#31
@  b 7f
@ 3:
@  movs r2,#0              @ initial angle
@  cmp r0,#0               @ x negative
@  bge 5f
@  rsbs r0,#0              @ rotate to 1st/4th quadrants
@  rsbs r1,#0
@  ldr r2,pi_q29           @ pi Q29
@ 5:
@  adr r3,tab_cc           @ circular coefficients
@  movs r4,#1              @ m=1
@  bl cordic_vec           @ also produces magnitude (with scaling factor 1.646760119), which is discarded
@  mov r0,r2               @ result here is -pi/2..3pi/2 Q29
@ @ asrs r2,#29
@ @ subs r0,r2
@  ldr r2,pi_q29           @ pi Q29
@  adds r4,r0,r2           @ attempt to fix -3pi/2..-pi case
@  bcs 6f                  @ -pi/2..0? leave result as is
@  subs r4,r0,r2           @ <pi? leave as is
@  bmi 6f
@  subs r0,r4,r2           @ >pi: take off 2pi
@ 6:
@  subs r0,#1              @ fiddle factor so atan2(0,1)==0
@ 7:
@  movs r2,#0              @ exponent for pack
@  b packretns

@ .align 2
@ .ltorg

@ @ first entry in following table is pi Q29
@ pi_q29:
@ @ circular CORDIC coefficients: atan(2^-i), b0=flag for preventing shift, b1=flag for end of table
@ tab_cc:
@ .word 0x1921fb54*4+1     @ no shift before first iteration
@ .word 0x0ed63383*4+0
@ .word 0x07d6dd7e*4+0
@ .word 0x03fab753*4+0
@ .word 0x01ff55bb*4+0
@ .word 0x00ffeaae*4+0
@ .word 0x007ffd55*4+0
@ .word 0x003fffab*4+0
@ .word 0x001ffff5*4+0
@ .word 0x000fffff*4+0
@ .word 0x0007ffff*4+0
@ .word 0x00040000*4+0
@ .word 0x00020000*4+0+2   @ +2 marks end

.align 2
.thumb_func
__aeabi_fsub:
 ldr r2,=#0x80000000
 eors r1,r2    @ flip sign on second argument
@ drop into fadd, on .align2:ed boundary

.thumb_func
__aeabi_fadd:
 push {r4,r5,r6,r14}
 asrs r4,r0,#31
 lsls r2,r0,#1
 lsrs r2,#24     @ x exponent
 beq fa_xe0
 cmp r2,#255
 beq fa_xe255
fa_xe:
 asrs r5,r1,#31
 lsls r3,r1,#1
 lsrs r3,#24     @ y exponent
 beq fa_ye0
 cmp r3,#255
 beq fa_ye255
fa_ye:
 ldr r6,=#0x007fffff
 ands r0,r0,r6   @ extract mantissa bits
 ands r1,r1,r6
 adds r6,#1      @ r6=0x00800000
 orrs r0,r0,r6   @ set implied 1
 orrs r1,r1,r6
 eors r0,r0,r4   @ complement...
 eors r1,r1,r5
 subs r0,r0,r4   @ ... and add 1 if sign bit is set: 2's complement
 subs r1,r1,r5
 subs r5,r3,r2   @ ye-xe
 subs r4,r2,r3   @ xe-ye
 bmi fa_ygtx
@ here xe>=ye
 cmp r4,#30
 bge fa_xmgty    @ xe much greater than ye?
 adds r5,#32
 movs r3,r2      @ save exponent
@ here y in r1 must be shifted down r4 places to align with x in r0
 movs r2,r1
 lsls r2,r2,r5   @ keep the bits we will shift off the bottom of r1
 asrs r1,r1,r4
 b fa_0

.ltorg
 
fa_ymgtx:
 movs r2,#0      @ result is just y
 movs r0,r1
 b fa_1
fa_xmgty:
 movs r3,r2      @ result is just x
 movs r2,#0
 b fa_1

fa_ygtx:
@ here ye>xe
 cmp r5,#30
 bge fa_ymgtx    @ ye much greater than xe?
 adds r4,#32
@ here x in r0 must be shifted down r5 places to align with y in r1
 movs r2,r0
 lsls r2,r2,r4   @ keep the bits we will shift off the bottom of r0
 asrs r0,r0,r5
fa_0:
 adds r0,r1      @ result is now in r0:r2, possibly highly denormalised or zero; exponent in r3
 beq fa_9        @ if zero, inputs must have been of identical magnitude and opposite sign, so return +0
fa_1: 
 lsrs r1,r0,#31  @ sign bit
 beq fa_8
 mvns r0,r0
 rsbs r2,r2,#0
 bne fa_8
 adds r0,#1
fa_8:
 adds r6,r6
@ r6=0x01000000
 cmp r0,r6
 bhs fa_2
fa_3:
 adds r2,r2      @ normalisation loop
 adcs r0,r0
 subs r3,#1      @ adjust exponent
 cmp r0,r6
 blo fa_3
fa_2:
@ here r0:r2 is the result mantissa 0x01000000<=r0<0x02000000, r3 the exponent, and r1 the sign bit
 lsrs r0,#1
 bcc fa_4
@ rounding bits here are 1:r2
 adds r0,#1      @ round up
 cmp r2,#0
 beq fa_5        @ sticky bits all zero?
fa_4:
 cmp r3,#254
 bhs fa_6        @ exponent too large or negative?
 lsls r1,#31     @ pack everything
 add r0,r1
 lsls r3,#23
 add r0,r3
fa_end:
 pop {r4,r5,r6,r15}

fa_9:
 cmp r2,#0       @ result zero?
 beq fa_end      @ return +0
 b fa_1

fa_5:
 lsrs r0,#1
 lsls r0,#1      @ round to even
 b fa_4

fa_6:
 bge fa_7
@ underflow
@ can handle denormals here
 lsls r0,r1,#31  @ result is signed zero
 pop {r4,r5,r6,r15}
fa_7:
@ overflow
 lsls r0,r1,#8
 adds r0,#255
 lsls r0,#23     @ result is signed infinity
 pop {r4,r5,r6,r15}


fa_xe0:
@ can handle denormals here
 subs r2,#32
 adds r2,r4       @ exponent -32 for +Inf, -33 for -Inf
 b fa_xe

fa_xe255:
@ can handle NaNs here
 lsls r2,#8
 add r2,r2,r4 @ exponent ~64k for +Inf, ~64k-1 for -Inf
 b fa_xe

fa_ye0:
@ can handle denormals here
 subs r3,#32
 adds r3,r5       @ exponent -32 for +Inf, -33 for -Inf
 b fa_ye

fa_ye255:
@ can handle NaNs here
 lsls r3,#8
 add r3,r3,r5 @ exponent ~64k for +Inf, ~64k-1 for -Inf
 b fa_ye


.align 2
.thumb_func
__aeabi_fmul:
 push {r7,r14}
 mov r2,r0
 eors r2,r1       @ sign of result
 lsrs r2,#31
 lsls r2,#31
 mov r14,r2
 lsls r0,#1
 lsls r1,#1
 lsrs r2,r0,#24   @ xe
 beq fm_xe0
 cmp r2,#255
 beq fm_xe255
fm_xe:
 lsrs r3,r1,#24   @ ye
 beq fm_ye0
 cmp r3,#255
 beq fm_ye255
fm_ye:
 adds r7,r2,r3    @ exponent of result (will possibly be incremented)
 subs r7,#128     @ adjust bias for packing
 lsls r0,#8       @ x mantissa
 lsls r1,#8       @ y mantissa
 lsrs r0,#9
 lsrs r1,#9

 adds r2,r0,r1    @ for later
 mov r12,r2
 lsrs r2,r0,#7    @ x[22..7] Q16
 lsrs r3,r1,#7    @ y[22..7] Q16
 muls r2,r2,r3    @ result [45..14] Q32: never an overestimate and worst case error is 2*(2^7-1)*(2^23-2^7)+(2^7-1)^2 = 2130690049 < 2^31
 muls r0,r0,r1    @ result [31..0] Q46
 lsrs r2,#18      @ result [45..32] Q14
 bcc 1f
 cmp r0,#0
 bmi 1f
 adds r2,#1       @ fix error in r2
1:
 lsls r3,r0,#9    @ bits off bottom of result
 lsrs r0,#23      @ Q23
 lsls r2,#9
 adds r0,r2       @ cut'n'shut
 add r0,r12       @ implied 1*(x+y) to compensate for no insertion of implied 1s
@ result-1 in r3:r0 Q23+32, i.e., in range [0,3)

 lsrs r1,r0,#23
 bne fm_0         @ branch if we need to shift down one place
@ here 1<=result<2
 cmp r7,#254
 bhs fm_3a        @ catches both underflow and overflow
 lsls r3,#1       @ sticky bits at top of R3, rounding bit in carry
 bcc fm_1         @ no rounding
 beq fm_2         @ rounding tie?
 adds r0,#1       @ round up
fm_1:
 adds r7,#1       @ for implied 1
 lsls r7,#23      @ pack result
 add r0,r7
 add r0,r14
 pop {r7,r15}
fm_2:             @ rounding tie
 adds r0,#1
fm_3:
 lsrs r0,#1
 lsls r0,#1       @ clear bottom bit
 b fm_1

@ here 1<=result-1<3
fm_0:
 adds r7,#1       @ increment exponent
 cmp r7,#254
 bhs fm_3b        @ catches both underflow and overflow
 lsrs r0,#1       @ shift mantissa down
 bcc fm_1a        @ no rounding
 adds r0,#1       @ assume we will round up
 cmp r3,#0        @ sticky bits
 beq fm_3c        @ rounding tie?
fm_1a:
 adds r7,r7
 adds r7,#1       @ for implied 1
 lsls r7,#22      @ pack result
 add r0,r7
 add r0,r14
 pop {r7,r15}

fm_3c:
 lsrs r0,#1
 lsls r0,#1       @ clear bottom bit
 b fm_1a

fm_xe0:
 subs r2,#16
fm_xe255:
 lsls r2,#8
 b fm_xe
fm_ye0:
 subs r3,#16
fm_ye255:
 lsls r3,#8
 b fm_ye

@ here the result is under- or overflowing
fm_3b:
 bge fm_4        @ branch on overflow
@ trap case where result is denormal 0x007fffff + 0.5ulp or more
 adds r7,#1      @ exponent=-1?
 bne fm_5
@ corrected mantissa will be >= 3.FFFFFC (0x1fffffe Q23)
@ so r0 >= 2.FFFFFC (0x17ffffe Q23)
 adds r0,#2
 lsrs r0,#23
 cmp r0,#3
 bne fm_5
 b fm_6

fm_3a:
 bge fm_4        @ branch on overflow
@ trap case where result is denormal 0x007fffff + 0.5ulp or more
 adds r7,#1      @ exponent=-1?
 bne fm_5
 adds r0,#1      @ mantissa=0xffffff (i.e., r0=0x7fffff)?
 lsrs r0,#23
 beq fm_5
fm_6:
 movs r0,#1      @ return smallest normal
 lsls r0,#23
 add r0,r14
 pop {r7,r15}

fm_5:
 mov r0,r14
 pop {r7,r15}
fm_4:
 movs r0,#0xff
 lsls r0,#23
 add r0,r14
 pop {r7,r15}

@ This version of the division algorithm uses external divider hardware to estimate the
@ reciprocal of the divisor to about 14 bits; then a multiplication step to get a first
@ quotient estimate; then the remainder based on this estimate is used to calculate a
@ correction to the quotient. The result is good to about 27 bits and so we only need
@ to calculate the exact remainder when close to a rounding boundary.
.align 2
.thumb_func
__aeabi_fdiv:
 push {r4,r5,r6,r14}
fdiv_n:

 movs r4,#1
 lsls r4,#23   @ implied 1 position
 lsls r2,r1,#9 @ clear out sign and exponent
 lsrs r2,r2,#9
 orrs r2,r2,r4 @ divisor mantissa Q23 with implied 1

@ here
@ r0=packed dividend
@ r1=packed divisor
@ r2=divisor mantissa Q23
@ r4=1<<23

// see divtest.c
 lsrs r3,r2,#18 @ x2=x>>18; // Q5 32..63
 adr r5,rcpapp-32
 ldrb r3,[r5,r3] @ u=lut5[x2-32]; // Q8
 lsls r5,r2,#5
 muls r5,r5,r3
 asrs r5,#14 @ e=(i32)(u*(x<<5))>>14; // Q22
 asrs r6,r5,#11
 muls r6,r6,r6 @ e2=(e>>11)*(e>>11); // Q22
 subs r5,r6
 muls r5,r5,r3 @ c=(e-e2)*u; // Q30
 lsls r6,r3,#8
 asrs r5,#13
 adds r5,#1
 asrs r5,#1
 subs r5,r6,r5 @ u0=(u<<8)-((c+0x2000)>>14); // Q16

@ here
@ r0=packed dividend
@ r1=packed divisor
@ r2=divisor mantissa Q23
@ r4=1<<23
@ r5=reciprocal estimate Q16

 lsrs r6,r0,#23
 uxtb r3,r6        @ dividend exponent
 lsls r0,#9
 lsrs r0,#9
 orrs r0,r0,r4     @ dividend mantissa Q23

 lsrs r1,#23
 eors r6,r1        @ sign of result in bit 8
 lsrs r6,#8
 lsls r6,#31       @ sign of result in bit 31, other bits clear

@ here
@ r0=dividend mantissa Q23
@ r1=divisor sign+exponent
@ r2=divisor mantissa Q23
@ r3=dividend exponent
@ r5=reciprocal estimate Q16
@ r6b31=sign of result

 uxtb r1,r1        @ divisor exponent
 cmp r1,#0
 beq retinf
 cmp r1,#255
 beq 20f           @ divisor is infinite
 cmp r3,#0
 beq retzero
 cmp r3,#255
 beq retinf
 subs r3,r1        @ initial result exponent (no bias)
 adds r3,#125      @ add bias

 lsrs r1,r0,#8     @ dividend mantissa Q15

@ here
@ r0=dividend mantissa Q23
@ r1=dividend mantissa Q15
@ r2=divisor mantissa Q23
@ r3=initial result exponent
@ r5=reciprocal estimate Q16
@ r6b31=sign of result

 muls r1,r5

 lsrs r1,#16       @ Q15 qu0=(q15)(u*y0);
 lsls r0,r0,#15    @ dividend Q38
 movs r4,r2
 muls r4,r1        @ Q38 qu0*x
 subs r4,r0,r4     @ Q38 re0=(y<<15)-qu0*x; note this remainder is signed
 asrs r4,#10
 muls r4,r5        @ Q44 qu1=(re0>>10)*u; this quotient correction is also signed
 asrs r4,#16       @ Q28
 lsls r1,#13
 adds r1,r1,r4     @ Q28 qu=(qu0<<13)+(qu1>>16);

@ here
@ r0=dividend mantissa Q38
@ r1=quotient Q28
@ r2=divisor mantissa Q23
@ r3=initial result exponent
@ r6b31=sign of result

 lsrs r4,r1,#28
 bne 1f
@ here the quotient is less than 1<<28 (i.e., result mantissa <1.0)

 adds r1,#5
 lsrs r4,r1,#4     @ rounding + small reduction in systematic bias
 bcc 2f            @ skip if we are not near a rounding boundary
 lsrs r1,#3        @ quotient Q25
 lsls r0,#10       @ dividend mantissa Q48
 muls r1,r1,r2     @ quotient*divisor Q48
 subs r0,r0,r1     @ remainder Q48
 bmi 2f
 b 3f

1:
@ here the quotient is at least 1<<28 (i.e., result mantissa >=1.0)

 adds r3,#1        @ bump exponent (and shift mantissa down one more place)
 adds r1,#9
 lsrs r4,r1,#5     @ rounding + small reduction in systematic bias
 bcc 2f            @ skip if we are not near a rounding boundary

 lsrs r1,#4        @ quotient Q24
 lsls r0,#9        @ dividend mantissa Q47
 muls r1,r1,r2     @ quotient*divisor Q47
 subs r0,r0,r1     @ remainder Q47
 bmi 2f
3:
 adds r4,#1        @ increment quotient as we are above the rounding boundary

@ here
@ r3=result exponent
@ r4=correctly rounded quotient Q23 in range [1,2] *note closed interval*
@ r6b31=sign of result

2:
 cmp r3,#254
 bhs 10f           @ this catches both underflow and overflow
 lsls r1,r3,#23
 adds r0,r4,r1
 adds r0,r6
 pop {r4,r5,r6,r15}

@ here divisor is infinite; dividend exponent in r3
20:
 cmp r3,#255
 bne retzero

retinf:
 movs r0,#255
21:
 lsls r0,#23
 orrs r0,r6
 pop {r4,r5,r6,r15}

10:
 bge retinf       @ overflow?
 adds r1,r3,#1
 bne retzero      @ exponent <-1? return 0
@ here exponent is exactly -1
 lsrs r1,r4,#25
 bcc retzero      @ mantissa is not 01000000?
@ return minimum normal
 movs r0,#1
 lsls r0,#23
 orrs r0,r6
 pop {r4,r5,r6,r15}

retzero:
 movs r0,r6
 pop {r4,r5,r6,r15}

@ x2=[32:1:63]/32;
@ round(256 ./(x2+1/64))
.align 2
rcpapp:
.byte 252,245,237,231,224,218,213,207,202,197,193,188,184,180,176,172
.byte 169,165,162,159,156,153,150,148,145,142,140,138,135,133,131,129

@ The square root routine uses an initial approximation to the reciprocal of the square root of the argument based
@ on the top four bits of the mantissa (possibly shifted one place to make the exponent even). It then performs two
@ Newton-Raphson iterations, resulting in about 14 bits of accuracy. This reciprocal is then multiplied by
@ the original argument to produce an approximation to the result, again with about 14 bits of accuracy.
@ Then a remainder is calculated, and multiplied by the reciprocal estiamte to generate a correction term
@ giving a final answer to about 28 bits of accuracy. A final remainder calculation rounds to the correct
@ result if necessary.
@ Again, the fixed-point calculation is carefully implemented to preserve accuracy, and similar comments to those
@ made above on the fast division routine apply.
@ The reciprocal square root calculation has been tested for all possible (possibly shifted) input mantissa values.
.align 2
.thumb_func
_fsqrt:
 push {r4}
 lsls r1,r0,#1
 bcs sq_0         @ negative?
 lsls r1,#8
 lsrs r1,#9       @ mantissa
 movs r2,#1
 lsls r2,#23
 adds r1,r2       @ insert implied 1
 lsrs r2,r0,#23   @ extract exponent
 beq sq_2         @ zero?
 cmp r2,#255      @ infinite?
 beq sq_1
 adds r2,#125     @ correction for packing
 asrs r2,#1       @ exponent/2, LSB into carry
 bcc 1f
 lsls r1,#1       @ was even: double mantissa; mantissa y now 1..4 Q23
1:
 adr r4,rsqrtapp-4@ first four table entries are never accessed because of the mantissa's leading 1
 lsrs r3,r1,#21   @ y Q2
 ldrb r4,[r4,r3]  @ initial approximation to reciprocal square root a0 Q8

 lsrs r0,r1,#7    @ y Q16: first Newton-Raphson iteration
 muls r0,r4       @ a0*y Q24
 muls r0,r4       @ r0=p0=a0*y*y Q32
 asrs r0,#12      @ r0 Q20
 muls r0,r4       @ dy0=a0*r0 Q28
 asrs r0,#13      @ dy0 Q15
 lsls r4,#8       @ a0 Q16
 subs r4,r0       @ a1=a0-dy0/2 Q16-Q15/2 -> Q16
 adds r4,#170     @ mostly remove systematic error in this approximation: gains approximately 1 bit

 movs r0,r4       @ second Newton-Raphson iteration
 muls r0,r0       @ a1*a1 Q32
 lsrs r0,#15      @ a1*a1 Q17
 lsrs r3,r1,#8    @ y Q15
 muls r0,r3       @ r1=p1=a1*a1*y Q32
 asrs r0,#12      @ r1 Q20
 muls r0,r4       @ dy1=a1*r1 Q36
 asrs r0,#21      @ dy1 Q15
 subs r4,r0       @ a2=a1-dy1/2 Q16-Q15/2 -> Q16

 muls r3,r4       @ a3=y*a2 Q31
 lsrs r3,#15      @ a3 Q16
@ here a2 is an approximation to the reciprocal square root
@ and a3 is an approximation to the square root
 movs r0,r3
 muls r0,r0       @ a3*a3 Q32
 lsls r1,#9       @ y Q32
 subs r0,r1,r0    @ r2=y-a3*a3 Q32 remainder
 asrs r0,#5       @ r2 Q27
 muls r4,r0       @ r2*a2 Q43
 lsls r3,#7       @ a3 Q23
 asrs r0,r4,#15   @ r2*a2 Q28
 adds r0,#16      @ rounding to Q24
 asrs r0,r0,#6    @ r2*a2 Q22
 add r3,r0        @ a4 Q23: candidate final result
 bcc sq_3         @ near rounding boundary? skip if no rounding needed
 mov r4,r3
 adcs r4,r4       @ a4+0.5ulp Q24
 muls r4,r4       @ Q48
 lsls r1,#16      @ y Q48
 subs r1,r4       @ remainder Q48
 bmi sq_3
 adds r3,#1       @ round up
sq_3:
 lsls r2,#23      @ pack exponent
 adds r0,r2,r3
sq_6:
 pop {r4}
 bx r14

sq_0:
 lsrs r1,#24
 beq sq_2         @ -0: return it
@ here negative and not -0: return -Inf
 asrs r0,#31
sq_5:
 lsls r0,#23
 b sq_6
sq_1:             @ +Inf
 lsrs r0,#23
 b sq_5
sq_2:
 lsrs r0,#31
 lsls r0,#31
 b sq_6

@ round(sqrt(2^22./[72:16:248]))
rsqrtapp:
.byte 0xf1,0xda,0xc9,0xbb, 0xb0,0xa6,0x9e,0x97, 0x91,0x8b,0x86,0x82



@ Notation:
@ rx:ry means the concatenation of rx and ry with rx having the less significant bits

@ IEEE double in ra:rb ->
@ mantissa in ra:rb 12Q52 (53 significant bits) with implied 1 set
@ exponent in re
@ sign in rs
@ trashes rt
.macro mdunpack ra,rb,re,rs,rt
 lsrs \re,\rb,#20              @ extract sign and exponent
 subs \rs,\re,#1
 lsls \rs,#20
 subs \rb,\rs                  @ clear sign and exponent in mantissa; insert implied 1
 lsrs \rs,\re,#11              @ sign
 lsls \re,#21
 lsrs \re,#21                  @ exponent
 beq l\@_1                     @ zero exponent?
 adds \rt,\re,#1
 lsrs \rt,#11
 beq l\@_2                     @ exponent != 0x7ff? then done
l\@_1:
 movs \ra,#0
 movs \rb,#1
 lsls \rb,#20
 subs \re,#128
 lsls \re,#12
l\@_2:
.endm

@ IEEE double in ra:rb ->
@ signed mantissa in ra:rb 12Q52 (53 significant bits) with implied 1
@ exponent in re
@ trashes rt0 and rt1
@ +zero, +denormal -> exponent=-0x80000
@ -zero, -denormal -> exponent=-0x80000
@ +Inf, +NaN -> exponent=+0x77f000
@ -Inf, -NaN -> exponent=+0x77e000
.macro mdunpacks ra,rb,re,rt0,rt1
 lsrs \re,\rb,#20              @ extract sign and exponent
 lsrs \rt1,\rb,#31             @ sign only
 subs \rt0,\re,#1
 lsls \rt0,#20
 subs \rb,\rt0                 @ clear sign and exponent in mantissa; insert implied 1
 lsls \re,#21
 bcc l\@_1                     @ skip on positive
 mvns \rb,\rb                  @ negate mantissa
 rsbs \ra,#0
 bcc l\@_1
 adds \rb,#1
l\@_1:
 lsrs \re,#21
 beq l\@_2                     @ zero exponent?
 adds \rt0,\re,#1
 lsrs \rt0,#11
 beq l\@_3                     @ exponent != 0x7ff? then done
 subs \re,\rt1
l\@_2:
 movs \ra,#0
 lsls \rt1,#1                  @ +ve: 0  -ve: 2
 adds \rb,\rt1,#1              @ +ve: 1  -ve: 3
 lsls \rb,#30                  @ create +/-1 mantissa
 asrs \rb,#10
 subs \re,#128
 lsls \re,#12
l\@_3:
.endm

.align 2
.thumb_func
__aeabi_dsub:
 push {r4-r7,r14}
 movs r4,#1
 lsls r4,#31
 eors r3,r4                    @ flip sign on second argument
 b da_entry                    @ continue in dadd

.align 2
.thumb_func
__aeabi_dadd:
 push {r4-r7,r14}
da_entry:
 mdunpacks r0,r1,r4,r6,r7
 mdunpacks r2,r3,r5,r6,r7
 subs r7,r5,r4                 @ ye-xe
 subs r6,r4,r5                 @ xe-ye
 bmi da_ygtx
@ here xe>=ye: need to shift y down r6 places
 mov r12,r4                    @ save exponent
 cmp r6,#32
 bge da_xrgty                  @ xe rather greater than ye?
 adds r7,#32
 movs r4,r2
 lsls r4,r4,r7                 @ rounding bit + sticky bits
da_xgty0:
 movs r5,r3
 lsls r5,r5,r7
 lsrs r2,r6
 asrs r3,r6
 orrs r2,r5
da_add:
 adds r0,r2
 adcs r1,r3
da_pack:
@ here unnormalised signed result (possibly 0) is in r0:r1 with exponent r12, rounding + sticky bits in r4
@ Note that if a large normalisation shift is required then the arguments were close in magnitude and so we
@ cannot have not gone via the xrgty/yrgtx paths. There will therefore always be enough high bits in r4
@ to provide a correct continuation of the exact result.
@ now pack result back up
 lsrs r3,r1,#31                @ get sign bit
 beq 1f                        @ skip on positive
 mvns r1,r1                    @ negate mantissa
 mvns r0,r0
 movs r2,#0
 rsbs r4,#0
 adcs r0,r2
 adcs r1,r2
1:
 mov r2,r12                    @ get exponent
 lsrs r5,r1,#21
 bne da_0                      @ shift down required?
 lsrs r5,r1,#20
 bne da_1                      @ normalised?
 cmp r0,#0
 beq da_5                      @ could mantissa be zero?
da_2:
 adds r4,r4
 adcs r0,r0
 adcs r1,r1
 subs r2,#1                    @ adjust exponent
 lsrs r5,r1,#20
 beq da_2
da_1:
 lsls r4,#1                    @ check rounding bit
 bcc da_3
da_4:
 adds r0,#1                    @ round up
 bcc 2f
 adds r1,#1
2:
 cmp r4,#0                     @ sticky bits zero?
 bne da_3
 lsrs r0,#1                    @ round to even
 lsls r0,#1
da_3:
 subs r2,#1
 bmi da_6
 adds r4,r2,#2                 @ check if exponent is overflowing
 lsrs r4,#11
 bne da_7
 lsls r2,#20                   @ pack exponent and sign
 add r1,r2
 lsls r3,#31
 add r1,r3
 pop {r4-r7,r15}

da_7:
@ here exponent overflow: return signed infinity
 lsls r1,r3,#31
 ldr r3,=#0x7ff00000
 orrs r1,r3
 b 1f
da_6:
@ here exponent underflow: return signed zero
 lsls r1,r3,#31
1:
 movs r0,#0
 pop {r4-r7,r15}

da_5:
@ here mantissa could be zero
 cmp r1,#0
 bne da_2
 cmp r4,#0
 bne da_2
@ inputs must have been of identical magnitude and opposite sign, so return +0
 pop {r4-r7,r15}

da_0:
@ here a shift down by one place is required for normalisation
 adds r2,#1                    @ adjust exponent
 lsls r6,r0,#31                @ save rounding bit
 lsrs r0,#1
 lsls r5,r1,#31
 orrs r0,r5
 lsrs r1,#1
 cmp r6,#0
 beq da_3
 b da_4

da_xrgty:                      @ xe>ye and shift>=32 places
 cmp r6,#60
 bge da_xmgty                  @ xe much greater than ye?
 subs r6,#32
 adds r7,#64

 movs r4,r2
 lsls r4,r4,r7                 @ these would be shifted off the bottom of the sticky bits
 beq 1f
 movs r4,#1
1:
 lsrs r2,r2,r6
 orrs r4,r2
 movs r2,r3
 lsls r3,r3,r7
 orrs r4,r3
 asrs r3,r2,#31                @ propagate sign bit
 b da_xgty0

da_ygtx:
@ here ye>xe: need to shift x down r7 places
 mov r12,r5                    @ save exponent
 cmp r7,#32
 bge da_yrgtx                  @ ye rather greater than xe?
 adds r6,#32
 movs r4,r0
 lsls r4,r4,r6                 @ rounding bit + sticky bits
da_ygtx0:
 movs r5,r1
 lsls r5,r5,r6
 lsrs r0,r7
 asrs r1,r7
 orrs r0,r5
 b da_add

da_yrgtx:
 cmp r7,#60
 bge da_ymgtx                  @ ye much greater than xe?
 subs r7,#32
 adds r6,#64

 movs r4,r0
 lsls r4,r4,r6                 @ these would be shifted off the bottom of the sticky bits
 beq 1f
 movs r4,#1
1:
 lsrs r0,r0,r7
 orrs r4,r0
 movs r0,r1
 lsls r1,r1,r6
 orrs r4,r1
 asrs r1,r0,#31                @ propagate sign bit
 b da_ygtx0

da_ymgtx:                      @ result is just y
 movs r0,r2
 movs r1,r3
da_xmgty:                      @ result is just x
 movs r4,#0                    @ clear sticky bits
 b da_pack

.ltorg

@ equivalent of UMULL
@ needs five temporary registers
@ can have rt3==rx, in which case rx trashed
@ can have rt4==ry, in which case ry trashed
@ can have rzl==rx
@ can have rzh==ry
@ can have rzl,rzh==rt3,rt4
.macro mul32_32_64 rx,ry,rzl,rzh,rt0,rt1,rt2,rt3,rt4
                               @   t0   t1   t2   t3   t4
                               @                  (x)  (y)
 uxth \rt0,\rx                 @   xl
 uxth \rt1,\ry                 @        yl
 muls \rt0,\rt1                @  xlyl=L
 lsrs \rt2,\rx,#16             @             xh
 muls \rt1,\rt2                @       xhyl=M0
 lsrs \rt4,\ry,#16             @                       yh
 muls \rt2,\rt4                @           xhyh=H
 uxth \rt3,\rx                 @                   xl
 muls \rt3,\rt4                @                  xlyh=M1
 adds \rt1,\rt3                @      M0+M1=M
 bcc l\@_1                     @ addition of the two cross terms can overflow, so add carry into H
 movs \rt3,#1                  @                   1
 lsls \rt3,#16                 @                0x10000
 adds \rt2,\rt3                @             H'
l\@_1:
                               @   t0   t1   t2   t3   t4
                               @                 (zl) (zh)
 lsls \rzl,\rt1,#16            @                  ML
 lsrs \rzh,\rt1,#16            @                       MH
 adds \rzl,\rt0                @                  ZL
 adcs \rzh,\rt2                @                       ZH
.endm

@ SUMULL: x signed, y unsigned
@ in table below ¯ means signed variable
@ needs five temporary registers
@ can have rt3==rx, in which case rx trashed
@ can have rt4==ry, in which case ry trashed
@ can have rzl==rx
@ can have rzh==ry
@ can have rzl,rzh==rt3,rt4
.macro muls32_32_64 rx,ry,rzl,rzh,rt0,rt1,rt2,rt3,rt4
                               @   t0   t1   t2   t3   t4
                               @                 ¯(x)  (y)
 uxth \rt0,\rx                 @   xl
 uxth \rt1,\ry                 @        yl
 muls \rt0,\rt1                @  xlyl=L
 asrs \rt2,\rx,#16             @            ¯xh
 muls \rt1,\rt2                @      ¯xhyl=M0
 lsrs \rt4,\ry,#16             @                       yh
 muls \rt2,\rt4                @          ¯xhyh=H
 uxth \rt3,\rx                 @                   xl
 muls \rt3,\rt4                @                 xlyh=M1
 asrs \rt4,\rt1,#31            @                      M0sx   (M1 sign extension is zero)
 adds \rt1,\rt3                @      M0+M1=M 
 movs \rt3,#0                  @                    0
 adcs \rt4,\rt3                @                      ¯Msx
 lsls \rt4,#16                 @                    ¯Msx<<16
 adds \rt2,\rt4                @             H'

                               @   t0   t1   t2   t3   t4
                               @                 (zl) (zh)
 lsls \rzl,\rt1,#16            @                  M~
 lsrs \rzh,\rt1,#16            @                       M~
 adds \rzl,\rt0                @                  ZL
 adcs \rzh,\rt2                @                      ¯ZH
.endm

@ SSMULL: x signed, y signed
@ in table below ¯ means signed variable
@ needs five temporary registers
@ can have rt3==rx, in which case rx trashed
@ can have rt4==ry, in which case ry trashed
@ can have rzl==rx
@ can have rzh==ry
@ can have rzl,rzh==rt3,rt4
.macro muls32_s32_64 rx,ry,rzl,rzh,rt0,rt1,rt2,rt3,rt4
                               @   t0   t1   t2   t3   t4
                               @                 ¯(x)  (y)
 uxth \rt0,\rx                 @   xl
 uxth \rt1,\ry                 @        yl
 muls \rt0,\rt1                @  xlyl=L
 asrs \rt2,\rx,#16             @            ¯xh
 muls \rt1,\rt2                @      ¯xhyl=M0
 asrs \rt4,\ry,#16             @                      ¯yh
 muls \rt2,\rt4                @          ¯xhyh=H
 uxth \rt3,\rx                 @                   xl
 muls \rt3,\rt4                @                ¯xlyh=M1
 adds \rt1,\rt3                @     ¯M0+M1=M
 asrs \rt3,\rt1,#31            @                  Msx
 bvc l\@_1                     @
 mvns \rt3,\rt3                @                 ¯Msx        flip sign extension bits if overflow
l\@_1:
 lsls \rt3,#16                 @                    ¯Msx<<16
 adds \rt2,\rt3                @             H'

                               @   t0   t1   t2   t3   t4
                               @                 (zl) (zh)
 lsls \rzl,\rt1,#16            @                  M~
 lsrs \rzh,\rt1,#16            @                       M~
 adds \rzl,\rt0                @                  ZL
 adcs \rzh,\rt2                @                      ¯ZH
.endm

@ can have rt2==rx, in which case rx trashed
@ can have rzl==rx
@ can have rzh==rt1
.macro square32_64 rx,rzl,rzh,rt0,rt1,rt2
                               @   t0   t1   t2   zl   zh
 uxth \rt0,\rx                 @   xl
 muls \rt0,\rt0                @ xlxl=L 
 uxth \rt1,\rx                 @        xl
 lsrs \rt2,\rx,#16             @             xh
 muls \rt1,\rt2                @      xlxh=M
 muls \rt2,\rt2                @           xhxh=H
 lsls \rzl,\rt1,#17            @                  ML
 lsrs \rzh,\rt1,#15            @                       MH
 adds \rzl,\rt0                @                  ZL
 adcs \rzh,\rt2                @                       ZH
.endm

.align 2
.thumb_func
__aeabi_dmul:
 push {r4-r7,r14}
 mdunpack r0,r1,r4,r6,r5
 mov r12,r4
 mdunpack r2,r3,r4,r7,r5
 eors r7,r6                    @ sign of result
 add r4,r12                    @ exponent of result
 push {r0-r2,r4,r7}

@ accumulate full product in r12:r5:r6:r7
 mul32_32_64 r0,r2, r0,r5, r4,r6,r7,r0,r5    @ XL*YL
 mov r12,r0                    @ save LL bits

 mul32_32_64 r1,r3, r6,r7, r0,r2,r4,r6,r7    @ XH*YH

 pop {r0}                      @ XL
 mul32_32_64 r0,r3, r0,r3, r1,r2,r4,r0,r3    @ XL*YH
 adds r5,r0
 adcs r6,r3
 movs r0,#0
 adcs r7,r0

 pop {r1,r2}                   @ XH,YL
 mul32_32_64 r1,r2, r1,r2, r0,r3,r4, r1,r2   @ XH*YL
 adds r5,r1
 adcs r6,r2
 movs r0,#0
 adcs r7,r0

@ here r5:r6:r7 holds the product [1..4) in Q(104-32)=Q72, with extra LSBs in r12
 pop {r3,r4}                   @ exponent in r3, sign in r4
 lsls r1,r7,#11
 lsrs r2,r6,#21
 orrs r1,r2
 lsls r0,r6,#11
 lsrs r2,r5,#21
 orrs r0,r2
 lsls r5,#11                   @ now r5:r0:r1 Q83=Q(51+32), extra LSBs in r12
 lsrs r2,r1,#20
 bne 1f                        @ skip if in range [2..4)
 adds r5,r5                    @ shift up so always [2..4) Q83, i.e. [1..2) Q84=Q(52+32)
 adcs r0,r0
 adcs r1,r1
 subs r3,#1                    @ correct exponent
1:
 ldr r6,=#0x3ff
 subs r3,r6                    @ correct for exponent bias
 lsls r6,#1                    @ 0x7fe
 cmp r3,r6
 bhs dm_0                      @ exponent over- or underflow
 lsls r5,#1                    @ rounding bit to carry
 bcc 1f                        @ result is correctly rounded
 adds r0,#1
 movs r6,#0
 adcs r1,r6                    @ round up
 mov r6,r12                    @ remaining sticky bits
 orrs r5,r6
 bne 1f                        @ some sticky bits set?
 lsrs r0,#1
 lsls r0,#1                    @ round to even
1:
 lsls r3,#20
 adds r1,r3
dm_2:
 lsls r4,#31
 add r1,r4
 pop {r4-r7,r15}

@ here for exponent over- or underflow
dm_0:
 bge dm_1                      @ overflow?
 adds r3,#1                    @ would-be zero exponent?
 bne 1f
 adds r0,#1
 bne 1f                        @ all-ones mantissa?
 adds r1,#1
 lsrs r7,r1,#21
 beq 1f
 lsrs r1,#1
 b dm_2
1:
 lsls r1,r4,#31
 movs r0,#0
 pop {r4-r7,r15}

@ here for exponent overflow
dm_1:
 adds r6,#1                    @ 0x7ff
 lsls r1,r6,#20
 movs r0,#0
 b dm_2

.ltorg

@ Approach to division y/x is as follows.
@
@ First generate u1, an approximation to 1/x to about 29 bits. Multiply this by the top
@ 32 bits of y to generate a0, a first approximation to the result (good to 28 bits or so).
@ Calculate the exact remainder r0=y-a0*x, which will be about 0. Calculate a correction
@ d0=r0*u1, and then write a1=a0+d0. If near a rounding boundary, compute the exact
@ remainder r1=y-a1*x (which can be done using r0 as a basis) to determine whether to
@ round up or down.
@
@ The calculation of 1/x is as given in dreciptest.c. That code verifies exhaustively
@ that | u1*x-1 | < 10*2^-32.
@
@ More precisely:
@
@ x0=(q16)x;
@ x1=(q30)x;
@ y0=(q31)y;
@ u0=(q15~)"(0xffffffffU/(unsigned int)roundq(x/x_ulp))/powq(2,16)"(x0); // q15 approximation to 1/x; "~" denotes rounding rather than truncation
@ v=(q30)(u0*x1-1);
@ u1=(q30)u0-(q30~)(u0*v);
@
@ a0=(q30)(u1*y0);
@ r0=(q82)y-a0*x;
@ r0x=(q57)r0;
@ d0=r0x*u1;
@ a1=d0+a0;
@
@ Error analysis
@
@ Use Greek letters to represent the errors introduced by rounding and truncation.
@
@               r₀ = y - a₀x
@                  = y - [ u₁ ( y - α ) - β ] x    where 0 ≤ α < 2^-31, 0 ≤ β < 2^-30
@                  = y ( 1 - u₁x ) + ( u₁α + β ) x
@
@     Hence
@
@       | r₀ / x | < 2 * 10*2^-32 + 2^-31 + 2^-30
@                  = 26*2^-32
@
@               r₁ = y - a₁x
@                  = y - a₀x - d₀x
@                  = r₀ - d₀x
@                  = r₀ - u₁ ( r₀ - γ ) x    where 0 ≤ γ < 2^-57
@                  = r₀ ( 1 - u₁x ) + u₁γx
@
@     Hence
@
@       | r₁ / x | < 26*2^-32 * 10*2^-32 + 2^-57
@                  = (260+128)*2^-64
@                  < 2^-55
@
@ Empirically it seems to be nearly twice as good as this.
@
@ To determine correctly whether the exact remainder calculation can be skipped we need a result
@ accurate to < 0.25ulp. In the case where x>y the quotient will be shifted up one place for normalisation
@ and so 1ulp is 2^-53 and so the calculation above suffices.

.align 2
.thumb_func
__aeabi_ddiv:
 push {r4-r7,r14}
ddiv0:                         @ entry point from dtan
 mdunpack r2,r3,r4,r7,r6       @ unpack divisor

@ unpack dividend by hand to save on register use
 lsrs r6,r1,#31
 adds r6,r7
 mov r12,r6                    @ result sign in r12b0; r12b1 trashed
 lsls r1,#1
 lsrs r7,r1,#21                @ exponent
 beq 1f                        @ zero exponent?
 adds r6,r7,#1
 lsrs r6,#11
 beq 2f                        @ exponent != 0x7ff? then done
1:
 movs r0,#0
 movs r1,#0
 subs r7,#64                   @ less drastic fiddling of exponents to get 0/0, Inf/Inf correct
 lsls r7,#12
2:
 subs r6,r7,r4
 lsls r6,#2
 add r12,r12,r6                @ (signed) exponent in r12[31..8]
 subs r7,#1                    @ implied 1
 lsls r7,#21
 subs r1,r7
 lsrs r1,#1

// see dreciptest-boxc.c
 lsrs r4,r3,#15 @ x2=x>>15; // Q5 32..63
 ldr r5,=#(rcpapp-32)
 ldrb r4,[r5,r4] @ u=lut5[x2-32]; // Q8
 lsls r5,r3,#8
 muls r5,r5,r4
 asrs r5,#14 @ e=(i32)(u*(x<<8))>>14; // Q22
 asrs r6,r5,#11
 muls r6,r6,r6 @ e2=(e>>11)*(e>>11); // Q22
 subs r5,r6
 muls r5,r5,r4 @ c=(e-e2)*u; // Q30
 lsls r6,r4,#7
 asrs r5,#14
 adds r5,#1
 asrs r5,#1
 subs r6,r5 @ u0=(u<<7)-((c+0x4000)>>15); // Q15

@ here
@ r0:r1 y mantissa
@ r2:r3 x mantissa
@ r6    u0, first approximation to 1/x Q15
@ r12: result sign, exponent

 lsls r4,r3,#10
 lsrs r5,r2,#22
 orrs r5,r4                    @ x1=(q30)x
 muls r5,r6                    @ u0*x1 Q45
 asrs r5,#15                   @ v=u0*x1-1 Q30
 muls r5,r6                    @ u0*v Q45
 asrs r5,#14
 adds r5,#1
 asrs r5,#1                    @ round u0*v to Q30
 lsls r6,#15
 subs r6,r5                    @ u1 Q30

@ here
@ r0:r1 y mantissa
@ r2:r3 x mantissa
@ r6    u1, second approximation to 1/x Q30
@ r12: result sign, exponent

 push {r2,r3}
 lsls r4,r1,#11
 lsrs r5,r0,#21
 orrs r4,r5                    @ y0=(q31)y
 mul32_32_64 r4,r6, r4,r5, r2,r3,r7,r4,r5  @ y0*u1 Q61
 adds r4,r4
 adcs r5,r5                    @ a0=(q30)(y0*u1)

@ here
@ r0:r1 y mantissa
@ r5    a0, first approximation to y/x Q30
@ r6    u1, second approximation to 1/x Q30
@ r12   result sign, exponent

 ldr r2,[r13,#0]               @ xL
 mul32_32_64 r2,r5, r2,r3, r1,r4,r7,r2,r3  @ xL*a0
 ldr r4,[r13,#4]               @ xH
 muls r4,r5                    @ xH*a0
 adds r3,r4                    @ r2:r3 now x*a0 Q82
 lsrs r2,#25
 lsls r1,r3,#7
 orrs r2,r1                    @ r2 now x*a0 Q57; r7:r2 is x*a0 Q89
 lsls r4,r0,#5                 @ y Q57
 subs r0,r4,r2                 @ r0x=y-x*a0 Q57 (signed)

@ here
@ r0  r0x Q57
@ r5  a0, first approximation to y/x Q30
@ r4  yL  Q57
@ r6  u1 Q30
@ r12 result sign, exponent

 muls32_32_64 r0,r6, r7,r6, r1,r2,r3, r7,r6   @ r7:r6 r0x*u1 Q87
 asrs r3,r6,#25
 adds r5,r3
 lsls r3,r6,#7                 @ r3:r5 a1 Q62 (but bottom 7 bits are zero so 55 bits of precision after binary point)
@ here we could recover another 7 bits of precision (but not accuracy) from the top of r7
@ but these bits are thrown away in the rounding and conversion to Q52 below

@ here
@ r3:r5  a1 Q62 candidate quotient [0.5,2) or so
@ r4     yL Q57
@ r12    result sign, exponent

 movs r6,#0
 adds r3,#128                  @ for initial rounding to Q53
 adcs r5,r5,r6
 lsrs  r1,r5,#30
 bne dd_0
@ here candidate quotient a1 is in range [0.5,1)
@ so 30 significant bits in r5

 lsls r4,#1                    @ y now Q58
 lsrs r1,r5,#9                 @ to Q52
 lsls r0,r5,#23
 lsrs r3,#9                    @ 0.5ulp-significance bit in carry: if this is 1 we may need to correct result
 orrs r0,r3
 bcs dd_1
 b dd_2
dd_0:
@ here candidate quotient a1 is in range [1,2)
@ so 31 significant bits in r5

 movs r2,#4
 add r12,r12,r2                @ fix exponent; r3:r5 now effectively Q61
 adds r3,#128                  @ complete rounding to Q53
 adcs r5,r5,r6
 lsrs r1,r5,#10
 lsls r0,r5,#22
 lsrs r3,#10                   @ 0.5ulp-significance bit in carry: if this is 1 we may need to correct result
 orrs r0,r3
 bcc dd_2
dd_1:

@ here
@ r0:r1  rounded result Q53 [0.5,1) or Q52 [1,2), but may not be correctly rounded-to-nearest
@ r4     yL Q58 or Q57
@ r12    result sign, exponent
@ carry set

 adcs r0,r0,r0
 adcs r1,r1,r1                 @ z Q53 with 1 in LSB
 lsls r4,#16                   @ Q105-32=Q73
 ldr r2,[r13,#0]               @ xL Q52
 ldr r3,[r13,#4]               @ xH Q20

 movs r5,r1                    @ zH Q21
 muls r5,r2                    @ zH*xL Q73
 subs r4,r5
 muls r3,r0                    @ zL*xH Q73
 subs r4,r3
 mul32_32_64 r2,r0, r2,r3, r5,r6,r7,r2,r3  @ xL*zL
 rsbs r2,#0                    @ borrow from low half?
 sbcs r4,r3                    @ y-xz Q73 (remainder bits 52..73)

 cmp r4,#0

 bmi 1f
 movs r2,#0                    @ round up
 adds r0,#1
 adcs r1,r2
1:
 lsrs r0,#1                    @ shift back down to Q52
 lsls r2,r1,#31
 orrs r0,r2
 lsrs r1,#1
dd_2:
 add r13,#8
 mov r2,r12
 lsls r7,r2,#31                @ result sign
 asrs r2,#2                    @ result exponent
 ldr r3,=#0x3fd
 adds r2,r3
 ldr r3,=#0x7fe
 cmp r2,r3
 bhs dd_3                      @ over- or underflow?
 lsls r2,#20
 adds r1,r2                    @ pack exponent
dd_5:
 adds r1,r7                    @ pack sign
 pop {r4-r7,r15}

dd_3:
 movs r0,#0
 cmp r2,#0
 bgt dd_4                      @ overflow?
 movs r1,r7
 pop {r4-r7,r15}

dd_4:
 adds r3,#1                    @ 0x7ff
 lsls r1,r3,#20
 b dd_5

/*
Approach to square root x=sqrt(y) is as follows.

First generate a3, an approximation to 1/sqrt(y) to about 30 bits. Multiply this by y
to give a4~sqrt(y) to about 28 bits and a remainder r4=y-a4^2. Then, because
d sqrt(y) / dy = 1 / (2 sqrt(y)) let d4=r4*a3/2 and then the value a5=a4+d4 is
a better approximation to sqrt(y). If this is near a rounding boundary we
compute an exact remainder y-a5*a5 to decide whether to round up or down.

The calculation of a3 and a4 is as given in dsqrttest.c. That code verifies exhaustively
that | 1 - a3a4 | < 10*2^-32, | r4 | < 40*2^-32 and | r4/y | < 20*2^-32.

More precisely, with "y" representing y truncated to 30 binary places:

u=(q3)y;                          // 24-entry table
a0=(q8~)"1/sqrtq(x+x_ulp/2)"(u);  // first approximation from table
p0=(q16)(a0*a0) * (q16)y;
r0=(q20)(p0-1);
dy0=(q15)(r0*a0);                 // Newton-Raphson correction term
a1=(q16)a0-dy0/2;                 // good to ~9 bits

p1=(q19)(a1*a1)*(q19)y;
r1=(q23)(p1-1);
dy1=(q15~)(r1*a1);                // second Newton-Raphson correction
a2x=(q16)a1-dy1/2;                // good to ~16 bits
a2=a2x-a2x/1t16;                  // prevent overflow of a2*a2 in 32 bits

p2=(a2*a2)*(q30)y;                // Q62
r2=(q36)(p2-1+1t-31);
dy2=(q30)(r2*a2);                 // Q52->Q30
a3=(q31)a2-dy2/2;                 // good to about 30 bits
a4=(q30)(a3*(q30)y+1t-31);        // good to about 28 bits

Error analysis

          r₄ = y - a₄²
          d₄ = 1/2 a₃r₄
          a₅ = a₄ + d₄
          r₅ = y - a₅²
             = y - ( a₄ + d₄ )²
             = y - a₄² - a₃a₄r₄ - 1/4 a₃²r₄²
             = r₄ - a₃a₄r₄ - 1/4 a₃²r₄²

      | r₅ | < | r₄ | | 1 - a₃a₄ | + 1/4 r₄²

          a₅ = √y √( 1 - r₅/y )
             = √y ( 1 - 1/2 r₅/y + ... )

So to first order (second order being very tiny)

     √y - a₅ = 1/2 r₅/y

and

 | √y - a₅ | < 1/2 ( | r₄/y | | 1 - a₃a₄ | + 1/4 r₄²/y )

From dsqrttest.c (conservatively):

             < 1/2 ( 20*2^-32 * 10*2^-32 + 1/4 * 40*2^-32*20*2^-32 )
             = 1/2 ( 200 + 200 ) * 2^-64
             < 2^-56

Empirically we see about 1ulp worst-case error including rounding at Q57.

To determine correctly whether the exact remainder calculation can be skipped we need a result
accurate to < 0.25ulp at Q52, or 2^-54.
*/

dq_2:
 bge dq_3                      @ +Inf?
 movs r1,#0
 b dq_4

dq_0:
 lsrs r1,#31
 lsls r1,#31                   @ preserve sign bit
 lsrs r2,#21                   @ extract exponent
 beq dq_4                      @ -0? return it
 asrs r1,#11                   @ make -Inf
 b dq_4

dq_3:
 ldr r1,=#0x7ff
 lsls r1,#20                   @ return +Inf
dq_4:
 movs r0,#0
dq_1:
 bx r14

.align 2
.thumb_func
_dsqrt:
 lsls r2,r1,#1
 bcs dq_0                      @ negative?
 lsrs r2,#21                   @ extract exponent
 subs r2,#1
 ldr r3,=#0x7fe
 cmp r2,r3
 bhs dq_2                      @ catches 0 and +Inf
 push {r4-r7,r14}
 lsls r4,r2,#20
 subs r1,r4                    @ insert implied 1
 lsrs r2,#1
 bcc 1f                        @ even exponent? skip
 adds r0,r0,r0                 @ odd exponent: shift up mantissa
 adcs r1,r1,r1
1:
 lsrs r3,#2
 adds r2,r3
 lsls r2,#20
 mov r12,r2                    @ save result exponent

@ here
@ r0:r1  y mantissa Q52 [1,4)
@ r12    result exponent

 adr r4,drsqrtapp-8            @ first eight table entries are never accessed because of the mantissa's leading 1
 lsrs r2,r1,#17                @ y Q3
 ldrb r2,[r4,r2]               @ initial approximation to reciprocal square root a0 Q8
 lsrs r3,r1,#4                 @ first Newton-Raphson iteration
 muls r3,r2
 muls r3,r2                    @  i32 p0=a0*a0*(y>>14);          // Q32
 asrs r3,r3,#12                @  i32 r0=p0>>12;                 // Q20
 muls r3,r2
 asrs r3,#13                   @  i32 dy0=(r0*a0)>>13;           // Q15
 lsls r2,#8
 subs r2,r3                    @  i32 a1=(a0<<8)-dy0;         // Q16

 movs r3,r2
 muls r3,r3
 lsrs r3,#13
 lsrs r4,r1,#1
 muls r3,r4                    @  i32 p1=((a1*a1)>>11)*(y>>11);  // Q19*Q19=Q38
 asrs r3,#15                   @  i32 r1=p1>>15;                 // Q23
 muls r3,r2
 asrs r3,#23
 adds r3,#1
 asrs r3,#1                    @  i32 dy1=(r1*a1+(1<<23))>>24;   // Q23*Q16=Q39; Q15
 subs r2,r3                    @  i32 a2=a1-dy1;                 // Q16
 lsrs r3,r2,#16
 subs r2,r3                    @  if(a2>=0x10000) a2=0xffff; to prevent overflow of a2*a2

@ here
@ r0:r1 y mantissa
@ r2    a2 ~ 1/sqrt(y) Q16
@ r12   result exponent

 movs r3,r2
 muls r3,r3
 lsls r1,#10
 lsrs r4,r0,#22
 orrs r1,r4                    @ y Q30
 mul32_32_64 r1,r3, r4,r3, r5,r6,r7,r4,r3   @  i64 p2=(ui64)(a2*a2)*(ui64)y;  // Q62 r4:r3
 lsls r5,r3,#6
 lsrs r4,#26
 orrs r4,r5
 adds r4,#0x20                 @  i32 r2=(p2>>26)+0x20;          // Q36 r4
 uxth r5,r4
 muls r5,r2
 asrs r4,#16
 muls r4,r2
 lsrs r5,#16
 adds r4,r5
 asrs r4,#6                    @ i32 dy2=((i64)r2*(i64)a2)>>22; // Q36*Q16=Q52; Q30
 lsls r2,#15
 subs r2,r4

@ here
@ r0    y low bits
@ r1    y Q30
@ r2    a3 ~ 1/sqrt(y) Q31
@ r12   result exponent

 mul32_32_64 r2,r1, r3,r4, r5,r6,r7,r3,r4
 adds r3,r3,r3
 adcs r4,r4,r4
 adds r3,r3,r3
 movs r3,#0
 adcs r3,r4                    @ ui32 a4=((ui64)a3*(ui64)y+(1U<<31))>>31; // Q30

@ here
@ r0    y low bits
@ r1    y Q30
@ r2    a3 Q31 ~ 1/sqrt(y)
@ r3    a4 Q30 ~ sqrt(y)
@ r12   result exponent

 square32_64 r3, r4,r5, r6,r5,r7
 lsls r6,r0,#8
 lsrs r7,r1,#2
 subs r6,r4
 sbcs r7,r5                    @ r4=(q60)y-a4*a4

@ by exhaustive testing, r4 = fffffffc0e134fdc .. 00000003c2bf539c Q60

 lsls r5,r7,#29
 lsrs r6,#3
 adcs r6,r5                    @ r4 Q57 with rounding
 muls32_32_64 r6,r2, r6,r2, r4,r5,r7,r6,r2    @ d4=a3*r4/2 Q89
@ r4+d4 is correct to 1ULP at Q57, tested on ~9bn cases including all extreme values of r4 for each possible y Q30

 adds r2,#8
 asrs r2,#5                    @ d4 Q52, rounded to Q53 with spare bit in carry

@ here
@ r0    y low bits
@ r1    y Q30
@ r2    d4 Q52, rounded to Q53
@ C flag contains d4_b53
@ r3    a4 Q30

 bcs dq_5

 lsrs r5,r3,#10                @ a4 Q52
 lsls r4,r3,#22

 asrs r1,r2,#31
 adds r0,r2,r4
 adcs r1,r5                    @ a4+d4

 add r1,r12                    @ pack exponent
 pop {r4-r7,r15}

.ltorg
 

@ round(sqrt(2^22./[68:8:252]))
drsqrtapp:
.byte 0xf8,0xeb,0xdf,0xd6,0xcd,0xc5,0xbe,0xb8
.byte 0xb2,0xad,0xa8,0xa4,0xa0,0x9c,0x99,0x95
.byte 0x92,0x8f,0x8d,0x8a,0x88,0x85,0x83,0x81

dq_5:
@ here we are near a rounding boundary, C is set
 adcs r2,r2,r2                 @ d4 Q53+1ulp
 lsrs r5,r3,#9
 lsls r4,r3,#23                @ r4:r5 a4 Q53
 asrs r1,r2,#31
 adds r4,r2,r4
 adcs r5,r1                    @ r4:r5 a5=a4+d4 Q53+1ulp
 movs r3,r5
 muls r3,r4
 square32_64 r4,r1,r2,r6,r2,r7
 adds r2,r3
 adds r2,r3                    @ r1:r2 a5^2 Q106
 lsls r0,#22                   @ y Q84

 rsbs r1,#0
 sbcs r0,r2                    @ remainder y-a5^2
 bmi 1f                        @ y<a5^2: no need to increment a5
 movs r3,#0
 adds r4,#1
 adcs r5,r3                    @ bump a5 if over rounding boundary
1:
 lsrs r0,r4,#1
 lsrs r1,r5,#1
 lsls r5,#31
 orrs r0,r5
 add r1,r12
 pop {r4-r7,r15}

@ compare r0:r1 against r2:r3, returning -1/0/1 for <, =, >
@ also set flags accordingly
.thumb_func
qfp_dcmp:
 push {r4,r6,r7,r14}
 ldr r7,=#0x7ff                @ flush NaNs and denormals
 lsls r4,r1,#1
 lsrs r4,#21
 beq 1f
 cmp r4,r7
 bne 2f
1:
 movs r0,#0
 lsrs r1,#20
 lsls r1,#20
2:
 lsls r4,r3,#1
 lsrs r4,#21
 beq 1f
 cmp r4,r7
 bne 2f
1:
 movs r2,#0
 lsrs r3,#20
 lsls r3,#20
2:
dcmp_fast_entry:
 movs r6,#1
 eors r3,r1
 bmi 4f                        @ opposite signs? then can proceed on basis of sign of x
 eors r3,r1                    @ restore r3
 bpl 1f
 rsbs r6,#0                    @ negative? flip comparison
1:
 cmp r1,r3
 bne 1f
 cmp r0,r2
 bhi 2f
 blo 3f
5:
 movs r6,#0                    @ equal? result is 0
1:
 bgt 2f
3:
 rsbs r6,#0
2:
 subs r0,r6,#0                 @ copy and set flags
 pop {r4,r6,r7,r15}
4:
 orrs r3,r1                    @ make -0==+0
 adds r3,r3
 orrs r3,r0
 orrs r3,r2
 beq 5b
 cmp r1,#0
 bge 2b
 b 3b
 

@ "scientific" functions start here

.thumb_func
push_r8_r11:
 mov r4,r8
 mov r5,r9
 mov r6,r10
 mov r7,r11
 push {r4-r7}
 bx r14

.thumb_func
pop_r8_r11:
 pop {r4-r7}
 mov r8,r4
 mov r9,r5
 mov r10,r6
 mov r11,r7
 bx r14

@ double-length CORDIC rotation step

@ r0:r1   ω
@ r6      32-i (complementary shift)
@ r7      i (shift)
@ r8:r9   x
@ r10:r11 y
@ r12     coefficient pointer

@ an option in rotation mode would be to compute the sequence of σ values
@ in one pass, rotate the initial vector by the residual ω and then run a
@ second pass to compute the final x and y. This would relieve pressure
@ on registers and hence possibly be faster. The same trick does not work
@ in vectoring mode (but perhaps one could work to single precision in
@ a first pass and then double precision in a second pass?).

.thumb_func
dcordic_vec_step:
 mov r2,r12
 ldmia r2!,{r3,r4}
 mov r12,r2
 mov r2,r11
 cmp r2,#0
 blt 1f
 b 2f

.thumb_func
dcordic_rot_step:
 mov r2,r12
 ldmia r2!,{r3,r4}
 mov r12,r2
 cmp r1,#0
 bge 1f
2:
@ ω<0 / y>=0
@ ω+=dω
@ x+=y>>i, y-=x>>i
 adds r0,r3
 adcs r1,r4

 mov r3,r11
 asrs r3,r7
 mov r4,r11
 lsls r4,r6
 mov r2,r10
 lsrs r2,r7
 orrs r2,r4                    @ r2:r3 y>>i, rounding in carry
 mov r4,r8
 mov r5,r9                     @ r4:r5 x
 adcs r2,r4
 adcs r3,r5                    @ r2:r3 x+(y>>i)
 mov r8,r2
 mov r9,r3

 mov r3,r5
 lsls r3,r6
 asrs r5,r7
 lsrs r4,r7
 orrs r4,r3                    @ r4:r5 x>>i, rounding in carry
 mov r2,r10
 mov r3,r11
 sbcs r2,r4
 sbcs r3,r5                    @ r2:r3 y-(x>>i)
 mov r10,r2
 mov r11,r3
 bx r14


@ ω>0 / y<0
@ ω-=dω
@ x-=y>>i, y+=x>>i
1:
 subs r0,r3
 sbcs r1,r4

 mov r3,r9
 asrs r3,r7
 mov r4,r9
 lsls r4,r6
 mov r2,r8
 lsrs r2,r7
 orrs r2,r4                    @ r2:r3 x>>i, rounding in carry
 mov r4,r10
 mov r5,r11                    @ r4:r5 y
 adcs r2,r4
 adcs r3,r5                    @ r2:r3 y+(x>>i)
 mov r10,r2
 mov r11,r3

 mov r3,r5
 lsls r3,r6
 asrs r5,r7
 lsrs r4,r7
 orrs r4,r3                    @ r4:r5 y>>i, rounding in carry
 mov r2,r8
 mov r3,r9
 sbcs r2,r4
 sbcs r3,r5                    @ r2:r3 x-(y>>i)
 mov r8,r2
 mov r9,r3
 bx r14

ret_dzero:
 movs r0,#0
 movs r1,#0
 bx r14

@ convert packed double in r0:r1 to signed/unsigned 32/64-bit integer/fixed-point value in r0:r1 [with r2 places after point], with rounding towards -Inf
@ fixed-point versions only work with reasonable values in r2 because of the way dunpacks works

.thumb_func
_dfix:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_double2fix:
 push {r14}
 adds r2,#32
 bl qfp_double2fix64
 movs r0,r1
 pop {r15}

.thumb_func
_dfixu:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_double2ufix:
 push {r14}
 adds r2,#32
 bl qfp_double2ufix64
 movs r0,r1
 pop {r15}

.thumb_func
_ll_sfrom_f:
 movs r1,#0                    @ and fall through
.thumb_func
qfp_float2fix64:
 push {r14}
 bl f2fix
 b d2f64_a

.thumb_func
_ll_ufrom_f:
 movs r1,#0                    @ and fall through
.thumb_func
qfp_float2ufix64:
 asrs r3,r0,#23                @ negative? return 0
 bmi ret_dzero
@ and fall through

@ convert float in r0 to signed fixed point in r0:r1:r3, r1 places after point, rounding towards -Inf
@ result clamped so that r3 can only be 0 or -1
@ trashes r12
.thumb_func
f2fix:
 push {r4,r14}
 mov r12,r1
 asrs r3,r0,#31
 lsls r0,#1
 lsrs r2,r0,#24
 beq 1f                        @ zero?
 cmp r2,#0xff                  @ Inf?
 beq 2f
 subs r1,r2,#1
 subs r2,#0x7f                 @ remove exponent bias
 lsls r1,#24
 subs r0,r1                    @ insert implied 1
 eors r0,r3
 subs r0,r3                    @ top two's complement
 asrs r1,r0,#4                 @ convert to double format
 lsls r0,#28
 b d2fix_a
1:
 movs r0,#0
 movs r1,r0
 movs r3,r0
 pop {r4,r15}
2:
 mvns r0,r3                    @ return max/min value
 mvns r1,r3
 pop {r4,r15}

.thumb_func
_ll_sfrom_d:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_double2fix64:
 push {r14}
 bl d2fix
d2f64_a:
 asrs r2,r1,#31
 cmp r2,r3
 bne 1f                        @ sign extension bits fail to match sign of result?
 pop {r15}
1:
 mvns r0,r3
 movs r1,#1
 lsls r1,#31
 eors r1,r1,r0                 @ generate extreme fixed-point values
 pop {r15}

.thumb_func
_ll_ufrom_d:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_double2ufix64:
 asrs r3,r1,#20                @ negative? return 0
 bmi ret_dzero
@ and fall through

@ convert double in r0:r1 to signed fixed point in r0:r1:r3, r2 places after point, rounding towards -Inf
@ result clamped so that r3 can only be 0 or -1
@ trashes r12
.thumb_func
d2fix:
 push {r4,r14}
 mov r12,r2
 bl dunpacks
 asrs r4,r2,#16
 adds r4,#1
 bge 1f
 movs r1,#0                    @ -0 -> +0
1:
 asrs r3,r1,#31
d2fix_a:
@ here
@ r0:r1 two's complement mantissa
@ r2    unbaised exponent
@ r3    mantissa sign extension bits
 add r2,r12                    @ exponent plus offset for required binary point position
 subs r2,#52                   @ required shift
 bmi 1f                        @ shift down?
@ here a shift up by r2 places
 cmp r2,#12                    @ will clamp?
 bge 2f
 movs r4,r0
 lsls r1,r2
 lsls r0,r2
 rsbs r2,#0
 adds r2,#32                   @ complementary shift
 lsrs r4,r2
 orrs r1,r4
 pop {r4,r15}
2:
 mvns r0,r3
 mvns r1,r3                    @ overflow: clamp to extreme fixed-point values
 pop {r4,r15}
1:
@ here a shift down by -r2 places
 adds r2,#32
 bmi 1f                        @ long shift?
 mov r4,r1
 lsls r4,r2
 rsbs r2,#0
 adds r2,#32                   @ complementary shift
 asrs r1,r2
 lsrs r0,r2
 orrs r0,r4
 pop {r4,r15}
1:
@ here a long shift down
 movs r0,r1
 asrs r1,#31                   @ shift down 32 places
 adds r2,#32
 bmi 1f                        @ very long shift?
 rsbs r2,#0
 adds r2,#32
 asrs r0,r2
 pop {r4,r15}
1:
 movs r0,r3                    @ result very near zero: use sign extension bits
 movs r1,r3
 pop {r4,r15}

@ float <-> double conversions
.thumb_func
__aeabi_f2d:
 lsrs r3,r0,#31                @ sign bit
 lsls r3,#31
 lsls r1,r0,#1
 lsrs r2,r1,#24                @ exponent
 beq 1f                        @ zero?
 cmp r2,#0xff                  @ Inf?
 beq 2f
 lsrs r1,#4                    @ exponent and top 20 bits of mantissa
 ldr r2,=#(0x3ff-0x7f)<<20     @ difference in exponent offsets
 adds r1,r2
 orrs r1,r3
 lsls r0,#29                   @ bottom 3 bits of mantissa
 bx r14
1:
 movs r1,r3                    @ return signed zero
3:
 movs r0,#0
 bx r14
2:
 ldr r1,=#0x7ff00000           @ return signed infinity
 adds r1,r3
 b 3b

.thumb_func
__aeabi_d2f:
 lsls r2,r1,#1
 lsrs r2,#21                   @ exponent
 ldr r3,=#0x3ff-0x7f
 subs r2,r3                    @ fix exponent bias
 ble 1f                        @ underflow or zero
 cmp r2,#0xff
 bge 2f                        @ overflow or infinity
 lsls r2,#23                   @ position exponent of result
 lsrs r3,r1,#31
 lsls r3,#31
 orrs r2,r3                    @ insert sign
 lsls r3,r0,#3                 @ rounding bits
 lsrs r0,#29
 lsls r1,#12
 lsrs r1,#9
 orrs r0,r1                    @ assemble mantissa
 orrs r0,r2                    @ insert exponent and sign
 lsls r3,#1
 bcc 3f                        @ no rounding
 beq 4f                        @ all sticky bits 0?
5:
 adds r0,#1
3:
 bx r14
4:
 lsrs r3,r0,#1                 @ odd? then round up
 bcs 5b
 bx r14
1:
 beq 6f                        @ check case where value is just less than smallest normal
7:
 lsrs r0,r1,#31
 lsls r0,#31
 bx r14
6:
 lsls r2,r1,#12                @ 20 1:s at top of mantissa?
 asrs r2,#12
 adds r2,#1
 bne 7b
 lsrs r2,r0,#29                @ and 3 more 1:s?
 cmp r2,#7
 bne 7b
 movs r2,#1                    @ return smallest normal with correct sign
 b 8f
2:
 movs r2,#0xff
8:
 lsrs r0,r1,#31                @ return signed infinity
 lsls r0,#8
 adds r0,r2
 lsls r0,#23
 bx r14

@ convert signed/unsigned 32/64-bit integer/fixed-point value in r0:r1 [with r2 places after point] to packed double in r0:r1, with rounding

.thumb_func
_dfltu:
 movs r1,#0                    @ and fall through
.thumb_func
qfp_ufix2double:
 movs r2,r1
 movs r1,#0
 b qfp_ufix642double

.thumb_func
_dflt:
 movs r1,#0                    @ and fall through
.thumb_func
qfp_fix2double:
 movs r2,r1
 asrs r1,r0,#31                @ sign extend
 b qfp_fix642double

.thumb_func
_ll_uto_d:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_ufix642double:
 movs r3,#0
 b uf2d

.thumb_func
_ll_sto_d:
 movs r2,#0                    @ and fall through
.thumb_func
qfp_fix642double:
 asrs r3,r1,#31                @ sign bit across all bits
 eors r0,r3
 eors r1,r3
 subs r0,r3
 sbcs r1,r3
uf2d:
 push {r4,r5,r14}
 ldr r4,=#0x432
 subs r2,r4,r2                 @ form biased exponent
@ here
@ r0:r1 unnormalised mantissa
@ r2 -Q (will become exponent)
@ r3 sign across all bits
 cmp r1,#0
 bne 1f                        @ short normalising shift?
 movs r1,r0
 beq 2f                        @ zero? return it
 movs r0,#0
 subs r2,#32                   @ fix exponent
1:
 asrs r4,r1,#21
 bne 3f                        @ will need shift down (and rounding?)
 bcs 4f                        @ normalised already?
5:
 subs r2,#1
 adds r0,r0                    @ shift up
 adcs r1,r1
 lsrs r4,r1,#21
 bcc 5b
4:
 ldr r4,=#0x7fe
 cmp r2,r4
 bhs 6f                        @ over/underflow? return signed zero/infinity
7:
 lsls r2,#20                   @ pack and return
 adds r1,r2
 lsls r3,#31
 adds r1,r3
2:
 pop {r4,r5,r15}
6:                             @ return signed zero/infinity according to unclamped exponent in r2
 mvns r2,r2
 lsrs r2,#21
 movs r0,#0
 movs r1,#0
 b 7b

3:
@ here we need to shift down to normalise and possibly round
 bmi 1f                        @ already normalised to Q63?
2:
 subs r2,#1
 adds r0,r0                    @ shift up
 adcs r1,r1
 bpl 2b
1:
@ here we have a 1 in b63 of r0:r1
 adds r2,#11                   @ correct exponent for subsequent shift down
 lsls r4,r0,#21                @ save bits for rounding
 lsrs r0,#11
 lsls r5,r1,#21
 orrs r0,r5
 lsrs r1,#11
 lsls r4,#1
 beq 1f                        @ sticky bits are zero?
8:
 movs r4,#0
 adcs r0,r4
 adcs r1,r4
 b 4b
1:
 bcc 4b                        @ sticky bits are zero but not on rounding boundary
 lsrs r4,r0,#1                 @ increment if odd (force round to even)
 b 8b


.ltorg

.thumb_func
dunpacks:
 mdunpacks r0,r1,r2,r3,r4
 ldr r3,=#0x3ff
 subs r2,r3                    @ exponent without offset
 bx r14

@ r0:r1  signed mantissa Q52
@ r2     unbiased exponent < 10 (i.e., |x|<2^10)
@ r4     pointer to:
@          - divisor reciprocal approximation r=1/d Q15
@          - divisor d Q62  0..20
@          - divisor d Q62 21..41
@          - divisor d Q62 42..62
@ returns:
@ r0:r1  reduced result y Q62, -0.6 d < y < 0.6 d (better in practice)
@ r2     quotient q (number of reductions)
@ if exponent >=10, returns r0:r1=0, r2=1024*mantissa sign
@ designed to work for 0.5<d<2, in particular d=ln2 (~0.7) and d=π/2 (~1.6)
@ .thumb_func
@ dreduce:
@  adds r2,#2                    @ e+2
@  bmi 1f                        @ |x|<0.25, too small to need adjustment
@  cmp r2,#12
@  bge 4f
@ 2:
@  movs r5,#17
@  subs r5,r2                    @ 15-e
@  movs r3,r1                    @ Q20
@  asrs r3,r5                    @ x Q5
@  adds r2,#8                    @ e+10
@  adds r5,#7                    @ 22-e = 32-(e+10)
@  movs r6,r0
@  lsrs r6,r5
@  lsls r0,r2
@  lsls r1,r2
@  orrs r1,r6                    @ r0:r1 x Q62
@  ldmia r4,{r4-r7}
@  muls r3,r4                    @ rx Q20
@  asrs r2,r3,#20
@  movs r3,#0
@  adcs r2,r3                    @ rx Q0 rounded = q; for e.g. r=1.5 |q|<1.5*2^10
@  muls r5,r2                    @ qd in pieces: L Q62
@  muls r6,r2                    @               M Q41
@  muls r7,r2                    @               H Q20
@  lsls r7,#10
@  asrs r4,r6,#11
@  lsls r6,#21
@  adds r6,r5
@  adcs r7,r4
@  asrs r5,#31
@  adds r7,r5                    @ r6:r7 qd Q62
@  subs r0,r6
@  sbcs r1,r7                    @ remainder Q62
@  bx r14
@ 4:
@  movs r2,#12                   @ overflow: clamp to +/-1024
@  movs r0,#0
@  asrs r1,#31
@  lsls r1,#1
@  adds r1,#1
@  lsls r1,#20
@  b 2b

@ 1:
@  lsls r1,#8
@  lsrs r3,r0,#24
@  orrs r1,r3
@  lsls r0,#8                    @ r0:r1 Q60, to be shifted down -r2 places
@  rsbs r3,r2,#0
@  adds r2,#32                   @ shift down in r3, complementary shift in r2
@  bmi 1f                        @ long shift?
@ 2:
@  movs r4,r1
@  asrs r1,r3
@  lsls r4,r2
@  lsrs r0,r3
@  orrs r0,r4
@  movs r2,#0                    @ rounding
@  adcs r0,r2
@  adcs r1,r2
@  bx r14

@ 1:
@  movs r0,r1                    @ down 32 places
@  asrs r1,#31
@  subs r3,#32
@  adds r2,#32
@  bpl 2b
@  movs r0,#0                    @ very long shift? return 0
@  movs r1,#0
@  movs r2,#0
@  bx r14

@ .thumb_func
@ qfp_dtan:
@  push {r4-r7,r14}
@  bl push_r8_r11
@  bl dsincos
@  mov r12,r0                    @ save ε
@  bl dcos_finish
@  push {r0,r1}
@  mov r0,r12
@  bl dsin_finish
@  pop {r2,r3}
@  bl pop_r8_r11
@  b ddiv0                       @ compute sin θ/cos θ

@ .thumb_func
@ qfp_dcos:
@  push {r4-r7,r14}
@  bl push_r8_r11
@  bl dsincos
@  bl dcos_finish
@  b 1f

@ .thumb_func
@ qfp_dsin:
@  push {r4-r7,r14}
@  bl push_r8_r11
@  bl dsincos
@  bl dsin_finish
@ 1:
@  bl pop_r8_r11
@  pop {r4-r7,r15}


@ @ unpack double θ in r0:r1, range reduce and calculate ε, cos α and sin α such that
@ @ θ=α+ε and |ε|≤2^-32
@ @ on return:
@ @ r0:r1   ε (residual ω, where θ=α+ε) Q62, |ε|≤2^-32 (so fits in r0)
@ @ r8:r9   cos α Q62
@ @ r10:r11 sin α Q62
@ .thumb_func
@ dsincos:
@  push {r14}
@  bl dunpacks
@  adr r4,dreddata0
@  bl dreduce

@  movs r4,#0
@  ldr r5,=#0x9df04dbb           @ this value compensates for the non-unity scaling of the CORDIC rotations
@  ldr r6,=#0x36f656c5
@  lsls r2,#31
@  bcc 1f
@ @ quadrant 2 or 3
@  mvns r6,r6
@  rsbs r5,r5,#0
@  adcs r6,r4
@ 1:
@  lsls r2,#1
@  bcs 1f
@ @ even quadrant
@  mov r10,r4
@  mov r11,r4
@  mov r8,r5
@  mov r9,r6
@  b 2f
@ 1:
@ @ odd quadrant
@  mov r8,r4
@  mov r9,r4
@  mov r10,r5
@  mov r11,r6
@ 2:
@  adr r4,dtab_cc
@  mov r12,r4
@  movs r7,#1
@  movs r6,#31
@ 1:
@  bl dcordic_rot_step
@  adds r7,#1
@  subs r6,#1
@  cmp r7,#33
@  bne 1b
@  pop {r15}

@ dcos_finish:
@ @ here
@ @ r0:r1   ε (residual ω, where θ=α+ε) Q62, |ε|≤2^-32 (so fits in r0)
@ @ r8:r9   cos α Q62
@ @ r10:r11 sin α Q62
@ @ and we wish to calculate cos θ=cos(α+ε)~cos α - ε sin α
@  mov r1,r11
@ @ mov r2,r10
@ @ lsrs r2,#31
@ @ adds r1,r2                    @ rounding improves accuracy very slightly
@  muls32_s32_64 r0,r1, r2,r3, r4,r5,r6,r2,r3
@ @ r2:r3   ε sin α Q(62+62-32)=Q92
@  mov r0,r8
@  mov r1,r9
@  lsls r5,r3,#2
@  asrs r3,r3,#30
@  lsrs r2,r2,#30
@  orrs r2,r5
@  sbcs r0,r2                    @ include rounding
@  sbcs r1,r3
@  movs r2,#62
@  b qfp_fix642double

@ dsin_finish:
@ @ here
@ @ r0:r1   ε (residual ω, where θ=α+ε) Q62, |ε|≤2^-32 (so fits in r0)
@ @ r8:r9   cos α Q62
@ @ r10:r11 sin α Q62
@ @ and we wish to calculate sin θ=sin(α+ε)~sin α + ε cos α
@  mov r1,r9
@  muls32_s32_64 r0,r1, r2,r3, r4,r5,r6,r2,r3
@ @ r2:r3   ε cos α Q(62+62-32)=Q92
@  mov r0,r10
@  mov r1,r11
@  lsls r5,r3,#2
@  asrs r3,r3,#30
@  lsrs r2,r2,#30
@  orrs r2,r5
@  adcs r0,r2                    @ include rounding
@  adcs r1,r3
@  movs r2,#62
@  b qfp_fix642double

@ .ltorg
@ .align 2
@ dreddata0:
@ .word 0x0000517d               @ 2/π Q15
@ .word 0x0014611A               @ π/2 Q62=6487ED5110B4611A split into 21-bit pieces
@ .word 0x000A8885
@ .word 0x001921FB

@ .thumb_func
@ qfp_datan2:
@ @ r0:r1 y
@ @ r2:r3 x
@  push {r4-r7,r14}
@  bl push_r8_r11
@  ldr r5,=#0x7ff00000
@  movs r4,r1
@  ands r4,r5                    @ y==0?
@  beq 1f
@  cmp r4,r5                     @ or Inf/NaN?
@  bne 2f
@ 1:
@  lsrs r1,#20                   @ flush
@  lsls r1,#20
@  movs r0,#0
@ 2:
@  movs r4,r3
@  ands r4,r5                    @ x==0?
@  beq 1f
@  cmp r4,r5                     @ or Inf/NaN?
@  bne 2f
@ 1:
@  lsrs r3,#20                   @ flush
@  lsls r3,#20
@  movs r2,#0
@ 2:
@  movs r6,#0                    @ quadrant offset
@  lsls r5,#11                   @ constant 0x80000000
@  cmp r3,#0
@  bpl 1f                        @ skip if x positive
@  movs r6,#2
@  eors r3,r5
@  eors r1,r5
@  bmi 1f                        @ quadrant offset=+2 if y was positive
@  rsbs r6,#0                    @ quadrant offset=-2 if y was negative
@ 1:
@ @ now in quadrant 0 or 3
@  adds r7,r1,r5                 @ r7=-r1
@  bpl 1f
@ @ y>=0: in quadrant 0
@  cmp r1,r3
@  ble 2f                        @ y<~x so 0≤θ<~π/4: skip
@  adds r6,#1
@  eors r1,r5                    @ negate x
@  b 3f                          @ and exchange x and y = rotate by -π/2
@ 1:
@  cmp r3,r7
@  bge 2f                        @ -y<~x so -π/4<~θ≤0: skip
@  subs r6,#1
@  eors r3,r5                    @ negate y and ...
@ 3:
@  movs r7,r0                    @ exchange x and y
@  movs r0,r2
@  movs r2,r7
@  movs r7,r1
@  movs r1,r3
@  movs r3,r7
@ 2:
@ @ here -π/4<~θ<~π/4
@ @ r6 has quadrant offset
@  push {r6}
@  cmp r2,#0
@  bne 1f
@  cmp r3,#0
@  beq 10f                       @ x==0 going into division?
@  lsls r4,r3,#1
@  asrs r4,#21
@  adds r4,#1
@  bne 1f                        @ x==Inf going into division?
@  lsls r4,r1,#1
@  asrs r4,#21
@  adds r4,#1                    @ y also ±Inf?
@  bne 10f
@  subs r1,#1                    @ make them both just finite
@  subs r3,#1
@  b 1f

@ 10:
@  movs r0,#0
@  movs r1,#0
@  b 12f
 
@ 1:
@  bl __aeabi_ddiv
@  movs r2,#62
@  bl qfp_double2fix64
@ @ r0:r1 y/x
@  mov r10,r0
@  mov r11,r1
@  movs r0,#0                    @ ω=0
@  movs r1,#0
@  mov r8,r0
@  movs r2,#1
@  lsls r2,#30
@  mov r9,r2                     @ x=1

@  adr r4,dtab_cc
@  mov r12,r4
@  movs r7,#1
@  movs r6,#31
@ 1:
@  bl dcordic_vec_step
@  adds r7,#1
@  subs r6,#1
@  cmp r7,#33
@  bne 1b
@ @ r0:r1   atan(y/x) Q62
@ @ r8:r9   x residual Q62
@ @ r10:r11 y residual Q62
@  mov r2,r9
@  mov r3,r10
@  subs r2,#12                   @ this makes atan(0)==0
@ @ the following is basically a division residual y/x ~ atan(residual y/x)
@  movs r4,#1
@  lsls r4,#29
@  movs r7,#0
@ 2:
@  lsrs r2,#1
@  movs r3,r3                    @ preserve carry
@  bmi 1f
@  sbcs r3,r2
@  adds r0,r4
@  adcs r1,r7
@  lsrs r4,#1
@  bne 2b
@  b 3f
@ 1:
@  adcs r3,r2
@  subs r0,r4
@  sbcs r1,r7
@  lsrs r4,#1
@  bne 2b
@ 3:
@  lsls r6,r1,#31
@  asrs r1,#1
@  lsrs r0,#1
@  orrs r0,r6                    @ Q61

@ 12:
@  pop {r6}

@  cmp r6,#0
@  beq 1f
@  ldr r4,=#0x885A308D           @ π/2 Q61
@  ldr r5,=#0x3243F6A8
@  bpl 2f
@  mvns r4,r4                    @ negative quadrant offset
@  mvns r5,r5
@ 2:
@  lsls r6,#31
@  bne 2f                        @ skip if quadrant offset is ±1
@  adds r0,r4
@  adcs r1,r5
@ 2:
@  adds r0,r4
@  adcs r1,r5
@ 1:
@  movs r2,#61
@  bl qfp_fix642double

@  bl pop_r8_r11
@  pop {r4-r7,r15}

@ .ltorg

@ dtab_cc:
@ .word 0x61bb4f69, 0x1dac6705   @ atan 2^-1 Q62
@ .word 0x96406eb1, 0x0fadbafc   @ atan 2^-2 Q62
@ .word 0xab0bdb72, 0x07f56ea6   @ atan 2^-3 Q62
@ .word 0xe59fbd39, 0x03feab76   @ atan 2^-4 Q62
@ .word 0xba97624b, 0x01ffd55b   @ atan 2^-5 Q62
@ .word 0xdddb94d6, 0x00fffaaa   @ atan 2^-6 Q62
@ .word 0x56eeea5d, 0x007fff55   @ atan 2^-7 Q62
@ .word 0xaab7776e, 0x003fffea   @ atan 2^-8 Q62
@ .word 0x5555bbbc, 0x001ffffd   @ atan 2^-9 Q62
@ .word 0xaaaaadde, 0x000fffff   @ atan 2^-10 Q62
@ .word 0xf555556f, 0x0007ffff   @ atan 2^-11 Q62
@ .word 0xfeaaaaab, 0x0003ffff   @ atan 2^-12 Q62
@ .word 0xffd55555, 0x0001ffff   @ atan 2^-13 Q62
@ .word 0xfffaaaab, 0x0000ffff   @ atan 2^-14 Q62
@ .word 0xffff5555, 0x00007fff   @ atan 2^-15 Q62
@ .word 0xffffeaab, 0x00003fff   @ atan 2^-16 Q62
@ .word 0xfffffd55, 0x00001fff   @ atan 2^-17 Q62
@ .word 0xffffffab, 0x00000fff   @ atan 2^-18 Q62
@ .word 0xfffffff5, 0x000007ff   @ atan 2^-19 Q62
@ .word 0xffffffff, 0x000003ff   @ atan 2^-20 Q62
@ .word 0x00000000, 0x00000200   @ atan 2^-21 Q62 @ consider optimising these
@ .word 0x00000000, 0x00000100   @ atan 2^-22 Q62
@ .word 0x00000000, 0x00000080   @ atan 2^-23 Q62
@ .word 0x00000000, 0x00000040   @ atan 2^-24 Q62
@ .word 0x00000000, 0x00000020   @ atan 2^-25 Q62
@ .word 0x00000000, 0x00000010   @ atan 2^-26 Q62
@ .word 0x00000000, 0x00000008   @ atan 2^-27 Q62
@ .word 0x00000000, 0x00000004   @ atan 2^-28 Q62
@ .word 0x00000000, 0x00000002   @ atan 2^-29 Q62
@ .word 0x00000000, 0x00000001   @ atan 2^-30 Q62
@ .word 0x80000000, 0x00000000   @ atan 2^-31 Q62
@ .word 0x40000000, 0x00000000   @ atan 2^-32 Q62

@ .thumb_func
@ qfp_dexp:
@  push {r4-r7,r14}
@  bl dunpacks
@  adr r4,dreddata1
@  bl dreduce
@  cmp r1,#0
@  bge 1f
@  ldr r4,=#0xF473DE6B
@  ldr r5,=#0x2C5C85FD           @ ln2 Q62
@  adds r0,r4
@  adcs r1,r5
@  subs r2,#1
@ 1:
@  push {r2}
@  movs r7,#1                    @ shift
@  adr r6,dtab_exp
@  movs r2,#0
@  movs r3,#1
@  lsls r3,#30                   @ x=1 Q62

@ 3:
@  ldmia r6!,{r4,r5}
@  mov r12,r6
@  subs r0,r4
@  sbcs r1,r5
@  bmi 1f

@  rsbs r6,r7,#0
@  adds r6,#32                   @ complementary shift
@  movs r5,r3
@  asrs r5,r7
@  movs r4,r3
@  lsls r4,r6
@  movs r6,r2
@  lsrs r6,r7                    @ rounding bit in carry
@  orrs r4,r6
@  adcs r2,r4
@  adcs r3,r5                    @ x+=x>>i
@  b 2f

@ 1:
@  adds r0,r4                    @ restore argument
@  adcs r1,r5
@ 2:
@  mov r6,r12
@  adds r7,#1
@  cmp r7,#33
@  bne 3b

@ @ here
@ @ r0:r1   ε (residual x, where x=a+ε) Q62, |ε|≤2^-32 (so fits in r0)
@ @ r2:r3   exp a Q62
@ @ and we wish to calculate exp x=exp a exp ε~(exp a)(1+ε)
@  muls32_32_64 r0,r3, r4,r1, r5,r6,r7,r4,r1
@ @ r4:r1 ε exp a Q(62+62-32)=Q92
@  lsrs r4,#30
@  lsls r0,r1,#2
@  orrs r0,r4
@  asrs r1,#30
@  adds r0,r2
@  adcs r1,r3

@  pop {r2}
@  rsbs r2,#0
@  adds r2,#62
@  bl qfp_fix642double                 @ in principle we can pack faster than this because we know the exponent
@  pop {r4-r7,r15}

@ .ltorg

@ .thumb_func
@ qfp_dln:
@  push {r4-r7,r14}
@  lsls r7,r1,#1
@  bcs 5f                        @ <0 ...
@  asrs r7,#21
@  beq 5f                        @ ... or =0? return -Inf
@  adds r7,#1
@  beq 6f                        @ Inf/NaN? return +Inf
@  bl dunpacks
@  push {r2}
@  lsls r1,#9
@  lsrs r2,r0,#23
@  orrs r1,r2
@  lsls r0,#9
@ @ r0:r1 m Q61 = m/2 Q62 0.5≤m/2<1

@  movs r7,#1                    @ shift
@  adr r6,dtab_exp
@  mov r12,r6
@  movs r2,#0
@  movs r3,#0                    @ y=0 Q62

@ 3:
@  rsbs r6,r7,#0
@  adds r6,#32                   @ complementary shift
@  movs r5,r1
@  asrs r5,r7
@  movs r4,r1
@  lsls r4,r6
@  movs r6,r0
@  lsrs r6,r7
@  orrs r4,r6                    @ x>>i, rounding bit in carry
@  adcs r4,r0
@  adcs r5,r1                    @ x+(x>>i)

@  lsrs r6,r5,#30
@  bne 1f                        @ x+(x>>i)>1?
@  movs r0,r4
@  movs r1,r5                    @ x+=x>>i
@  mov r6,r12
@  ldmia r6!,{r4,r5}
@  subs r2,r4
@  sbcs r3,r5

@ 1:
@  movs r4,#8
@  add r12,r4
@  adds r7,#1
@  cmp r7,#33
@  bne 3b
@ @ here:
@ @ r0:r1 residual x, nearly 1 Q62
@ @ r2:r3 y ~ ln m/2 = ln m - ln2 Q62
@ @ result is y + ln2 + ln x ~ y + ln2 + (x-1)
@  lsls r1,#2
@  asrs r1,#2                    @ x-1
@  adds r2,r0
@  adcs r3,r1

@  pop {r7}
@ @ here:
@ @ r2:r3 ln m/2 = ln m - ln2 Q62
@ @ r7    unbiased exponent

@  adr r4,dreddata1+4
@  ldmia r4,{r0,r1,r4}
@  adds r7,#1
@  muls r0,r7                    @ Q62
@  muls r1,r7                    @ Q41
@  muls r4,r7                    @ Q20
@  lsls r7,r1,#21
@  asrs r1,#11
@  asrs r5,r1,#31
@  adds r0,r7
@  adcs r1,r5
@  lsls r7,r4,#10
@  asrs r4,#22
@  asrs r5,r1,#31
@  adds r1,r7
@  adcs r4,r5
@ @ r0:r1:r4 exponent*ln2 Q62
@  asrs r5,r3,#31
@  adds r0,r2
@  adcs r1,r3
@  adcs r4,r5
@ @ r0:r1:r4 result Q62
@  movs r2,#62
@ 1:
@  asrs r5,r1,#31
@  cmp r4,r5
@  beq 2f                        @ r4 a sign extension of r1?
@  lsrs r0,#4                    @ no: shift down 4 places and try again
@  lsls r6,r1,#28
@  orrs r0,r6
@  lsrs r1,#4
@  lsls r6,r4,#28
@  orrs r1,r6
@  asrs r4,#4
@  subs r2,#4
@  b 1b
@ 2:
@  bl qfp_fix642double
@  pop {r4-r7,r15}

@ 5:
@  ldr r1,=#0xfff00000
@  movs r0,#0
@  pop {r4-r7,r15}

@ 6:
@  ldr r1,=#0x7ff00000
@  movs r0,#0
@  pop {r4-r7,r15}


@ .ltorg

@ .align 2
@ dreddata1:
@ .word 0x0000B8AA               @ 1/ln2 Q15
@ .word 0x0013DE6B               @ ln2 Q62 Q62=2C5C85FDF473DE6B split into 21-bit pieces
@ .word 0x000FEFA3
@ .word 0x000B1721

@ dtab_exp:
@ .word 0xbf984bf3, 0x19f323ec   @ log 1+2^-1 Q62
@ .word 0xcd4d10d6, 0x0e47fbe3   @ log 1+2^-2 Q62
@ .word 0x8abcb97a, 0x0789c1db   @ log 1+2^-3 Q62
@ .word 0x022c54cc, 0x03e14618   @ log 1+2^-4 Q62
@ .word 0xe7833005, 0x01f829b0   @ log 1+2^-5 Q62
@ .word 0x87e01f1e, 0x00fe0545   @ log 1+2^-6 Q62
@ .word 0xac419e24, 0x007f80a9   @ log 1+2^-7 Q62
@ .word 0x45621781, 0x003fe015   @ log 1+2^-8 Q62
@ .word 0xa9ab10e6, 0x001ff802   @ log 1+2^-9 Q62
@ .word 0x55455888, 0x000ffe00   @ log 1+2^-10 Q62
@ .word 0x0aa9aac4, 0x0007ff80   @ log 1+2^-11 Q62
@ .word 0x01554556, 0x0003ffe0   @ log 1+2^-12 Q62
@ .word 0x002aa9ab, 0x0001fff8   @ log 1+2^-13 Q62
@ .word 0x00055545, 0x0000fffe   @ log 1+2^-14 Q62
@ .word 0x8000aaaa, 0x00007fff   @ log 1+2^-15 Q62
@ .word 0xe0001555, 0x00003fff   @ log 1+2^-16 Q62
@ .word 0xf80002ab, 0x00001fff   @ log 1+2^-17 Q62
@ .word 0xfe000055, 0x00000fff   @ log 1+2^-18 Q62
@ .word 0xff80000b, 0x000007ff   @ log 1+2^-19 Q62
@ .word 0xffe00001, 0x000003ff   @ log 1+2^-20 Q62
@ .word 0xfff80000, 0x000001ff   @ log 1+2^-21 Q62
@ .word 0xfffe0000, 0x000000ff   @ log 1+2^-22 Q62
@ .word 0xffff8000, 0x0000007f   @ log 1+2^-23 Q62
@ .word 0xffffe000, 0x0000003f   @ log 1+2^-24 Q62
@ .word 0xfffff800, 0x0000001f   @ log 1+2^-25 Q62
@ .word 0xfffffe00, 0x0000000f   @ log 1+2^-26 Q62
@ .word 0xffffff80, 0x00000007   @ log 1+2^-27 Q62
@ .word 0xffffffe0, 0x00000003   @ log 1+2^-28 Q62
@ .word 0xfffffff8, 0x00000001   @ log 1+2^-29 Q62
@ .word 0xfffffffe, 0x00000000   @ log 1+2^-30 Q62
@ .word 0x80000000, 0x00000000   @ log 1+2^-31 Q62
@ .word 0x40000000, 0x00000000   @ log 1+2^-32 Q62

qfp_lib_end:
