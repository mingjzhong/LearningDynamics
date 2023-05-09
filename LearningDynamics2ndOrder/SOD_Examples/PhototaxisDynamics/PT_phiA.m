function phi = PT_phiA(r, beta, kappa)
% phi = PT_phiA(r, beta, kappa)
% kappa is the coupling strength term

% (C) M. Zhong (JHU)

phi = kappa * (1 + r.^2).^(-beta);