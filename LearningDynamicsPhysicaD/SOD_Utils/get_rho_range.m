function rho_range = get_rho_range(learningOutput, sys_info, type)
% function rho_range = get_rho_range(learningOutput, sys_info, type)

% (C) M. Zhong

if strcmp(type, 'energy') && ~contains(sys_info.name, 'SynchronizedOscillatorDynamics')
  rho_range                   = [];
else
  n_trials                    = length(learningOutput);
  rho_range                   = cell(sys_info.K);
  switch type
    case 'energy'
      ind                     = 1;
    case 'alignment'
      ind                     = 2;
    case 'xi'
      if sys_info.ode_order == 1
        ind                   = 2;
      elseif sys_info.ode_order == 2
        ind                   = 3;
      end
    otherwise
      error('');
  end
  for idx = 1 : n_trials
    rhoLTM                    = learningOutput{idx}.Estimator.rhoLTM{ind};
    for k1 = 1 : sys_info.K
      for k2 = 1 : sys_info.K
        if ~isempty(rhoLTM{k1, k2})
          if idx == 1
            rho_range{k1, k2}    = rhoLTM{k1, k2}.supp{end};
          else
            rho_range{k1, k2}(1) = min(rhoLTM{k1, k2}.supp{end}(1), rho_range{k1, k2}(1));
            rho_range{k1, k2}(2) = max(rhoLTM{k1, k2}.supp{end}(2), rho_range{k1, k2}(2));
          end
        end
      end
    end
  end   
end
end