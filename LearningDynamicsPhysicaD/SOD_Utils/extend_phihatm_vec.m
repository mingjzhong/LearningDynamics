function [phihatm, alphas, basis] = extend_phihatm_vec(phihatm_vec, rq, supp, pred_phihatm, ...
                                    src_pos, options)
% function [phihatm, alphas, basis] = extend_phihatm_vec(phihatm_vec, rq, supp, pred_phihatm, ...
%                                      src_pos, optoins)

% (C) M. Zhong

degree         = 2;
Q              = length(phihatm_vec);
n              = Q;
basis          = construct_gravity_basis(degree, supp, n);
psiMat         = get_gravity_psiMat(basis.f, rq);
% extend the range to the whole support
if isfield(options, 'h') && ~isempty(options.h) 
  h            = options.h;
  num_pts      = ceil(abs(supp(2) - supp(1))/h);
else
  num_pts      = ceil(2.5 * Q) + 1;
end
rq             = linspace(basis.supp(1), basis.supp(2), num_pts);                                            
if options.derivative_type == 1
  dpsiMat      = get_gravity_psiMat(basis.df, rq);
  dpsiMat_LRS  = dpsiMat(1 : end - 1, :);                                                           % the left Riemman sum of dpsiMat
  weight       = rq(1 : end - 1).^1.125;
  regMat       = dpsiMat_LRS;
elseif options.derivative_type == 2
  d2psiMat     = get_gravity_psiMat(basis.d2f, rq);
  d2psiMat_LRS = d2psiMat(1 : end - 1, :);
  weight       = rq(1 : end - 1).^2.125;
  regMat       = d2psiMat_LRS;
end
if isfield(options, 'use_weight') && ~isempty(options.use_weight) && options.use_weight
  if ~iscolumn(weight), weight = weight'; end
  W            = spdiags(weight, 0, length(weight), length(weight));
  lambda       = 1e-6;
else
  W            = 1;
  lambda       = 1e-3;
end
regMat         = W * regMat;
h              = rq(2) - rq(1);  
fprintf('\n\tExtending phihatm(r_q) to a continuous function phihatm(r).');
fprintf('\n\tUsing Clamped B-splines (degree = %d, n = %d) via %d phihatm(r_q) points.', degree, n, Q);
fprintf('\n\tReg. integral is approximated with %d points and lambda = %10.4e', num_pts, lambda);
alphas         = pinv(psiMat' * psiMat + lambda * h * (regMat') * regMat) * psiMat' * phihatm_vec;
phihatm        = @(r) eval_basis_functions_1D(r, alphas, basis);
if options.debug
  figure('Name', 'Gravity: phihat_m vs. 1/r^3', 'NumberTitle', 'off', 'Position', src_pos);
  ind          = phihatm(rq) > 0; 
  loglog(rq(ind), phihatm(rq(ind)), 'bo');
  hold on;
  loglog(rq(ind), pred_phihatm(rq(ind)), '--r');
  hold off;
end
end
