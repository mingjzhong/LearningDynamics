function L2rhoTErr = computeL2rhoTErr(Estimator, sys_info, obs_info)
% function L2rhoTErr = computeL2rhoTErr(Estimator, sys_info, obs_info)

% (c) M. Zhong

% go through three kinds of interaction laws
if ~isempty(sys_info.phiE)
  L2rhoTErr.EErr        = relativeErrorInfluenceFunction(Estimator.phiEhat,       sys_info.phiE, sys_info, obs_info, Estimator.Ebasis,  'energy');
  L2rhoTErr.EErrSmooth  = relativeErrorInfluenceFunction(Estimator.phiEhatsmooth, sys_info.phiE, sys_info, obs_info, Estimator.Ebasis2, 'energy');
end
if sys_info.ode_order == 2 && ~isempty(sys_info.phiA)
  L2rhoTErr.AErr        = relativeErrorInfluenceFunction(Estimator.phiAhat,       sys_info.phiA, sys_info, obs_info, Estimator.Abasis,  'alignment');
  L2rhoTErr.AErrSmooth  = relativeErrorInfluenceFunction(Estimator.phiAhatsmooth, sys_info.phiA, sys_info, obs_info, Estimator.Abasis2, 'alignment');
end
if sys_info.ode_order == 2 && sys_info.has_xi
  L2rhoTErr.XiErr       = relativeErrorInfluenceFunction(Estimator.phiXihat,       sys_info.phiXi, sys_info, obs_info, Estimator.Xibasis,  'xi');
  L2rhoTErr.XiErrSmooth = relativeErrorInfluenceFunction(Estimator.phiXihatsmooth, sys_info.phiXi, sys_info, obs_info, Estimator.Xibasis2, 'xi');
end
end