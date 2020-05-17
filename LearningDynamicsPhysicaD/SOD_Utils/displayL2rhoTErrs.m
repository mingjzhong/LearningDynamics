function displayL2rhoTErrs(learningOutput, sys_info)

% function displayIntKernelErrs(learningOutput, sys_info)

% (c) M. Zhong

% \phi^E
is_gravity               = isfield(sys_info, 'LC_type') && ~isempty(sys_info.LC_type) && ...
                           strcmp(sys_info.LC_type, 'Concentric');
if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
  Err                    = cell(size(learningOutput));
  ErrSmooth              = cell(size(learningOutput));
  if is_gravity, ErrClean = cell(size(learningOutput)); else, ErrClean = []; end
  for trial_idx = 1 : length(learningOutput)
    Err{trial_idx}       = learningOutput{trial_idx}.L2rhoTErr.EErr;
    ErrSmooth{trial_idx} = learningOutput{trial_idx}.L2rhoTErr.EErrSmooth;
    if is_gravity, ErrClean{trial_idx} = learningOutput{trial_idx}.L2rhoTErr.EErrClean; end
  end
  printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, ErrClean, learningOutput{1}.Estimator.Ebasis, 'energy');
end

% \phi^A
if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}        = learningOutput{trial_idx}.L2rhoTErr.AErr;
        ErrSmooth{trial_idx}  = learningOutput{trial_idx}.L2rhoTErr.AErrSmooth;
    end
    printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, [], learningOutput{1}.Estimator.Abasis, 'alignment');
end
% \phi^\xi
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    Err                       = cell(size(learningOutput));
    ErrSmooth                 = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}        = learningOutput{trial_idx}.L2rhoTErr.XiErr;
        ErrSmooth{trial_idx}  = learningOutput{trial_idx}.L2rhoTErr.XiErrSmooth;
    end
    printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, [], learningOutput{1}.Estimator.Xibasis, 'xi');
end
end