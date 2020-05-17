function result = get_phis_and_rhos_for_plotting(learningOutput, sys_info, obs_info, type)
%

% (C) M. Zhong

n_trials                       = length(learningOutput);
phihats                        = cell(1, n_trials); 
phihatsmooths                  = cell(1, n_trials);
phihatregs                     = cell(1, n_trials);
rhoLTMs                        = cell(1, n_trials);
is_SOD                         = contains(sys_info.name, 'SynchronizedOscillatorDynamics');
switch type
  case 'energy'
    phi                        = sys_info.phiE;
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, 'energy');
    phi_type                   = '_phiE';
    rho_type                   = '_rhoE';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiEhat;
      phihatsmooths{ind}       = learningOutput{ind}.Estimator.phiEhatsmooth;
      if ~isempty(learningOutput{ind}.Estimator.phiEhatReg)
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
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, 'energy');
    end     
  case 'alignment'
    phi                        = sys_info.phiA;
    phihatcleans               = [];
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, 'alignment');
    phi_type                   = '_phiA';
    rho_type                   = '_rhoA';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiAhat;
      phihatsmooths{ind}       = learningOutput{ind}.Estimator.phiAhatsmooth;
      if ~isempty(learningOutput{ind}.Estimator.phiAhatReg)
        phihatregs{ind}        = learningOutput{ind}.Estimator.phiAhatReg;
      end
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, 'alignment');
    end     
  case 'xi'
    phi                        = sys_info.phiXi;
    phihatcleans               = [];
    rhoLT                      = get_the_rhoLT(obs_info.rhoLT, 'xi'); 
    phi_type                   = '_phiXi';
    rho_type                   = '_rhoXi';
    for ind = 1 : n_trials
      phihats{ind}             = learningOutput{ind}.Estimator.phiXihat;
      phihatsmooths{ind}       = learningOutput{ind}.Estimator.phiXihatsmooth;
      if ~isempty(learningOutput{ind}.Estimator.phiXihatReg)
        phihatregs{ind}        = learningOutput{ind}.Estimator.phiXihatReg;
      end
      rhoLTMs{ind}             = get_the_rhoLT(learningOutput{ind}.Estimator.rhoLTM, 'xi');   
    end 
  otherwise
end
rhoLTR                         = cell(sys_info.K);
rhoLTMRs                       = cell(1, n_trials);
if ~strcmp(type, 'energy') || is_SOD, rhoLTX    = cell(sys_info.K);  else, rhoLTX    = []; end
if ~strcmp(type, 'energy') || is_SOD, rhoLTRX   = cell(sys_info.K);  else, rhoLTRX   = []; end
if ~strcmp(type, 'energy') || is_SOD, rhoLTMXs  = cell(1, n_trials); else, rhoLTMXs  = []; end
if ~strcmp(type, 'energy') || is_SOD, rhoLTMRXs = cell(1, n_trials); else, rhoLTMRXs = []; end
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if ~strcmp(type, 'energy') || is_SOD
      rhoLTR{k1, k2}           = rhoLT{k1, k2}.mrhoLT{1}.dense;
      rhoLTX{k1, k2}           = rhoLT{k1, k2}.mrhoLT{end}.dense;
      rhoLTRX{k1, k2}          = rhoLT{k1, k2}.dense;
    else
      rhoLTR{k1, k2}           = rhoLT{k1, k2}.dense;
    end
  end
end
for idx = 1 : n_trials
  rhoLTMRs{idx}                = cell(sys_info.K);
  if ~strcmp(type, 'energy') || is_SOD
    rhoLTMXs{idx}              = cell(sys_info.K);
    rhoLTMRXs{idx}             = cell(sys_info.K);
  end  
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      if ~strcmp(type, 'energy') || is_SOD
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
result.phihats                 = phihats;
result.phihatsmooths           = phihatsmooths;
result.phihatregs              = phihatregs;
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