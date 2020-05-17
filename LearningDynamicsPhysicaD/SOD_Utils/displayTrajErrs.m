function displayTrajErrs(learningOutput, obs_info, sys_info, solver_info)
% function displayTrajErrs(learningOutput, obs_info, sys_info, solver_info)

% (C) M. Zhong (JHU)

% relative trajectory error from training data
trajErrs                                          = cell(1, length(learningOutput));
for ind = 1 : length(learningOutput)
  trajErrs{ind}                                   = learningOutput{ind}.trajErr;
end
[x_mean, x_std, v_mean, v_std, xi_mean, xi_std]   = getTrajErrStat(trajErrs, sys_info);
type                                              = 'training IC''s';
printTrajErrs(obs_info, solver_info, x_mean, x_std, v_mean, v_std, xi_mean, xi_std, type);
% relative trajectory error from new initial data
for ind = 1 : length(learningOutput)
  trajErrs{ind}                                   = learningOutput{ind}.trajErr_new;
end
[x_mean, x_std, v_mean, v_std, xi_mean, xi_std]   = getTrajErrStat(trajErrs, sys_info);
type                                              = 'new IC''s';
printTrajErrs(obs_info, solver_info, x_mean, x_std, v_mean, v_std, xi_mean, xi_std, type);
if isfield(learningOutput{1}, 'trajErr_Ntransfer') && ~isempty(learningOutput{1}.trajErr_Ntransfer)
  for ind = 1 : length(learningOutput)
    trajErrs{ind}                                 = learningOutput{ind}.trajErr_new;
  end
  [x_mean, x_std, v_mean, v_std, xi_mean, xi_std] = getTrajErrStat(trajErrs, sys_info);
  type                                            = 'larger N';
  printTrajErrs(obs_info, solver_info, x_mean, x_std, v_mean, v_std, xi_mean, xi_std, type);
end
end