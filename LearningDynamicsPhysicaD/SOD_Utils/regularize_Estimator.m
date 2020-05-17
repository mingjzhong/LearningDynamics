function new_Estimator = regularize_Estimator(Estimator, learn_info)
% function new_Estimator = regularize_Estimator(Estimator, learn_info)

% (c) M. Zhong

new_Estimator             = Estimator;
if ~isempty(Estimator.phiEhat)
  phiEhatReg              = regularizeInfluenceFunction2(Estimator.phiEhat,  Estimator.Ebasis, learn_info);
else
  phiEhatReg              = [];
end
if ~isempty(Estimator.phiAhat)
  phiAhatReg              = regularizeInfluenceFunction2(Estimator.phiAhat,  Estimator.Abasis, learn_info);
else
  phiAhatReg              = [];
end
if ~isempty(Estimator.phiXihat)
  phiXihatReg             = regularizeInfluenceFunction2(Estimator.phiXihat, Estimator.Xibasis, learn_info);
else
  phiXihatReg             = [];
end
new_Estimator.phiEhatReg  = phiEhatReg;
new_Estimator.phiAhatReg  = phiAhatReg;
new_Estimator.phiXihatReg = phiXihatReg;
end
% [phiEhatReg, phiAhatReg, opt_val] = regularizeInfluenceFunction(Estimator.ALM, Estimator.bLM, ...
%                                     Estimator.Ebasis, Estimator.rhoLTM{1}, Estimator.Abasis, Estimator.rhoLTM{2}, learn_info);
% if learn_info.sys_info.ode_order == 1
%   state                           = 'x ';
% elseif learn_info.sys_info.ode_order == 2
%   state                           = 'v ';
% end                                  
% fprintf(['\n\tThe empirical error from learning phis on ' state ' is: %10.4e.'], ...
%   opt_val + Estimator.rhs_in_l2_norm_sq);
% new_Estimator.phiEhatReg          = phiEhatReg;
% new_Estimator.phiAhatReg          = phiAhatReg;
% if ~isempty(Estimator.Xibasis)
%   [phiXihatReg, ~, opt_val]       = regularizeInfluenceFunction(Estimator.ALMXi, Estimator.bLMXi, ...
%                                     Estimator.Xibasis, Estimator.rhoLTM{3}, [], [], learn_info);
%   fprintf('\n\tThe empirical error from learning phis on xi is: %10.4e.', ...
%     opt_val + Estimator.rhs_in_l2_norm_sq_xi);                                
% else
%   phiXihatReg                     = [];
% end
% new_Estimator.phiXihatReg         = phiXihatReg; 
% end