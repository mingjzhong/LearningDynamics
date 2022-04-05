function y = evaluate_rhoLT1D(r, rhoLT1D, denseRhoLT1D)
% function y = evaluate_rhoLT1D(r, rhoLT1D, denseRhoLT1D)

% (c) M. Zhong (JHU)

validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT1D', 'r', 1);
ind          = rhoLT1D.supp(1, 1) <= r & r <= rhoLT1D.supp(1, 2);
y            = zeros(size(r));
y(ind)       = denseRhoLT1D(r(ind));
ind          = y < 0;
y(ind)       = 0;
end