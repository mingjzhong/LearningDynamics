function L2rhoTErr = computeL2rhoTErr(Estimator, sys_info, obs_info)
% function L2rhoTErr = computeL2rhoTErr(Estimator, sys_info, obs_info)

% (c) M. Zhong

% go through three kinds of interaction laws
if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
  L2rhoTErr.EErr        = relativeErrorInfluenceFunction(Estimator.phiEhat, sys_info.phiE, ...
                          sys_info, obs_info, Estimator.Ebasis, 'energy');
  L2rhoTErr.EErrSmooth  = relativeErrorInfluenceFunction(Estimator.phiEhatsmooth, sys_info.phiE, ...
                          sys_info, obs_info, Estimator.Ebasissmooth, 'energy');
  if isfield(Estimator, 'phiEhatclean') && ~isempty(Estimator.phiEhatclean)
    L2rhoTErr.EErrClean = relativeErrorInfluenceFunction(Estimator.phiEhatclean, sys_info.phiE, ...
                          sys_info, obs_info, Estimator.Ebasisclean, 'energy');
  end
  if isfield(Estimator, 'phiEhatReg') && ~isempty(Estimator.phiEhatReg)
    L2rhoTErr.EErrReg   = relativeErrorInfluenceFunction(Estimator.phiEhatReg, sys_info.phiE, ...
                          sys_info, obs_info, Estimator.EbasisReg, 'energy');
  end  
end
if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
  L2rhoTErr.AErr        = relativeErrorInfluenceFunction(Estimator.phiAhat, sys_info.phiA, ...
                          sys_info, obs_info, Estimator.Abasis, 'alignment');
  L2rhoTErr.AErrSmooth  = relativeErrorInfluenceFunction(Estimator.phiAhatsmooth, sys_info.phiA, ...
                          sys_info, obs_info, Estimator.Abasissmooth, 'alignment');
  if isfield(Estimator, 'phiAhatReg') && ~isempty(Estimator.phiAhatReg)
    L2rhoTErr.AErrReg   = relativeErrorInfluenceFunction(Estimator.phiAhatReg, sys_info.phiA, ...
                          sys_info, obs_info, Estimator.AbasisReg, 'alignment');
  end                         
end
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  L2rhoTErr.XiErr       = relativeErrorInfluenceFunction(Estimator.phiXihat, sys_info.phiXi, ...
                          sys_info, obs_info, Estimator.Xibasis, 'xi');
  L2rhoTErr.XiErrSmooth = relativeErrorInfluenceFunction(Estimator.phiXihatsmooth, sys_info.phiXi, ...
                          sys_info, obs_info, Estimator.Xibasissmooth, 'xi');
  if isfield(Estimator, 'phiXihatReg') && ~isempty(Estimator.phiXihatReg)
    L2rhoTErr.XiErrReg  = relativeErrorInfluenceFunction(Estimator.phiXihatReg, sys_info.phiXi, ...
                          sys_info, obs_info, Estimator.XibasisReg, 'xi');
  end                         
end
end