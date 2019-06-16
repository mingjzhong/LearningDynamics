function I = intersectInterval( I_1, I_2)

I(1) = max( I_1(1), I_2(1) );
I(2) = min( I_1(2), I_2(2) );

return