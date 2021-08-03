function learn_info = update_basis_info(Estimator, learn_info)
% function learn_info = update_basis_info(Estimator, learn_info)

% (C) M. Zhong

if isfield(Estimator, 'Ebasis') && ~isempty(Estimator.Ebasis)
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      learn_info.Ebasis_info{k1, k2}.n  = Estimator.Ebasis{k1, k2}.n;
    end
  end
end
if isfield(Estimator, 'Abasis') && ~isempty(Estimator.Abasis)
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      learn_info.Abasis_info{k1, k2}.n  = Estimator.Abasis{k1, k2}.n;
    end
  end
end
if isfield(Estimator, 'Xibasis') && ~isempty(Estimator.Xibasis)
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      learn_info.Xibasis_info{k1, k2}.n = Estimator.Xibasis{k1, k2}.n;
    end
  end
end
end