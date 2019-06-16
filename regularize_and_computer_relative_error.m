function new_learn_out = regularize_and_computer_relative_error(learn_out, learn_info, obs_info, kind)

% function new_learn_out = regularize_and_computer_relative_error(learn_out, learn_info, obs_info, kind)

% (c) M. Zhong

% pick a set of data
switch kind
    case 'energy'
        phi             = learn_info.sys_info.phiE;
        phihat          = learn_out.Estimator.phiEhat;
        basis           = learn_out.Estimator.Ebasis;
        rhoLTemp        = learn_out.rhoLTemp.rhoLTE;
    case 'alignment'
        phi             = learn_info.sys_info.phiA;
        phihat          = learn_out.Estimator.phiAhat;
        basis           = learn_out.Estimator.Abasis;
        rhoLTemp        = learn_out.rhoLTemp.rhoLTA;
    case 'xi'
        phi             = learn_info.sys_info.phiXi;
        phihat          = learn_out.Estimator.phiXihat;
        basis           = learn_out.Estimator.Xibasis;
        rhoLTemp        = learn_out.rhoLTemp.rhoLTXi;
    otherwise
end
% regularize, compute and output data
[phihatsmooth, basis2]  = regularizeInfluenceFunction   ( phihat, basis, rhoLTemp, learn_info.sys_info );
Err                     = relativeErrorInfluenceFunction( phihat,       phi, learn_info.sys_info, obs_info, basis, kind );
ErrSmooth               = relativeErrorInfluenceFunction( phihatsmooth, phi, learn_info.sys_info, obs_info, basis, kind );
if learn_info.VERBOSE >= 1
    fprintf('\n------------------- For %s based interactions', kind);
    for k1 = 1 : size(Err.Rel, 1)
        for k2 = 1 : size(Err.Rel, 2)
            if Err.Rel(k1, k2) < Inf
                fprintf('\nRelative L_2(rho_T) error of original learned estimator for \\phi_{%d,%d}=%12.6e.', k1, k2, Err.Rel(k1, k2));
                fprintf('\nRelative L_2(rho_T) error of smooth   learned estimator for \\phi_{%d,%d}=%12.6e.', k1, k2, ErrSmooth.Rel(k1, k2));
            else
                fprintf('\nAbsolute L_2(rho_T) error of original learned estimator for \\phi_{%d,%d}=%12.6e.', k1, k2, Err.Abs(k1, k2));
                fprintf('\nAbsolute L_2(rho_T) error of smooth   learend estimator for \\phi_{%d,%d}=%12.6e.', k1, k2, ErrSmooth.Abs(k1, k2));
            end
        end
    end
end

% package data
new_learn_out                              = learn_out;
switch kind
    case 'energy'
        new_learn_out.Estimator.phiEhatsmooth  = phihatsmooth; new_learn_out.Estimator.Ebasis2  = basis2; new_learn_out.EErr  = Err; new_learn_out.EErrSmooth  = ErrSmooth;
    case 'alignment'
        new_learn_out.Estimator.phiAhatsmooth  = phihatsmooth; new_learn_out.Estimator.Abasis2  = basis2; new_learn_out.AErr  = Err; new_learn_out.AErrSmooth  = ErrSmooth;
    case 'xi'
        new_learn_out.Estimator.phiXihatsmooth = phihatsmooth; new_learn_out.Estimator.Xibasis2 = basis2; new_learn_out.XiErr = Err; new_learn_out.XiErrSmooth = ErrSmooth;
    otherwise
end

return