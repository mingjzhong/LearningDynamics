function phi = FD_phiA(r, H, beta)
% function phi = FD_phiA(r, H, beta)

% (c) M. Zhong (JHU)

% alignment interaction for Cucker-Smale and Cucker-Dong
phi = H./(1 + r.^2).^beta;
end