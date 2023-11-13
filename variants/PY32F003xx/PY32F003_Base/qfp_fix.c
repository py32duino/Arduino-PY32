#include "stdint.h"

#include "qfplib-m0-full.h"

//__aeabi_frsub	2 float	float	返回 y 减去 x 
float __aeabi_frsub(float x, float y)
{
    return __aeabi_fsub(y,x);
}
//_frdiv	2 float	float	返回 y 除以 x
float _frdiv(float x, float y)
{
    return __aeabi_fdiv(y,x);
}
//__aeabi_drsub	2 double	double	返回 y 减去 x 
double __aeabi_drsub(double x, double y)
{
    return __aeabi_dsub(y,x);
}
//_drdiv	2 double	double	返回 y 除以 x
double _drdiv(double x, double y)
{
    return __aeabi_ddiv(y,x);
}

/*
_frem	2 float	float	返回 x 除以 y 的余数（参见注释 a）
_frnd	float	float	返回 x 四舍五入为整数（参见注释 b） 
_drem	2 double	double	返回 x 除以 y 的余数（参见注释 a 和 c）
_drnd	double	double	返回 x 四舍五入为整数（参见注释 b）

_ffix_r	float	int
_ffixu_r	float	unsigned int
_dfix_r	double	int
_dfixu_r	double	unsigned int
_ll_sfrom_f_r	float	long long
_ll_ufrom_f_r	float	unsigned long long
_ll_sfrom_d_r	double	long long
_ll_ufrom_d_r	double	unsigned long long

https://developer.arm.com/documentation/dui0475/m/floating-point-support/the-software-floating-point-library--fplib/fplib-comparisons-between-floats-and-doubles?lang=en
https://developer.arm.com/documentation/dui0475/m/floating-point-support/the-software-floating-point-library--fplib/fplib-c99-functions?lang=en
*/

//These functions return zero if neither argument is NaN, and a and b are equal.
int __eqsf2(float a, float b)   { return qfp_fcmp(a,b);}
int __eqdf2(double a, double b) { return qfp_dcmp(a,b);}
//These functions return a nonzero value if either argument is NaN, or if a and b are unequal.
int __nesf2(float a, float b)   { return qfp_fcmp(a,b);}
int __nedf2(double a, double b) { return qfp_dcmp(a,b);}
//These functions return a value greater than or equal to zero if neither argument is NaN, and a is greater than or equal to b.
int __gesf2(float a, float b)   { return qfp_fcmp(a,b);}
int __gedf2(double a, double b) { return qfp_dcmp(a,b);}
//These functions return a value less than zero if neither argument is NaN, and a is strictly less than b.
int __ltsf2(float a, float b)   { return qfp_fcmp(a,b);}
int __ltdf2(double a, double b) { return qfp_dcmp(a,b);}
//These functions return a value less than or equal to zero if neither argument is NaN, and a is less than or equal to b.
int __lesf2(float a, float b)   { return qfp_fcmp(a,b);}
int __ledf2(double a, double b) { return qfp_dcmp(a,b);}
//These functions return a value greater than zero if neither argument is NaN, and a is strictly greater than b.
int __gtsf2(float a, float b)   { return qfp_fcmp(a,b);}
int __gtdf2(double a, double b) { return qfp_dcmp(a,b);}

