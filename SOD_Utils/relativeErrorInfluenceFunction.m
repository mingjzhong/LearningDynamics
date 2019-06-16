function Err = relativeErrorInfluenceFunction( phihat, phi, sys_info, obs_info, basis, type )

for k_1 = sys_info.K:-1:1
  for k_2 = sys_info.K:-1:1
    phidiff{k_1,k_2}     = @(r) (phi{k_1,k_2}(r)) - (phihat{k_1,k_2}(r));       
  end
end
Err.Timings.L2rhoT = tic;

switch type
  case 'energy'
    L2_rho_T = @(a, b, c, d) L2_rho_T_energy(a, b, c, d);
  case 'alignment'
    L2_rho_T = @(a, b, c, d) L2_rho_T_alignment(a, b, c, d);
  case 'xi'
    L2_rho_T = @(a, b, c, d) L2_rho_T_xi(a, b, c, d);
  otherwise
    errro('');
end
phi_L2norms              = L2_rho_T( phi, sys_info, obs_info, basis );
phihat_L2rhoTdiff        = L2_rho_T( phidiff, sys_info, obs_info, basis );

Err.Timings.L2rhoT = toc(Err.Timings.L2rhoT);

for k_1 = 1:sys_info.K
  for k_2 = 1:sys_info.K
    Err.Abs(k_1,k_2)              = phihat_L2rhoTdiff(k_1,k_2);
    if phi_L2norms(k_1,k_2) ~= 0
      Err.Rel(k_1,k_2)            = phihat_L2rhoTdiff(k_1,k_2)/ phi_L2norms(k_1,k_2);
    else
      if phihat_L2rhoTdiff(k_1,k_2) == 0
        Err.Rel(k_1,k_2)          = 0;
      else
        Err.Rel(k_1,k_2)          = Inf;
      end
    end
  end
end

return