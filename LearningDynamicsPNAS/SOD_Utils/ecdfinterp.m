function xcdf = ecdfinterp( Z, x )

%
% function xcdf = ecdfinterp( Z, x )
%
% IN:
%   Z   : samples of (one-dimensional) random variable
%
% OUT:


[f,xe] = ecdf(Z);
if length(unique(xe))>=2
    xcdf = interp1(xe(2:end), f(2:end), x, 'previous');
else
    xcdf(x<=xe(1)) = 0;
    xcdf(x>xe(1)) = 1;
end
xcdf(x < min(Z)) = 0;
xcdf(x >= max(Z)) = 1;

return