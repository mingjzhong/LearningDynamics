function RHF = SPPD_Rayleigh_Dissipation(v, d, N, alpha, beta)
% function RHF = SPPD_Rayleigh_Dissipation(v, d, N, alpha, beta)
% The Rayleigh-Helmholtz friction provides self-acceleration and -deleration

% (c) M. Zhong

v             = reshape(v, [d, N]);
RHF           = zeros(d, N);
v_normsq      = sum(v.^2);
for idx = 1 : d
  RHF(idx, :) = (alpha - beta * v_normsq) .* v(idx, :);
end
RHF           = RHF(:);
end