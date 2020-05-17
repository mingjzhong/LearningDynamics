function [PsiE, PsiA, PsiXi, F_vec, d_vec, Fxi_vec, dxi_vec] = scale_the_quantities(PsiE_old, PsiA_old, PsiXi_old, F_vec_old, d_vec_old, Fxi_vec_old, dxi_vec_old, sys_info)
% function [PsiE, PsiA, PsiXi, F_vec, d_vec, Fxi_vec, d_xi_vec] = scale_the_quantities(PsiE_old, PsiA_old, PsiXi_old, F_vec_old, d_vec_old, Fxi_vec_old, d_xi_vec_old, sys_info)

% (C) M. Zhong (JHU)

% find out how many time instances
L         = length(d_vec_old)/(sys_info.d * sys_info.N);
% find out the scaling factors for vectors having L * N * D entries or matrices having L * N * D rows
[D, D_xi] = get_Nks_D_mat(L, sys_info);
% scale the non-collective influence term
if ~isempty(F_vec_old),   F_vec   = D * F_vec_old; else, F_vec = []; end
if ~isempty(Fxi_vec_old), Fxi_vec = D_xi * Fxi_vec_old; else, Fxi_vec = []; end
% scale the derivative terms
d_vec     = D * d_vec_old;
if ~isempty(dxi_vec_old), dxi_vec = D_xi * dxi_vec_old; else, dxi_vec = []; end
% scale the energy terms
if ~isempty(PsiE_old),    PsiE    = D * PsiE_old; else, PsiE = []; end
% scale the alignment terms
if ~isempty(PsiA_old),    PsiA    = D * PsiA_old; else, PsiA = []; end
% scale the xi terms
if ~isempty(PsiXi_old),   PsiXi   = D_xi * PsiXi_old; else, PsiXi = []; end
end