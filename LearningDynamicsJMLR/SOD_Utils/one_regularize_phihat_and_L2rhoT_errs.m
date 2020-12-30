function output = one_regularize_phihat_and_L2rhoT_errs(phi, phihat, phiknots, degree, sys_info, obs_info, learn_info, rhoLTemp)
%
%

% (c) M. Zhong (JHU)

reg_output              = regularize_phihat( phi, phihat, phiknots, degree, rhoLTemp, sys_info );
phihatsmooth            = reg_output.phihatsmooth;
phihat_diff             = reg_output.phihat_diff;
phihatsmooth_diff       = reg_output.phihatsmooth_diff;
basis_info              = reg_output.basis_info;
L2rhoT_time             = tic;
phi_L2norms             = L2_rho_T_energy( phi,               sys_info, obs_info, basis_info );
phihat_L2rhoTdiff       = L2_rho_T_energy( phihat_diff,       sys_info, obs_info, basis_info );
phihatsmooth_L2rhoTdiff = L2_rho_T_energy( phihatsmooth_diff, sys_info, obs_info, basis_info );
L2rhoT_time             = toc(L2rhoT_time);
Rel                     = phihat_L2rhoTdiff ./ phi_L2norms;
Rel_smooth              = phihatsmooth_L2rhoTdiff ./ phi_L2norms;
Abs                     = phihat_L2rhoTdiff;
Abs_smooth              = phihatsmooth_L2rhoTdiff;
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if learn_info.VERBOSE >= 1
      if phi_L2norms(k1,k2) > 0
        fprintf('\nRelative L_2(rho_T) err. of      estimator for \\phi_{%d,%d} = %12.6e.', k1, k2, Rel(k1, k2));
        fprintf('\nRelative L_2(rho_T) err. of reg. estimator for \\phi_{%d,%d} = %12.6e.', k1, k2, Rel_smooth(k1, k2));
      else
        fprintf('\nAbsolute L_2(rho_T) err. of      estimator for \\phi_{%d,%d} = %12.6e.', k1, k2, Abs);
        fprintf('\nAbsolute L_2(rho_T) err. of reg. estimator for \\phi_{%d,%d} = %12.6e.', k1, k2, Abs_smooth);
      end
    end
  end
end

output.L2rhoT_time    = L2rhoT_time;
output.Err.Rel        = Rel;
output.Err.Rel_smooth = Rel_smooth;
output.Err.Abs        = Abs;
output.Err.Abs_smooth = Abs_smooth;
output.phihatsmooth   = phihatsmooth;
end