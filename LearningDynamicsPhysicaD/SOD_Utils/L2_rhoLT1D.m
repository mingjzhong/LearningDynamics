function L2rhoT = L2_rhoLT1D(f, rhoLT1D, range)
% function L2rhoT = L2_rhoLT1D(f, rhoLT1D, range)
% calculates the L2_rhoLT norm of f(r) over [a, b], it is given as
% \sqrt(\int_a^b (f(r) * r)^2 * drhoLT(r)) or 
% \sqrt(\int_a^b (f(r))^2 * drhoLT(r)) for the gravity
% Input:
%   f       - the target function
%   rhoLT1D - the probability distribution rho_T^L(r)
%   range   - gives [a, b]
% Output:
%   the L2(rhoLT) norm of f over [a, b]

% (C) M. Zhong (JHU)

r_range = intersectInterval(rhoLT1D.supp{1}, range);
r_ctrs  = linspace(r_range(1), r_range(2), 1000);
drhos   = rhoLT1D.dense(r_ctrs);
if ~isrow(r_ctrs), r_ctrs = r_ctrs'; end
if ~iscolumn(drhos), drhos = drhos'; end
L2rhoT  = sqrt((f(r_ctrs) .* r_ctrs).^2 * drhos);
end