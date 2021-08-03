function y = evaluate_rhoLT1D(r, rhoLT1D)
% function y = evaluate_rhoLT1D(r, rhoLT1D)

% (c) M. Zhong (JHU)

% validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT1D', 'r', 1);
if iscell(rhoLT1D.histedges)
  centers    = (rhoLT1D.histedges{1}(2 : end) + rhoLT1D.histedges{1}(1 : end - 1))/2;
else
  centers    = (rhoLT1D.histedges(2 : end) + rhoLT1D.histedges(1 : end - 1))/2;
end
denseRhoLT1D = griddedInterpolant(centers, rhoLT1D.hist, 'linear', 'linear');
ind          = rhoLT1D.supp(1, 1) <= r & r <= rhoLT1D.supp(1, 2);
y            = zeros(size(r));
y(ind)       = denseRhoLT1D(r(ind));
ind          = y < 0;
y(ind)       = 0;
end