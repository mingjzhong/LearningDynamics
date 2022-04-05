function [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence(psi_pdist, psi_pdiff, ...
                                                   phi_rest, basis, d, Nk)
% function [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence(psi_pdist, psi_pdiff, ...
%                                                    phi_rest, basis, d, Nk)

% (C) M. Zhong (JHU)

psi_dim            = length(psi_pdist);                                                             % dimension of the basis function
switch psi_dim
  case 1
    [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_1D(psi_pdist{1}, psi_pdiff, ...
                                              phi_rest, basis, d, Nk);
  case 2
    [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_2D(psi_pdist{1}, psi_pdist{2}, ...
                                              psi_pdiff, phi_rest, basis, d, Nk);
  case 3
    [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_3D(psi_pdist{1}, psi_pdist{2}, ...
                                              psi_pdist{3}, psi_pdiff, phi_rest, basis, d, Nk);      
  otherwise
    error('SOD_Learn:get_type_influence:exception', ...
      'Dim. of the basis can only be 1, 2, or 3!!');
end
end
