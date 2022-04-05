function [pred_phihatm, C, P] = check_phihatm_vec(phihatm_vec, rq)
% function [pred_phihatm, C, P] = check_phihatm_vec(phihatm_vec, rq)

% (C) M. Zhong

ind          = phihatm_vec > 0;
Y            = log(phihatm_vec(ind));
if ~iscolumn(rq), rq = rq'; end
X            = [ones(length(Y), 1), log(rq(ind))];
coeffs       = X\Y;
P            = round(coeffs(2));
C            = exp(coeffs(1));
fprintf('\n\tphim behaves roughly like %.2e * r^(%d).', C, P);
pred_phihatm = @(r) C * r.^(P);
end