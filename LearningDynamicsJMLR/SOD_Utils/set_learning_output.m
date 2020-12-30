function output = set_learning_output(obs_data, learn_info, syshat_info, syshatsmooth_info, learning_results, regularization_output, Timings)
% function learningOutput = set_learning_output(obs_data, learn_info, syshat_info, syshatsmooth_info, learning_results, regularization_output)

% (c) M. Zhong (JHU)

if learn_info.keep_obs_data
  output.obs_data                  = obs_data;
else
  output.obs_data.Timings          = obs_data.Timings;
end
output.phiEhat                     = learning_results.phiEhat;
output.phiEknots                   = learning_results.phiEknots;
output.phiEhatsmooth               = regularization_output.phiEhatsmooth;
output.phiAhat                     = learning_results.phiAhat;
output.phiAknots                   = learning_results.phiAknots;
output.phiAhatsmooth               = regularization_output.phiAhatsmooth;
output.phiXihat                    = learning_results.phiXihat;
output.phiXiknots                  = learning_results.phiXiknots;
output.phiXihatsmooth              = regularization_output.phiXihatsmooth;
output.syshat_info                 = syshat_info;
output.syshatsmooth_info           = syshatsmooth_info;
output.rhoLTemp                    = regularization_output.rhoLTemp;
output.Timings.L2rhoTE             = regularization_output.Timings.L2rhoTE;
output.Timings.L2rhoTA             = regularization_output.Timings.L2rhoTA;
output.Timings.L2rhoTXi            = regularization_output.Timings.L2rhoTXi;
output.Timings.learn_from_dynamics = Timings.learn_from_dynamics;
output.Timings.estimateRhoLT       = Timings.estimateRhoLT;
end