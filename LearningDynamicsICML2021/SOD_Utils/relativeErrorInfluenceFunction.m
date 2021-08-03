function Err = relativeErrorInfluenceFunction(phihat, phi, sys_info, obs_info, basis, type)
% function Err = relativeErrorInfluenceFunction(phihat, phi, sys_info, obs_info, basis, type)

% (C) M. Maggioni, M. Zhong (JHU)

Err.Timings.L2rhoT      = tic;
if ~strcmp(type, 'energy_and_alignment')
  phidiff               = cell(size(phi));
  rhoLT                 = get_the_rhoLT(obs_info.rhoLT, sys_info, type);
  L2_rhoT               = @(f) L2_rhoT_norm(f, rhoLT, basis);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      phidiff{k1, k2}   = get_phi_diff_by_dim(phi{k1, k2}, phihat{k1, k2}, basis{k1, k2}.dim);
    end
  end
  Err.Abs               = L2_rhoT(phidiff);
  phi_norm              = L2_rhoT(phi);
  ind                   = phi_norm ~= 0;
  Err.Rel               = Err.Abs;
  Err.Rel(ind)          = Err.Rel(ind)./phi_norm(ind);
else
  phiE                  = phi{1};
  phiA                  = phi{2};
  phiEhat               = phihat{1};
  phiAhat               = phihat{2};
  Ebasis                = basis{1};
  Abasis                = basis{2};
  Err.Abs               = zeros(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      phiEdiff          = get_phi_diff_by_dim(phiE{k1, k2}, phiEhat{k1, k2}, Ebasis{k1, k2}.dim);
      phiAdiff          = get_phi_diff_by_dim(phiA{k1, k2}, phiAhat{k1, k2}, Abasis{k1, k2}.dim);
      Err.Abs(k1, k2)   = get_L2_rhoLTEA_norm(phiEdiff, Ebasis{k1, k2}, phiAdiff, ...
                          Abasis{k1, k2}, obs_info.rhoLT{end}{k1, k2}); 
      phi_norm          = get_L2_rhoLTEA_norm(phiE{k1, k2}, Ebasis{k1, k2}, phiA{k1, k2}, ...
                          Abasis{k1, k2}, obs_info.rhoLT{end}{k1, k2});
      if phi_norm ~= 0
        Err.Rel(k1, k2) = Err.Abs(k1, k2)/phi_norm;
      else
        Err.Rel(k1, k2) = Err.Abs(k1, k2);
      end
    end
  end
end
Err.Timings.L2rhoT      = toc(Err.Timings.L2rhoT);
end