function result = get_phis_and_rhos_for_plotting(learningOutput, sys_info, obs_info, type, plot_info)
% function result = get_phis_and_rhos_for_plotting(learningOutput, sys_info, obs_info, type, plot_info)

% (C) M. Zhong

n_trials                       = length(learningOutput);
phihats                        = cell(1, n_trials); 
phihatsmooths                  = cell(1, n_trials);
phihatregs                     = cell(1, n_trials);
rhoLTMs                        = cell(1, n_trials);
phiE_2D                        = isfield(sys_info, 'projE') && ~isempty(sys_info.projE);
switch type
  case 'energy'
    phi                        = sys_info.phiE;
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, sys_info, 'energy');
    phi_type                   = '_phiE';
    rho_type                   = '_rhoE';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiEhat;
      if isfield(learningOutput{ind}.Estimator, 'phiEhatsmooth') && ...
          ~isempty(learningOutput{ind}.Estimator.phiEhatsmooth)
        phihatsmooths{ind}     = learningOutput{ind}.Estimator.phiEhatsmooth;
      end
      if isfield(learningOutput{ind}.Estimator, 'phiEhatReg') && ...
          ~isempty(learningOutput{ind}.Estimator.phiEhatReg)
        phihatregs{ind}        = learningOutput{ind}.Estimator.phiEhatReg;
      end
      if ind == 1
        if isfield(learningOutput{ind}.Estimator, 'phiEhatclean') && ~isempty(learningOutput{ind}.Estimator.phiEhatclean)
          phihatcleans         = cell(1, n_trials);
        else
          phihatcleans         = [];
        end
      end
      if isfield(learningOutput{ind}.Estimator, 'phiEhatclean') && ~isempty(learningOutput{ind}.Estimator.phiEhatclean)
        phihatcleans{ind}      = learningOutput{ind}.Estimator.phiEhatclean;
      end
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, sys_info, 'energy');
    end     
  case 'alignment'
    phi                        = sys_info.phiA;
    phihatcleans               = [];
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, sys_info, 'alignment');
    phi_type                   = '_phiA';
    rho_type                   = '_rhoA';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiAhat;
      if isfield(learningOutput{ind}.Estimator, 'phiAhatsmooth') && ...
          ~isempty(learningOutput{ind}.Estimator.phiAhatsmooth)
        phihatsmooths{ind}     = learningOutput{ind}.Estimator.phiAhatsmooth;
      end
      if ~isempty(learningOutput{ind}.Estimator.phiAhatReg)
        phihatregs{ind}        = learningOutput{ind}.Estimator.phiAhatReg;
      end
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, sys_info, 'alignment');
    end     
  case 'xi'
    phi                        = sys_info.phiXi;
    phihatcleans               = [];
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, sys_info, 'xi'); 
    phi_type                   = '_phiXi';
    rho_type                   = '_rhoXi';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiXihat;
      if isfield(learningOutput{ind}.Estimator, 'phiXihatsmooth') && ...
          ~isempty(learningOutput{ind}.Estimator.phiXihatsmooth)
        phihatsmooths{ind}     = learningOutput{ind}.Estimator.phiXihatsmooth;
      end
      if ~isempty(learningOutput{ind}.Estimator.phiXihatReg)
        phihatregs{ind}        = learningOutput{ind}.Estimator.phiXihatReg;
      end
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, sys_info, 'xi');   
    end 
  otherwise
end
rhoLTR                         = cell(sys_info.K);
rhoLTMRs                       = cell(1, n_trials);
if ~strcmp(type, 'energy') || phiE_2D, rhoLTX    = cell(sys_info.K);  else, rhoLTX    = []; end
if ~strcmp(type, 'energy') || phiE_2D, rhoLTRX   = cell(sys_info.K);  else, rhoLTRX   = []; end
if ~strcmp(type, 'energy') || phiE_2D, rhoLTMXs  = cell(1, n_trials); else, rhoLTMXs  = []; end
if ~strcmp(type, 'energy') || phiE_2D, rhoLTMRXs = cell(1, n_trials); else, rhoLTMRXs = []; end
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if ~strcmp(type, 'energy') || phiE_2D
      if ~isempty(rhoLT) && ~isempty(rhoLT{k1, k2})
        rhoLTR{k1, k2}         = rhoLT{k1, k2}.mrhoLT{1}.dense;
        rhoLTX{k1, k2}         = rhoLT{k1, k2}.mrhoLT{end}.dense;
        rhoLTRX{k1, k2}        = rhoLT{k1, k2}.dense;
      end
    else
      if ~isempty(rhoLT) && ~isempty(rhoLT{k1, k2})
        rhoLTR{k1, k2}         = rhoLT{k1, k2}.dense;
      end
    end
  end
end
for idx = 1 : n_trials
  rhoLTMRs{idx}                = cell(sys_info.K);
  if ~strcmp(type, 'energy') || phiE_2D
    rhoLTMXs{idx}              = cell(sys_info.K);
    rhoLTMRXs{idx}             = cell(sys_info.K);
  end  
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      if ~strcmp(type, 'energy') || phiE_2D
        rhoLTMRs{idx}{k1, k2}  = rhoLTMs{idx}{k1, k2}.mrhoLT{1}.dense;
        rhoLTMXs{idx}{k1, k2}  = rhoLTMs{idx}{k1, k2}.mrhoLT{end}.dense;
        rhoLTMRXs{idx}{k1, k2} = rhoLTMs{idx}{k1, k2}.dense;
      else
        rhoLTMRs{idx}{k1, k2}  = rhoLTMs{idx}{k1, k2}.dense;
      end
    end
  end
end
result.phi                     = phi;
if isfield(plot_info, 'show_phi_type') && ~isempty(plot_info.show_phi_type)
  switch plot_info.show_phi_type
    case 'phihat'
      result.phihats           = phihats;
    case 'phihatsmooth'
      result.phihats           = phihatsmooths;
    case 'phihatreg'
      result.phihats           = phihatregs;
    otherwise
  end
else
  result.phihats               = phihatsmooths;
end
result.phihatcleans            = phihatcleans;
result.rhoLTR                  = rhoLTR;
result.rhoLTMRs                = rhoLTMRs;
result.rhoLTRX                 = rhoLTRX;
result.rhoLTMRXs               = rhoLTMRXs;
result.rhoLTX                  = rhoLTX;
result.rhoLTMXs                = rhoLTMXs;
result.phi_type                = phi_type;
result.rho_type                = rho_type;
end