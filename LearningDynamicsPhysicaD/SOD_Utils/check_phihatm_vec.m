function [pred_phihatm, C, P] = check_phihatm_vec(phihatm_vec, rq, src_pos, debug)
% function [pred_phihatm, C, P] = check_phihatm_vec(phihatm_vec, rq, src_pos, debug)

% (C) M. Zhong

if nargin < 4, debug = false; end
ind          = phihatm_vec > 0;
Y            = log(phihatm_vec(ind));
if ~iscolumn(rq), rq = rq'; end
X            = [ones(length(Y), 1), log(rq(ind))];
coeffs       = X\Y;
P            = round(coeffs(2));
C            = exp(coeffs(1));
fprintf('\n\tphim behaves roughly like %.2e * r^(%d).', C, P);
pred_phihatm = @(r) C * r.^(P);
if debug
  figure('Name', 'Gravity: phihat_m(rp) vs. rp', 'NumberTitle', 'off', 'Position', src_pos);
  loglog(rq, phihatm_vec, 'bo');
  hold on;
  loglog(rq, pred_phihatm(rq), '--r');
  hold off;
end
end