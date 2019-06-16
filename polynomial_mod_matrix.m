function [mat1, mat2] = polynomial_mod_matrix(knot_vec, p, type)
%
%

% Ming Zhong
% Postdoc Researt at JHU

% find out the number of knots
num_knots                   = length(knot_vec);
% find out the number of sub-intervals
num_subin                   = num_knots - 1;
% find out the number of basis functions
num_basis                   = (p + 1) * num_subin;
% find out the modification matrix based on p
if p == 0
% check the number of basis 
  if num_subin ~= num_basis
    error('');
  end
  switch type
    case 'standard'
      mat1                  = spdiags(ones(num_subin, 1), 0, num_subin, num_subin);
      mat2                  = [];
    case 'Legendre'
% find out the step sizes
      steps                 = knot_vec(2 : num_knots) - knot_vec(1 : num_subin);      
% prepare the main diagonal
      main_diag             = transpose(1./sqrt(steps));
% prepare the sparse matrix
      mat1                  = spdiags(main_diag, 0, num_subin, num_subin);
      mat2                  = [];
    otherwise
  end
elseif p == 1
% check the number of basis
  if num_basis ~= 2 * num_subin
    error('');
  end
  switch type
    case 'standard'
% prepare the entries and their corresponding indices for the sparse matrix
      entry                 = zeros(1, 4 * num_subin);
      row_ind               = zeros(1, 4 * num_subin);
      col_ind               = zeros(1, 4 * num_subin);
% have to use a for loop
      for ind = 1 : num_subin
% find out how many elements we should skip
        skip_1              = 4 * (ind - 1);
        skip_2              = 2 * (ind - 1);
% fill in the details, for each sub interval [x_k, x_kp1]: 1 on the 
        entry(skip_1   + 1) = 1;
        row_ind(skip_1 + 1) = skip_2 + 1;
        col_ind(skip_1 + 1) = row_ind(skip_1 + 1);
% x_k on the 
        entry(skip_1   + 2) = knot_vec(ind);
        row_ind(skip_1 + 2) = row_ind(skip_1 + 1);
        col_ind(skip_1 + 2) = row_ind(skip_1 + 1) + 1;
% 1 on the 
        entry(skip_1   + 3) = 1;
        row_ind(skip_1 + 3) = row_ind(skip_1 + 1) + 1;
        col_ind(skip_1 + 3) = row_ind(skip_1 + 1);
% x_kp1 on the   
        entry(skip_1   + 4) = knot_vec(ind + 1);
        row_ind(skip_1 + 4) = row_ind(skip_1 + 1) + 1;
        col_ind(skip_1 + 4) = row_ind(skip_1 + 1) + 1;    
      end
 % constructe the sparse matrix
      mat1                  = sparse(row_ind, col_ind, entry, num_basis, num_basis);
% calculate the sup-diagonal
      sup_diag              = ones(1, num_subin);
      row_ind               = 1 : num_subin;
      col_ind               = 2 * row_ind;
% constructe the sparse matrix
      mat2                  = sparse(row_ind, col_ind, sup_diag, num_subin, num_basis);     
    case 'Legendre'
% find out the step sizes
      steps                 = knot_vec(2 : num_knots) - knot_vec(1 : num_subin);         
% prepare the entries and their corresponding indices for the sparse matrix
      entry                 = zeros(1, 4 * num_subin);
      row_ind               = zeros(1, 4 * num_subin);
      col_ind               = zeros(1, 4 * num_subin);
% have to use a for loop
      for ind = 1 : num_subin
% find out the step size
        h_k                 = steps(ind);
% calculate the square root of it
        sqrt_h_k            = sqrt(h_k);
% find out how many elements we should skip
        skip_1              = 4 * (ind - 1);
        skip_2              = 2 * (ind - 1);
% fill in the details
        entry(skip_1   + 1) = 1/sqrt_h_k;
        row_ind(skip_1 + 1) = skip_2 + 1;
        col_ind(skip_1 + 1) = row_ind(skip_1 + 1);
        entry(skip_1   + 2) = -sqrt(3)/sqrt_h_k;
        row_ind(skip_1 + 2) = row_ind(skip_1 + 1);
        col_ind(skip_1 + 2) = row_ind(skip_1 + 1) + 1;
        entry(skip_1   + 3) = entry(skip_1 + 1);
        row_ind(skip_1 + 3) = row_ind(skip_1 + 1) + 1;
        col_ind(skip_1 + 3) = row_ind(skip_1 + 1); 
        entry(skip_1   + 4) = -entry(skip_1   + 2);
        row_ind(skip_1 + 4) = row_ind(skip_1 + 1) + 1;
        col_ind(skip_1 + 4) = row_ind(skip_1 + 1) + 1;    
      end
% constructe the sparse matrix
      mat1                  = sparse(row_ind, col_ind, entry, num_basis, num_basis);
% calculate the sup-diagonal
      sup_diag              = 2 * sqrt(3) ./ (steps.^(3/2));
      row_ind               = 1 : num_subin;
      col_ind               = 2 * row_ind - 1;
% constructe the sparse matrix
      mat2                  = sparse(row_ind, col_ind, sup_diag, num_subin, num_basis);
    otherwise
  end
else
  error('SOD_Learn:polynomial_mod_matrix:invalidInput', ...
  'Only 0th or 1st degree polynomials are supported!!');
end