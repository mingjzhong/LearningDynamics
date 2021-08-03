function L2_rhoT = L2_rhoTND(f, rhoLT, supp)
% function L2_rhoT = L2_rhoTND(f, rhoLT, supp)

% (C) M. Zhong

switch size(rhoLT.supp, 1) % based on the dimenson of rho
  case 1
    L2_rhoT = L2_rhoLT1D(f, rhoLT, supp);
  case 2
    L2_rhoT = L2_rhoLT2D(f, rhoLT, supp);
  case 3
    L2_rhoT = L2_rhoLT3D(f, rhoLT, supp);
  otherwise
end
end