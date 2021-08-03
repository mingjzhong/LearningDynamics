function L2err = get_L2err_from_supp(phi_diff, phi, rhoLT, subInts)
% function L2err = get_L2err_from_supp(phi_diff, phi, rhoLT, supp)

% (C) M. Zhong

L2err        = zeros(size(subInts));
for idx = 1 : length(subInts)
  phi_L2     = L2_rhoTND(phi, rhoLT, subInts{idx});
  L2err(idx) = L2_rhoTND(phi_diff, rhoLT, subInts{idx});
  if phi_L2 ~= 0, L2err(idx) = L2err(idx)/phi_L2; end
end
end