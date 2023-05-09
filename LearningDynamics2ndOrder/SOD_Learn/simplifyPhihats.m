function Estimator = simplifyPhihats(Estimator)
% function Estimator = simplifyPhihats(Estimator)

% (C) M. Zhong

Estimator.phiEhatsmooth  = []; 
Estimator.Ebasissmooth   = []; 
Estimator.phiAhatsmooth  = []; 
Estimator.Abasissmooth   = []; 
Estimator.phiXihatsmooth = []; 
Estimator.Xibasissmooth  = [];
% go through the three kinds of interaction laws and save the output
if ~isempty(Estimator.phiEhat)
 [Estimator.phiEhatsmooth, Estimator.Ebasissmooth] ...
                         = simplifyPhihats_each_kind(Estimator.phiEhat, Estimator.Ebasis, ...
                           Estimator.Ebasis_plan);   
end
if ~isempty(Estimator.phiAhat)
 [Estimator.phiAhatsmooth, Estimator.Abasissmooth] ...
                         = simplifyPhihats_each_kind(Estimator.phiAhat, Estimator.Abasis, ...
                           Estimator.Abasis_plan);  
end 
if ~isempty(Estimator.phiXihat)
 [Estimator.phiXihatsmooth, Estimator.Xibasissmooth] ...
                         = simplifyPhihats_each_kind(Estimator.phiXihat, Estimator.Xibasis, ...
                           Estimator.Xibasis_plan);  
end
end