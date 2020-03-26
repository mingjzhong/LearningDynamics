function rho = get_single_rhoLT(rhos, k1, k2)
% function rho = get_single_rhoLT(rhos, k1, k2)

% (c) M. Zhong (JHU

rho.histcount = rhos.histcount{k1, k2};
rho.hist      = rhos.hist{k1, k2};
rho.supp      = rhos.supp{k1, k2};
rho.histedges = rhos.histedges{k1, k2};
end