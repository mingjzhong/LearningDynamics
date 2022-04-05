function phi = SOD_phiE(r, s, A, B, J)
% function phi = SOD_phiE(r, s, A, B, J)

% (c) M. Zhong (JHU)

phi      = zeros(size(r));
ind      = r > 0;
phi(ind) = (A + J * cos(s(ind)))./r(ind) - B./r(ind).^2;
ind      = r == 0;
phi(ind) = -Inf;
end