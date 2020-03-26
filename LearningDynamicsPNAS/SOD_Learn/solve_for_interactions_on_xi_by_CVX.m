function [xi_alphas, opt_val] = solve_for_interactions_on_xi_by_CVX(Phi, rhs_vec, knot_vecs, T, M, learning_info)
% [xi_alphas, opt_val] = solve_for_interactions_on_xi_by_CVX(Phi, rhs_vec, knot_vecs, T, M, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% find out the number of classes
num_classes                  = learning_info.K; 
% find out the information on CVX
CVX_info                     = learning_info.solver_info.CVX_info;
% the precision level on how CVX is obtaining its solution
precision                    = CVX_info.xi_precision;
% the size of the space constraint
the_Ms                       = CVX_info.xi_Ms;
% information on the basis for interaction on xi
basis_info                   = learning_info.xi_basis_info;
% modification matrix for chaning the function in L_\finty norm to coeffcients
mod_mats                     = cell(num_classes);
% where to break up the alpha vector (of all Ck1 - Ck2 interactions)
where_to_break               = zeros(num_classes);
% the number of basis functions for each Ck1 - Ck2 interaction
num_basis                    = zeros(num_classes);
% the total number of basis functions
total_num_basis              = 0;
% degree of the polynomial for each class
degree                       = basis_info.degree;
% type of the polynomial
type                         = basis_info.type;
% go through each Ck1 - Ck2 interaction
for k_1 = 1 : num_classes
  for k_2 = 1 : num_classes
% find out the degree for C_s1 to C_s2 interaction
    p                        = degree(k_1, k_2);
% find out the particular knot vector for C_s1 to C_s2
    one_knot                 = knot_vecs{k_1, k_2};
% check the type
    if strcmp(type, 'Legendre') || strcmp(type, 'standard')
      if p == 0
        mod_mats{k_1, k_2}   = polynomial_mod_matrix(one_knot, p, type);
      elseif p == 1
        [mod_1, mod_2]       = polynomial_mod_matrix(one_knot, p, type);
        mod_mats{k_1, k_2}   = {mod_1, mod_2};
      else
      error('SOD_Learn:solve_for_interactions_on_xi_by_CVX:invalidInput', ...
      'Only piecewise polynomials of degrees 0 or 1 are supported!!');          
      end
    else
      error('SOD_Learn:solve_for_interactions_on_xi_by_CVX:invalidInput', ...
      'Only Legrendre and standard polynomial basis are supported!!');
    end
% the number of basis functions (for piecewise polynomial is always
    n                        = (p + 1) * (length(one_knot) - 1);
% save it
    num_basis(k_1, k_2)      = n;
% before we add it to total_energy_num, save it in where_to_break the alphas
    where_to_break(k_1, k_2) = total_num_basis;
% add it to the total number of energy basis
    total_num_basis          = total_num_basis + n;
  end
end
% check the total_energy_num and total_align_num
if total_num_basis ~= size(Phi, 2)
  error('SOD_Learn:solve_for_interactions_on_x_and_v_by_CVX:invalidInput', ...
  'total_num_basis does not match up with size(Phi, 2)!!');
end
% invoke the CVX package and also silence any output
cvx_begin quiet
% use the user given precision 
  cvx_precision(precision);
% declare the coefficient vecotr alphas in CVX
  variable alpha_vec(total_num_basis, 1);
% solve the linear algebra problem: Phi * alpha_vec = rhs_vec, since Phi might be singular, we solve it in the Least Sqaure   
  minimize( norm(Phi * alpha_vec - rhs_vec) );
% subject to the constraint: ||\psi||_{L\infty} + ||\psi'||_{L_\infty} \le M, where \psi is the linear combination of basis
% functions, changed to the coefficients (only for p <= 1, will we have a linear relationship on the constants, for p >=2, it
% will be non-linear constraints, which violates the convex programming principle of CVX)
  subject to
    degree                   = basis_info.degree;
    for k_1 = 1 : num_classes
      for k_2 = 1 : num_classes
        ind_1                = where_to_break(k_1, k_2) + 1;
        ind_2                = where_to_break(k_1, k_2) + num_basis(k_1, k_2);
        p                    = degree(k_1, k_2);
        if  p == 0
          norm(mod_mats{k_1, k_2} * alpha_vec(ind_1 : ind_2), Inf) ...
                             <= the_Ms(k_1, k_2)
        elseif p == 1
          mods               = mod_mats{k_1, k_2};
          mod_1              = mods{1};
          mod_2              = mods{2};
          norm(mod_1 * alpha_vec(ind_1 : ind_2), Inf) + norm(mod_2 * alpha_vec(ind_1 : ind_2), Inf) ...
                             <= the_Ms(k_1, k_2)
        end
      end
    end
% stop using CVX
cvx_end
% the optimal value: <Phi * alpha_vec, alpha_vec> - 2 * <alpha, rhs_vec>
opt_val                      = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/(T * M);
xi_alphas                    = alpha_vec;
% print out the status of cvx
fprintf('The CVS status is: %s.\n', cvx_status);  
end