function learn_out = set_sys_info_for_learn_out(learn_info, learn_out)
% function learn_out = set_sys_info_for_learn_out(learn_info, learn_out)

% (C) M. Zhong

syshat_info                 = learn_info.sys_info;           % phihats
syshat_info.phiE            = learn_out.Estimator.phiEhat;
syshat_info.phiA            = learn_out.Estimator.phiAhat;
syshat_info.phiXi           = learn_out.Estimator.phiXihat;
learn_out.syshat_info       = syshat_info;                   % smooth phihats
syshatsmooth_info           = learn_info.sys_info;
syshatsmooth_info.phiE      = learn_out.Estimator.phiEhatsmooth;
syshatsmooth_info.phiA      = learn_out.Estimator.phiAhatsmooth;
syshatsmooth_info.phiXi     = learn_out.Estimator.phiXihatsmooth;
learn_out.syshatsmooth_info = syshatsmooth_info;
%% Regularize interaction(s)
if isfield(learn_info, 'use_reg') && ~isempty(learn_info.use_reg) && learn_info.use_reg
  syshatreg_info            = learn_info.sys_info;           % regularized phihats
  syshatreg_info.phiE       = learn_out.Estimator.phiEhatReg;
  syshatreg_info.phiA       = learn_out.Estimator.phiAhatReg;
  syshatreg_info.phiXi      = learn_out.Estimator.phiXihatReg;
else
  learn_out.syshatreg_info  = [];
end
end