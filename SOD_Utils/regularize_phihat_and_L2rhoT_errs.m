function output = regularize_phihat_and_L2rhoT_errs(sys_info, obs_info, learn_info, learn_results, rhoLTemp)
% function output = regularize_phihat_and_L2rhoT_errs(learn_results, sys_info, obs_info, learn_info, rhoLTemp)

% (c) M. Zhong (JHU)

phihat                    = learn_results.phiEhat;
if ~isempty(phihat)
  phiknots                = learn_results.phiEknots;                                                % MM: I don't understand where the type info 
  phi                     = sys_info.phiE;
  degree                  = learn_info.Ebasis_info.degree;
  reg_output              = one_regularize_phihat_and_L2rhoT_errs(phi, phihat, phiknots, degree, sys_info, obs_info, learn_info, rhoLTemp);
  output.Err.energy       = reg_output.Err;
  output.Timings.L2rhoTE  = reg_output.L2rhoT_time;
  output.phiEhatsmooth    = reg_output.phihatsmooth;
else
  output.Err.energy       = [];
  output.Timings.L2rhoTE  = [];
  output.phiEhatsmooth    = [];
end

phihat                    = learn_results.phiAhat;
if ~isempty(phihat)
  phiknots                = learn_results.phiAknots;
  phi                     = sys_info.phiA;
  degree                  = learn_info.Abasis_info.degree;
  reg_output              = one_regularize_phihat_and_L2rhoT_errs(phi, phihat, phiknots, degree, sys_info, obs_info, learn_info, rhoLTemp);
  output.Err.alignment    = reg_output.Err;
  output.Timings.L2rhoTA  = reg_output.L2rhoT_time;
  output.phiAhatsmooth    = reg_output.phihatsmooth;
else
  output.Err.alignment    = [];
  output.Timings.L2rhoTA  = [];
  output.phiAhatsmooth    = [];
end

phihat                    = learn_results.phiXihat;
if ~isempty(phihat)
  phiknots                = learn_results.phiXiknots;
  phi                     = sys_info.phiXi;
  degree                  = learn_info.Xibasis_info.degree;
  reg_output              = one_regularize_phihat_and_L2rhoT_errs(phi, phihat, phiknots, degree, sys_info, obs_info, learn_info, rhoLTemp);
  output.Err.Xi           = reg_output.Err;
  output.Timings.L2rhoTXi = reg_output.L2rhoT_time;
  output.phiXihatsmooth   = reg_output.phihatsmooth;
else
  output.Err.Xi           = [];
  output.Timings.L2rhoTXi = [];
  output.phiXihatsmooth   = [];
end
output.rhoLTemp           = rhoLTemp;
end