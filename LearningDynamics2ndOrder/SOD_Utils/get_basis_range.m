function range = get_basis_range(learningOutput, sys_info, type)
% function range = get_basis_range(learningOutput, sys_info, type)

% (C) M. Zhong

n_trials                    = length(learningOutput);
basis                       = cell(1, n_trials);
range                       = cell(sys_info.K);
switch type
  case 'energy'
    for idx = 1 : n_trials
      basis{idx}            = learningOutput{idx}.Estimator.Ebasis;
    end
  case 'alignment'
    for idx = 1 : n_trials
      basis{idx}            = learningOutput{idx}.Estimator.Abasis;
    end    
  case 'xi'
    for idx = 1 : n_trials
      basis{idx}            = learningOutput{idx}.Estimator.Xibasis;
    end    
  otherwise
    error('SOD_Utils:get_basis_range:exception', 'Only three kinds of basis are supported!!');
end
for idx1 = 1 : n_trials
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      if idx1 == 1
        range{k1, k2}       = basis{idx1}{k1, k2}.supp;
      else
        range{k1, k2}(:, 1) = min(basis{idx1}{k1, k2}.supp(:, 1), range{k1, k2}(:, 1));
        range{k1, k2}(:, 2) = max(basis{idx1}{k1, k2}.supp(:, 2), range{k1, k2}(:, 2));
      end
    end
  end
end
end