function rho_range = get_rho_range(learningOutput, sys_info, type)
% function rho_range = get_rho_range(learningOutput, sys_info, type)

% (C) M. Zhong

if ~strcmp(type, 'energy') || (isfield(sys_info, 'projE') && ~isempty(sys_info.projE))
  n_trials                       = length(learningOutput);
  rho_range                      = cell(sys_info.K);
  switch type
    case 'energy'
      ind                        = 1;
    case 'alignment'
      if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
        ind                      = 2;
      else
        ind                      = 1;
      end
    case 'xi'
      ind                        = length(learningOutput{1}.Estimator.rhoLTM);
    otherwise
      error('');
  end
  for idx = 1 : n_trials
    rhoLTM                       = learningOutput{idx}.Estimator.rhoLTM{ind};
    for k1 = 1 : sys_info.K
      for k2 = 1 : sys_info.K
        if ~isempty(rhoLTM{k1, k2})
          if idx == 1
            rho_range{k1, k2}    = rhoLTM{k1, k2}.supp(end, :);
          else
            rho_range{k1, k2}(1) = min(rhoLTM{k1, k2}.supp{end}(1), rho_range{k1, k2}(1));
            rho_range{k1, k2}(2) = max(rhoLTM{k1, k2}.supp{end}(2), rho_range{k1, k2}(2));
          end
        end
      end
    end
  end 
else
  rho_range                      = [];
end
end