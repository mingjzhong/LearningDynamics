function [f, gradf] = total_loss_function_on_beta_and_phim(x, params, type)
% function [f, gradf] = total_loss_function_on_beta_and_phim(x, params, type)

% M. Zhong (JHU)

switch type
  case 'first'
    phiEhat         = params.phiEhatkkp;
    phiEhat_L2rho   = params.phiEhatkkpdrho;
    rhoEhat         = params.rhoEhatkkp;
    [Nm1, Q]        = size(rhoEhat);
    betas           = x(1) * ones(Nm1, 1);
    phim_vec        = x(2 : Q + 1);
  case 'second'
    phiEhat         = params.phiEhatkpk;
    phiEhat_L2rho   = params.phiEhatkpkdrho;
    rhoEhat         = params.rhoEhatkpk;
    [Nm1, Q]        = size(rhoEhat); 
    phim_vec        = params.phim_vec;
    betas           = x; 
  otherwise
    error('');
end
if ~iscolumn(phim_vec), phim_vec = phim_vec'; end
if ~iscolumn(phiEhat_L2rho), phiEhat_L2rho = phiEhat_L2rho'; end    
weight_mat           = rhoEhat./repmat(phiEhat_L2rho, [1, Q]);
diff_mat             = phiEhat - betas * phim_vec';
f                    = weighted_Lp_frobenius_norm(diff_mat, weight_mat, 2)^2;
gradf                = zeros(size(x));  
switch type
  case 'first'
    gradf(1)         = -2 * sum((diff_mat .* weight_mat) * phim_vec);
    gradf(2 : Q + 1) = -2 * (x(1) * ones(1, Nm1) * (diff_mat .* weight_mat));
  case 'second'
    gradf            = -2 * (diff_mat .* weight_mat) * phim_vec;
  otherwise
end
end