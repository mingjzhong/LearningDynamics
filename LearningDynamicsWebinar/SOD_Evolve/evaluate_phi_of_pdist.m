function phi_of_pdist = evaluate_phi_of_pdist(phi, pdist_data)
% function phi_of_pdist = evaluate_phi_of_pdist(phi, pdist_data)

% (C) M. Zhong

switch length(pdist_data)
  case 1
    pdist_mat    = pdist_data{1};
    phi_of_pdist = phi(pdist_mat(:));
  case 2
    pdist_mat1   = pdist_data{1};
    pdist_mat2   = pdist_data{2};
    phi_of_pdist = phi(pdist_mat1(:), pdist_mat2(:));
  case 3
    pdist_mat1   = pdist_data{1};
    pdist_mat2   = pdist_data{2};
    pdist_mat3   = pdist_data{3};
    phi_of_pdist = phi(pdist_mat1(:), pdist_mat2(:), pdist_mat3(:));    
  otherwise
    error('SOD_Evolve:evaluate_phi_of_pdist:exceptoin', ...
      'Only 1D to 3D phis are supported!!');
end
end