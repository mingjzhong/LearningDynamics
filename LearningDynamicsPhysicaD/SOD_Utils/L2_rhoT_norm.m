function L2rhoTnorm = L2_rhoT_norm(f, rhoT, basis)
% function L2rhoTnorm = L2_rhoT_norm(f, rhoT, basis)

% (C) M. Zhong

if size(f, 1) ~= size(f, 2), error(''); end
L2rhoTnorm               = zeros(size(f));
for k1 = 1 : size(f, 1)
  for k2 = 1 : size(f, 2)
    rhoLT = rhoT{k1, k2};
    if ~isempty(rhoLT)
      switch length(rhoLT.supp) % based on the dimenson of rho
        case 1
          L2_rhoT        = @(psi, rho, range) L2_rhoLT1D(psi, rho, range);
        case 2
          L2_rhoT        = @(psi, rho, range) L2_rhoLT2D(psi, rho, range);
        case 3
          L2_rhoT        = @(psi, rho, range) L2_rhoLT3D(psi, rho, range);
        otherwise
      end
      L2rhoTnorm(k1, k2) = L2_rhoT(f{k1, k2}, rhoLT, basis{k1, k2}.supp);
    end
  end
end
end