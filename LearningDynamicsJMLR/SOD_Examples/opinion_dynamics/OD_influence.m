function influence = OD_influence(r, type)
% influence = OD_influence(r, type)

% Ming Zhong
% Postdoc Research
%

persistent f_influence

influence = zeros(size(r));
cutoff    = 1/(sqrt(2));
support   = 1;
switch type
    case 1 % added by Sui Tang The cosine kernel
        ind            = 0 < r & r < cutoff;
        influence(ind) = cos(r(ind)*pi/2);
        ind            = cutoff <= r & r< support;
        influence(ind) = cos(r(ind)*pi/2);
    case 2 % added by Sui Tang The constant kernel
        ind            = 0 < r;
        influence(ind) = 1;
     
    case 3 % added by Sui Tang The quadratic kernel
        ind            = 0 < r; 
        influence(ind) = r(ind).^2;
      
    case 4
        ind            = 0 < r & r < cutoff;
        influence(ind) = 0.1;
        ind            = cutoff <= r & r < support;
        influence(ind) = 1;
    case 5 % added by Sui Tang, example used in the JMLR paper
        delta          = 0.05;
        ind            = 0                 < r & r < (cutoff - delta);
        influence(ind) = 0.4;
        ind            = (cutoff - delta)  <= r & r < (cutoff + delta);
        y_1            = 0.4;
        y_2            = 1;
        influence(ind) = (y_2 - y_1)/(-2) * (cos(pi/(2 * delta) * (r(ind) - (cutoff - delta))) - 1) + y_1;
        ind            = (cutoff + delta)  <= r & r < (support - delta);
        influence(ind) = 1;
        ind            = (support - delta) <= r & r < (support + delta);
        y_1            = 1;
        y_2            = 0;
        influence(ind) = (y_2 - y_1)/(-2) * (cos(pi/(2 * delta) * (r(ind) - (support - delta))) - 1) + y_1;
    case 6
        if isempty(f_influence)
            f_1             = chebfun( @(x) exp(-x.^2*1), [0,+Inf] );
            f_2             = chebfun( @(x) f_1(1)*exp(-(x-1).^2*0.25), [0,+Inf] );
            f_influence     = max( f_1, f_2 );
            f_influence     = merge(f_influence);
        end
        influence       = f_influence(r);
    otherwise
end

return