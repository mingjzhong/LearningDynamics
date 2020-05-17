function phiReg = regularizeInfluenceFunction_each_kind(phi, basis, learn_info)
% function phiReg = regularizeInfluenceFunction_each_kind(phi, basis, learn_info)

% (C) M. Zhong

centers     = get_sample_pts(basis);
if ~iscolumn(centers), centers = centers'; end
phi_vec     = phi(centers);
phi_range   = abs(max(phi_vec) - min(phi_vec));
num_pts     = ceil(length(centers) * 5) + 1;
rq          = linspace(basis.knots(1), basis.knots(end), num_pts);
psiMat      = get_gravity_psiMat(basis.f, centers);
dpsiMat     = get_gravity_psiMat(basis.df, rq);
dpsiMat_LRS = dpsiMat(1 : end - 1, :);
weight      = rq(1 : end - 1);
regMat      = dpsiMat_LRS;
if isfield(learn_info, 'use_weight') && ~isempty(learn_info.use_weight) && learn_info.use_weight
  if ~iscolumn(weight), weight = weight'; end
  W         = spdiags(weight, 0, length(weight), length(weight));
else
  W         = 1;
end
lambda      = min([phi_range * 1e8, 1e-3]);
regMat      = W * regMat;
h           = rq(2) - rq(1); 
alphas      = pinv(psiMat' * psiMat + lambda * h * (regMat') * regMat) * psiMat' * phi_vec;
phiReg      = @(r) eval_basis_functions(r, alphas, basis);
end