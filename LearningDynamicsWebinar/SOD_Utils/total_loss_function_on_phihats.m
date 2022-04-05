function [f, gradf] = total_loss_function_on_phihats(x, params, type)
% function [f, gradf] = total_loss_function_on_phihats(x, params, type)

% M. Zhong (JHU)

phiEhatkkp         = params.phiEhatkkp;
rhoEhatkkp         = params.rhoEhatkkp;
phiEhatkpk         = params.phiEhatkpk;
rhoEhatkpk         = params.rhoEhatkpk;
kp                 = params.kp;
[Nm1, Q]           = size(phiEhatkkp);
N                  = Nm1 + 1;
N_ind              = setdiff(1 : N, kp);
betakp             = x(kp);
betas              = x(N_ind);                                                                      % other betas from kp + 1 to N
switch type
  case 'first'
    weightkkp      = rhoEhatkkp;
    weightkpk      = rhoEhatkpk;
    phihatm_vec    = x(N + 1 : N + Q);
  case 'second'
    phiEhatkkpdrho = params.phiEhatkkpdrho;
    if ~iscolumn(phiEhatkkpdrho), phiEhatkkpdrho = phiEhatkkpdrho'; end
    phiEhatkpkdrho = params.phiEhatkpkdrho;
    if ~iscolumn(phiEhatkpkdrho), phiEhatkpkdrho = phiEhatkpkdrho'; end
    weightkkp      = rhoEhatkkp./repmat(phiEhatkkpdrho, [1, Q]);
    weightkpk      = rhoEhatkpk./repmat(phiEhatkpkdrho, [1, Q]);
    phihatm_vec    = params.phihatm_vec;
  otherwise
    error('');
end
if ~iscolumn(phihatm_vec), phihatm_vec = phihatm_vec'; end
diff_matkkp        = phiEhatkkp - betakp * ones(Nm1, 1) * phihatm_vec';
diff_matkpk        = phiEhatkpk - betas * phihatm_vec';
f                  = weighted_Lp_frobenius_norm(diff_matkkp, weightkkp, 2)^2 + ...
                     weighted_Lp_frobenius_norm(diff_matkpk, weightkpk, 2)^2;
gradf              = zeros(size(x));  
gradf(kp)          = -2 * sum((diff_matkkp .* weightkkp) * phihatm_vec);
gradf(N_ind)       = -2 * (diff_matkpk .* weightkpk) * phihatm_vec;
if strcmp(type, 'first')
  idx              = N + 1 : N + Q;
  gradf(idx)       = -2 * (betakp * ones(1, Nm1) * (diff_matkkp .* weightkkp) + ...
                           betas' * (diff_matkpk .* weightkpk));
end
end