function new_Estimator = simplifyPhihats(Estimator)
% function new_Estimator = simplifyPhihats(Estimator)

% (C) M. Zhong

new_Estimator               = Estimator;
new_Estimator.phiEhatsmooth = []; new_Estimator.Ebasissmooth   = []; new_Estimator.phiAhatsmooth = []; 
new_Estimator.Abasissmooth  = []; new_Estimator.phiXihatsmooth = []; new_Estimator.Xibasissmooth = [];
% go through the three kinds of interaction laws and save the output
if ~isempty(Estimator.phiEhat)
 [new_Estimator.phiEhatsmooth,  new_Estimator.Ebasissmooth]  = simplifyPhihats_each_kind(Estimator.phiEhat,  Estimator.Ebasis);   
end
if ~isempty(Estimator.phiAhat)
 [new_Estimator.phiAhatsmooth,  new_Estimator.Abasissmooth]  = simplifyPhihats_each_kind(Estimator.phiAhat,  Estimator.Abasis);  
end 
if ~isempty(Estimator.phiXihat)
 [new_Estimator.phiXihatsmooth, new_Estimator.Xibasissmooth] = simplifyPhihats_each_kind(Estimator.phiXihat, Estimator.Xibasis);  
end
end