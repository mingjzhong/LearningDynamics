function [PhiMat, RhoMat] = get_gravity_Mats(phis, rhos, rq)
% function [PhiMat, RhoMat] = get_gravity_Mats(phis, rhos, rq)

% (C) M. Zhong

PhiMat                    = cell(size(phis));
RhoMat                    = cell(size(rhos));
for ind1 = 1 : length(phis)
  phi_ks                  = phis{ind1};
  rho_ks                  = rhos{ind1};
  PhiMat{ind1}            = zeros(length(phi_ks), length(rq));
  RhoMat{ind1}            = zeros(length(rho_ks), length(rq));
  for ind2 = 1 : length(phi_ks)
    PhiMat{ind1}(ind2, :) = phi_ks{ind2}(rq);
    RhoMat{ind1}(ind2, :) = rho_ks{ind2}.dense(rq);
  end
end
end