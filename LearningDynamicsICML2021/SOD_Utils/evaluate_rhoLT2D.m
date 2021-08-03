function y = evaluate_rhoLT2D(r, s, rhoLT2D)
% function y = evaluate_rhoLT2D(r, s, rhoLT2D)

% (c) M. Zhong (JHU)

% validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT2D', 'r', 1);
% validateattributes(s, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT2D', 'x', 2);
r_range     = rhoLT2D.supp(1, :);
s_range     = rhoLT2D.supp(2, :);
r_ctrs      = (rhoLT2D.histedges{1}(2 : end) + rhoLT2D.histedges{1}(1 : end - 1))/2;
s_ctrs      = (rhoLT2D.histedges{2}(2 : end) + rhoLT2D.histedges{2}(1 : end - 1))/2;
[R, S]      = ndgrid(r_ctrs, s_ctrs);
densRhoLT2D = griddedInterpolant(R, S, rhoLT2D.hist, 'linear', 'linear');
r_ind       = r_range(1) <= r & r <= r_range(2);
x_ind       = s_range(1) <= s & s <= s_range(2);
y           = zeros(size(r));
ind         = r_ind & x_ind;
y(ind)      = densRhoLT2D(r(ind), s(ind));
ind         = y < 0;
y(ind)      = 0;
end