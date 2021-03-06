MODULE MathL (*!["C"] EXTERNAL ["m"]*);

IMPORT
  UnixSup (*necessary!*);
  
(* Note: This module assumes that LONGREAL=double. *)

CONST
  pi* = 3.14159265358979323846D0;
  e* = 2.71828182845904523536D0;
  
PROCEDURE sqrt* (x: LONGREAL): LONGREAL; (*<*)END sqrt;(*>*)
(* sqrt(x) returns the square root of x, where x must be positive. *)

PROCEDURE power* (*!["pow"]*) (x, base: LONGREAL): LONGREAL; (*<*)END power;(*>*)            
(* power(x, base) returns the x to the power base. *)

PROCEDURE exp* (x: LONGREAL): LONGREAL; (*<*)END exp;(*>*)
(* exp(x) is the exponential of x base e.  x must not be so small that this 
   exponential underflows nor so large that it overflows. *)

PROCEDURE ln* (*!["log"]*) (x: LONGREAL): LONGREAL; (*<*)END ln;(*>*) 
(* ln(x) returns the natural logarithm (base e) of x. *)

PROCEDURE log* (*!["UnixSup_log"]*) (x, base: LONGREAL): LONGREAL; (*<*)END log;(*>*)
(* log(x,base) is the logarithm of x base b.  All positive arguments are 
   allowed.  The base b must be positive. *)
   
PROCEDURE round* (*!["UnixSup_round"]*) (x: LONGREAL): LONGREAL; (*<*)END round;(*>*)
(* round(x) if fraction part of x is in range 0.0 to 0.5 then the result is 
   the largest integer not greater than x, otherwise the result is x rounded 
   up to the next highest whole number.  Note that integer values cannot always
   be exactly represented in REAL or LONGREAL format. *)

PROCEDURE sin* (x: LONGREAL): LONGREAL; (*<*)END sin;(*>*)
PROCEDURE cos* (x: LONGREAL): LONGREAL; (*<*)END cos;(*>*)
PROCEDURE tan* (x: LONGREAL): LONGREAL; (*<*)END tan;(*>*)
(* sin, cos, tan(x) returns the sine, cosine or tangent value of x, where x is
   in radians. *)

PROCEDURE arcsin* (*!["asin"]*) (x: LONGREAL): LONGREAL; (*<*)END arcsin;(*>*)
PROCEDURE arccos* (*!["acos"]*) (x: LONGREAL): LONGREAL; (*<*)END arccos;(*>*)
PROCEDURE arctan* (*!["atan"]*) (x: LONGREAL): LONGREAL; (*<*)END arctan;(*>*)
(* arcsin, arcos, arctan(x) returns the arcsine, arcos, arctan value in radians
   of x, where x is in the sine, cosine or tangent value. *)

PROCEDURE arctan2* (*!["atan2"]*) (xn, xd: LONGREAL): LONGREAL; (*<*)END arctan2;(*>*)
(* arctan2(xn,xd) is the quadrant-correct arc tangent atan(xn/xd).  If the 
   denominator xd is zero, then the numerator xn must not be zero.  All
   arguments are legal except xn = xd = 0. *)

PROCEDURE sinh* (x: LONGREAL): LONGREAL; (*<*)END sinh;(*>*)
(* sinh(x) is the hyperbolic sine of x.  The argument x must not be so large 
   that exp(|x|) overflows. *)
   
PROCEDURE cosh* (x: LONGREAL): LONGREAL; (*<*)END cosh;(*>*)
(* cosh(x) is the hyperbolic cosine of x.  The argument x must not be so large
   that exp(|x|) overflows. *)
   
PROCEDURE tanh* (x: LONGREAL): LONGREAL; (*<*)END tanh;(*>*)
(* tanh(x) is the hyperbolic tangent of x.  All arguments are legal. *)


(* If you need arcsinh, arccosh, and arctanh, and if your C library supports
   the functions asinh, acosh and atang, you can uncomment the following
   declaractions (see also Math.Mod).

PROCEDURE arcsinh* (*!["asinh"]*) (x: LONGREAL): LONGREAL; (*<*)END arcsinh;(*>*)
(* arcsinh(x) is the arc hyperbolic sine of x.  All arguments are legal. *)

PROCEDURE arccosh* (*!["acosh"]*) (x: LONGREAL): LONGREAL; (*<*)END arccosh;(*>*)
(* arccosh(x) is the arc hyperbolic cosine of x.  All arguments greater than 
   or equal to 1 are legal. *)
   
PROCEDURE arctanh* (*!["atanh"]*) (x: LONGREAL): LONGREAL; (*<*)END arctanh;(*>*)
(* arctanh(x) is the arc hyperbolic tangent of x.  |x| < 1 - sqrt(em), where 
   em is machine epsilon.  Note that |x| must not be so close to 1 that the 
   result is less accurate than half precision. *)

*)



(* non Oakwoord-compliant functions: *)

PROCEDURE modf* (value : LONGREAL; VAR integerPart : LONGREAL) : LONGREAL; (*<*)END modf;(*>*)

END MathL.

