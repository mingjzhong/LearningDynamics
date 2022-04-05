function [R, h] = get_regularization_matrix(basis, method)
% function [R, h] = get_regularization_matrix(basis, method)

% (C) M. Zhong

switch method
  case 'L2'
    psis    = basis.f;
  case 'L1'
    psis    = basis.f;
  case 'TV'
    psis    = basis.df;
  case 'H1semi'
    psis    = basis.df;
  otherwise
    error('SOD_Learn:solve_for_alphas_with_regularization:exception', ...
      'Regularization method can be L2, L1, TV, or H1semi!!');    
end
resol       = 2500;
r_pts       = linspace(basis.supp(1), basis.supp(2), resol + 1);
r_ctrs      = (r_pts(2 : end) + r_pts(1 : end - 1))/2;
if ~iscolumn(r_ctrs), r_ctrs = r_ctrs'; end
R           = zeros(length(r_ctrs), length(psis));
for eta = 1 : length(psis)
  R(:, eta) = psis{eta}(r_ctrs);
end
h           = (basis.supp(2) - basis.supp(1))/resol;
end