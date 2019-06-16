function new_Estimator = regularize_Estimator(Estimator, rhoLTemp, learn_info)
% function new_learn_out = regularize_Estimator(learn_out, learn_info)

% (c) M. Zhong

new_Estimator                 = Estimator;
% go through the three kinds of interaction laws and save the output
if ~isempty(Estimator.phiEhat)
 [phiEhatsmooth, Ebasis2]     = regularizeInfluenceFunction(Estimator.phiEhat,  Estimator.Ebasis,  rhoLTemp.rhoLTE,         learn_info.sys_info);  
 new_Estimator.phiEhatsmooth  = phiEhatsmooth; 
 new_Estimator.Ebasis2        = Ebasis2;
else
 new_Estimator.phiEhatsmooth  = []; 
 new_Estimator.Ebasis2        = [];  
end
if ~isempty(Estimator.phiAhat)
 [phiAhatsmooth, Abasis2]     = regularizeInfluenceFunction(Estimator.phiAhat,  Estimator.Abasis,  rhoLTemp.rhoLTA.rhoLTR,  learn_info.sys_info);  
 new_Estimator.phiAhatsmooth  = phiAhatsmooth; 
 new_Estimator.Abasis2        = Abasis2;
else
 new_Estimator.phiAhatsmooth  = []; 
 new_Estimator.Abasis2        = [];
end
if ~isempty(Estimator.phiXihat)
 [phiXihatsmooth, Xibasis2]   = regularizeInfluenceFunction(Estimator.phiXihat, Estimator.Xibasis, rhoLTemp.rhoLTXi.rhoLTR, learn_info.sys_info);  
 new_Estimator.phiXihatsmooth = phiXihatsmooth; 
 new_Estimator.Xibasis2       = Xibasis2;
else
 new_Estimator.phiXihatsmooth = []; 
 new_Estimator.Xibasis2       = [];
end
end