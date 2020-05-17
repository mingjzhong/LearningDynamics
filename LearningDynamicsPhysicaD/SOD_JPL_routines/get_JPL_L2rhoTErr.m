function L2rhoTErr = get_JPL_L2rhoTErr(Estimator, sys_info)
% function L2rhoTErr = get_JPL_L2rhoTErr(Estimator, sys_info)

% (C) M. Zhong

obs_info.rhoLT     = Estimator.rhoLTM;
L2rhoTErr.Newton   = relativeErrorInfluenceFunction(Estimator.phiEhatsmooth, sys_info.phiE_Newton, ...
                     sys_info, obs_info, Estimator.Ebasissmooth, 'energy');
L2rhoTErr.Einstein = relativeErrorInfluenceFunction(Estimator.phiEhatsmooth, sys_info.phiE_Einstein, ...
                     sys_info, obs_info, Estimator.Ebasissmooth, 'energy');
end