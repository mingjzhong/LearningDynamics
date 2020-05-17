function Err = relativeErrorInfluenceFunction(phihat, phi, sys_info, obs_info, basis, type)
% function Err = relativeErrorInfluenceFunction(phihat, phi, sys_info, obs_info, basis, type)

% (C) M. Maggioni, M. Zhong (JHU)

Err.Timings.L2rhoT      = tic;
phidiff                 = cell(size(phi));
rhoLT                   = get_the_rhoLT(obs_info.rhoLT, type);
L2_rhoT                 = @(f) L2_rhoT_norm(f, rhoLT, basis);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    switch basis{k1, k2}.dim
      case 1
        phidiff{k1, k2} = @(r)       phi{k1, k2}(r)       - phihat{k1, k2}(r);   
      case 2
        phidiff{k1, k2} = @(r, s)    phi{k1, k2}(r, s)    - phihat{k1, k2}(r, s);   
      case 3
        phidiff{k1, k2} = @(r, s, z) phi{k1, k2}(r, s, z) - phihat{k1, k2}(r, s, z);   
      otherwise
    end
  end
end
Err.Abs                 = L2_rhoT(phidiff);
phi_norm                = L2_rhoT(phi);
ind                     = phi_norm ~= 0;
Err.Rel                 = Err.Abs;
Err.Rel(ind)            = Err.Rel(ind)./phi_norm(ind);
Err.Timings.L2rhoT      = toc(Err.Timings.L2rhoT);
end