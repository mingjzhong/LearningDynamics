function displayIntKernelErrs(learningOutput, sys_info)

% function displayIntKernelErrs(learningOutput, sys_info)

% (c) M. Zhong

% \phi^E
if ~isempty(sys_info.phiE)
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.EErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.EErrSmooth;
    end
    printIntKerErr_kind(sys_info.K, Err, ErrSmooth, 'energy');
end

% \phi^A
if sys_info.ode_order == 2 && ~isempty(sys_info.phiA)
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.AErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.AErrSmooth;
    end
    printIntKerErr_kind(sys_info.K, Err, ErrSmooth, 'alignment');
end
% \phi^\xi
if sys_info.ode_order == 2 && sys_info.has_xi
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.XiErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.XiErrSmooth;
    end
    printIntKerErr_kind(sys_info.K, Err, ErrSmooth, 'xi');
end

return