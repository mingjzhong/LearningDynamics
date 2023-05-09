function result = computePatternIndicatorforEachTrajType(trajErr, sys_info)
% function result = computePatternIndicatorforEachTrajType(trajErr, sys_info)

% (C) M. Zhong

M                     = size(trajErr.sup, 2);
if strcmp(sys_info.LC_type, 'Concentric')
  total_E             = trajErr.total_energy;
  total_Ehat          = trajErr.total_energyhat;
  traj_T_f            = zeros(1, 1, M);
  dtraj_T_f           = zeros(1, 1, M);
  trajhat_T_f         = zeros(1, 1, M);
  dtrajhat_T_f        = zeros(1, 1, M);
else
  traj_T_f            = trajErr.traj_T_f;
  dtraj_T_f           = trajErr.dtraj_T_f;
  trajhat_T_f         = trajErr.trajhat_T_f;
  dtrajhat_T_f        = trajErr.dtrajhat_T_f;  
  total_E             = zeros(1, 1, M);
  total_Ehat          = zeros(1, 1, M);
end
scores                = zeros(2, M);
cMatrices             = zeros(2, 2, M);
parfor m = 1 : M
  total_Em            = squeeze(total_E(:, :, m));
  total_Ehatm         = squeeze(total_Ehat(:, :, m));
  pattern_indicator   = computePatternIndicator_for_each_m(traj_T_f(:, m), dtraj_T_f(:, m), ...
                        trajhat_T_f(:, m), dtrajhat_T_f(:, m), total_Em, total_Ehatm, sys_info);
  scores(:, m)        = pattern_indicator.scores;
  cMatrices(:, :, m)  = pattern_indicator.cMatrix;
end
result.scores         = scores;
result.cMatrix        = sum(cMatrices, 3)/M;
pred_truth            = sum(result.cMatrix(:, 2));
if pred_truth > 0
  result.precision    = result.cMatrix(2, 2)/pred_truth;
else
  result.precision    = 1;  
end
actual_truth          = sum(result.cMatrix(2, :));
if actual_truth > 0
  result.recall       = result.cMatrix(2, 2)/actual_truth;
else
  result.recall       = 1;
end
result.F_score        = 2/(1/result.precision + 1/result.recall);
result.accuracy       = (result.cMatrix(1, 1) + result.cMatrix(2, 2));
result.MR             = (result.cMatrix(1, 2) + result.cMatrix(2, 1));
end