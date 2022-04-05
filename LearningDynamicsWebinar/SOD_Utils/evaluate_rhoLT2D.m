function y = evaluate_rhoLT2D(r, s, rhoLT2D, densRhoLT2D)
% function y = evaluate_rhoLT2D(r, s, rhoLT2D, densRhoLT2D)

% (c) M. Zhong (JHU)

validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT2D', 'r', 1);
validateattributes(s, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT2D', 'x', 2);
r_ind       = rhoLT2D.supp(1, 1) <= r & r <= rhoLT2D.supp(1, 2);
x_ind       = rhoLT2D.supp(2, 1) <= s & s <= rhoLT2D.supp(2, 2);
y           = zeros(size(r));
ind         = r_ind & x_ind;
y(ind)      = densRhoLT2D(r(ind), s(ind));
ind         = y < 0;
y(ind)      = 0;
end