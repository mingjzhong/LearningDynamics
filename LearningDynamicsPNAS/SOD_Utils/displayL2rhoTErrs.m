function displayL2rhoTErrs(learningOutput, sys_info)

% function displayIntKernelErrs(learningOutput, sys_info)

% (c) M. Zhong

% \phi^E
if ~isempty(sys_info.phiE)
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.L2rhoTErr.EErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.L2rhoTErr.EErrSmooth;
    end
    printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, 'energy');
end

% \phi^A
if sys_info.ode_order == 2 && ~isempty(sys_info.phiA)
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.L2rhoTErr.AErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.L2rhoTErr.AErrSmooth;
    end
    printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, 'alignment');
end
% \phi^\xi
if sys_info.ode_order == 2 && sys_info.has_xi
    Err       = cell(size(learningOutput));
    ErrSmooth = cell(size(learningOutput));
    for trial_idx = 1 : length(learningOutput)
        Err{trial_idx}       = learningOutput{trial_idx}.L2rhoTErr.XiErr;
        ErrSmooth{trial_idx} = learningOutput{trial_idx}.L2rhoTErr.XiErrSmooth;
    end
    printOneL2rhoTErr(sys_info.K, Err, ErrSmooth, 'xi');
end

return