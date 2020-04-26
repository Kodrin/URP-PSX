#ifndef DITHERING_PATTERNS_INCLUDED
#define DITHERING_PATTERNS_INCLUDED

float4x4 binary = float4x4
(
    0 , 1 , 0 , 1 ,
    1 , 0 , 1 , 0 ,
    0 , 1 , 0 , 1 ,
    1 , 0 , 1 , 0 
);

float4x4 binaryDecimal = float4x4
(
    0.23 , 0.2 , 0.6 , 0.2 ,
    0.2 , 0.43 , 0.2 , 0.77,
    0.88 , 0.2 , 0.87 , 0.2 ,
    0.2 , 0.46 , 0.2 , 0 
);

float4x4 dotted = float4x4
(
     -4.0, 0.0, -3.0, 1.0,
     2.0, -2.0, 3.0, -1.0,
     -3.0, 1.0, -4.0, 0.0,
     3.0, -1.0, 2.0, -2.0
);

float4x4 hatched = float4x4
(
    1 , 0 , 0 , 1 ,
    0 , 1 , 1 , 0 ,
    0 , 1 , 1 , 0 ,
    1 , 0 , 0 , 1 
);

float4x4 mono = float4x4
(
    1 , 1 , 1 , 1 ,
    1 , 1 , 1 , 1 ,
    1 , 1 , 1 , 1 ,
    1 , 1 , 1 , 1 
);

#endif 