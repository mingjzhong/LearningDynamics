function [energy_alphas, align_alphas, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_CVX(Phi, rhs_vec, T, M, sys_info, learning_info)
% [energy_alphas, align_alphas, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_CVX(Phi, rhs_vec, ...
% phiEknots, align_knots, T, M, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% find out the number of classes
num_classes                         = sys_info.K; 
% find out the information on CVX
CVX_info                            = learning_info.solver_info.CVX_info;
% the precision level on how CVX is obtaining its solution
precision                           = CVX_info.precision;  
% check to see if we have energy terms and/or alignment terms
has_energy                          = ~isempty(energy_Phi);
has_align                           = ~isempty(align_Phi);
% assemble the Phi matrix
if has_energy && ~has_align
  the_Ms                            = CVX_info.energy_Ms;
  basis_info                        = {learning_info.Ebasis_info};
  knot_vecs                         = {learning_info.Ebasis_info.phiEknots};
  mod_mats                          = cell(num_classes);
  where_to_break                    = zeros(num_classes);
  num_basis                         = zeros(num_classes);
  total_num_basis                   = 0;
elseif ~has_energy && has_align
  the_Ms                            = CVX_info.align_Ms;
  basis_info                        = {learning_info.align_basis_info};
  knot_vecs                         = {learning_info.align_basis_info.align_knots};
  mod_mats                          = cell(num_classes);
  where_to_break                    = zeros(num_classes);
  num_basis                         = zeros(num_classes);
  total_num_basis                   = 0;
elseif has_energy && has_align 
  the_Ms                            = zeros(num_classes, num_clases, 2);
  the_Ms(:, :, 1)                   = CVX_info.energy_Ms;
  the_Ms(:, :, 2)                   = CVX_info.align_Ms;
  basis_info                        = {learning_info.Ebasis_info, learning_info.align_basis_info};
  knot_vecs                         = {learning_info.Ebasis_info.phiEknots, learning_info.align_basis_info.align_knots};
  mod_mats                          = cell(num_classes, num_classes, 2);
  where_to_break                    = zeros(num_classes, num_classes, 2);
  num_basis                         = zeros(num_classes, num_classes, 2);
  total_num_basis                   = zeros(1, 2);
else
  error('SOD_Learn:solve_for_interactions_on_x_and_v_by_CVX:invalidInput', ...
  'At least one of energy_Phi and align_Phi has to be non-empty!!');
end
% fill up the quantities
for ind = 1 : length(basis_info)
  one_basis                         = basis_info{ind};
  knots                             = knot_vecs{ind};
  degree                            = one_basis.degree;
  type                              = one_basis.type;
  for k_1 = 1 : num_classes
    for k_2 = 1 : num_classes
% find out the degree for C_s1 to C_s2 interaction
      p                             = degree(k_1, k_2);
% find out the particular knot vector for C_s1 to C_s2
      one_knot                      = knots{k_1, k_2};
% check the type
      if strcmp(type, 'Legendre') || strcmp(type, 'standard')
        if p == 0
          mod_mats{k_1, k_2, ind}   = polynomial_mod_matrix(one_knot, p, type);
        elseif p == 1
          [mod_1, mod_2]            = polynomial_mod_matrix(one_knot, p, type);
          mod_mats{k_1, k_2, ind}   = {mod_1, mod_2};
        else
        error('SOD_Learn:solve_for_interactions_on_x_and_v_by_CVX:invalidInput', ...
        'Only piecewise polynomials of degrees 0 or 1 are supported!!');          
        end
      else
        error('SOD_Learn:solve_for_interactions_on_x_and_v_by_CVX:invalidInput', ...
        'Only Legrendre and standard polynomial basis are supported!!');
      end
% the number of basis functions (for piecewise polynomial is always
      n                             = (p + 1) * (length(one_knot) - 1);
% save it
      num_basis(k_1, k_2, ind)      = n;
% before we add it to total_energy_num, save it in where_to_break the alphas
      where_to_break(k_1, k_2, ind) = total_num_basis(ind);
% add it to the total number of energy basis
      total_num_basis(ind)          = total_num_basis(ind) + n;
    end
  end
end
% check the total_energy_num and total_align_num
if sum(total_num_basis) ~= size(Phi, 2)
  error('SOD_Learn:solve_for_interactions_on_x_and_v_by_CVX:invalidInput', ...
  'total_num_basis does not match up with size(Phi, 2)!!');
end
% find the length of alpha
alpha_vec_length                    = sum(total_num_basis);
% invoke the CVX package and also silence any output
cvx_begin quiet
% use the user given precision 
  cvx_precision(precision);
% declare the coefficient vecotr alphas in CVX
  variable alpha_vec(alpha_vec_length, 1);
% solve the Linear Algebra problem: Phi * alpha_vec = rhs_vec, since Phi might be singular, so solve it in the l_2 norm 
  minimize( norm(Phi * alpha_vec - rhs_vec) );
% subject to the constraint: ||\psi||_{L\infty} + ||\psi'||_{L_\infty} \le M, where \psi is the linear combination of basis
% functions, changed to the coefficients (only for p <= 1, will we have a linear relationship on the constants, for p >=2, it
% will be non-linear constraints, which violates the convex programming principle of CVX)
  subject to
    for ind = 1 : length(basis_info)
      if ind > 1
        prev_sum                    = total_num_basis(ind);
      else
        prev_sum                    = 0;
      end
      one_basis                     = basis_info{ind};
      degree                        = one_basis.degree;
      for k_1 = 1 : num_classes
        for k_2 = 1 : num_classes
          ind_1                     = where_to_break(k_1, k_2) + 1 + prev_sum;
          ind_2                     = where_to_break(k_1, k_2) + num_basis(k_1, k_2, ind) + prev_sum;
          p                         = degree(k_1, k_2);
          if  p == 0
            norm(mod_mats{k_1, k_2, ind} * alpha_vec(ind_1 : ind_2), Inf) ...
                                    <= the_Ms(k_1, k_2, ind)
          elseif p == 1
            mods                    = mod_mats{k_1, k_2, ind};
            mod_1                   = mods{1};
            mod_2                   = mods{2};
            norm(mod_1 * alpha_vec(ind_1 : ind_2), Inf) + norm(mod_2 * alpha_vec(ind_1 : ind_2), Inf) ...
                                    <= the_Ms(k_1, k_2, ind)
          end
        end
      end
    end      
% stop using CVX
cvx_end
% the Empirical Error Functional (almost, missing <d_vec, d_vec> over all M's)
opt_val                             = (transpose(Phi * alpha_vec) * alpha_vec - 2 * transpose(alpha_vec) * rhs_vec)/(T * M);
% break down the alpha_vec
if has_energy && ~has_align
  energy_alphas                     = alpha_vec;
  align_alphas                      = [];
elseif ~has_energy && has_align
  energy_alphas                     = [];
  align_alphas                      = alpha_vec;
elseif has_energy && has_align
  total_energy_num_basis            = total_num_basis(1);
  energy_alphas                     = alpha_vec(1 : total_energy_num_basis);
  align_alphas                      = alpha_vec((total_energy_num_basis + 1) : alpha_vec_length);
end
% print out the status of cvx
fprintf('The CVS status is: %s.\n', cvx_status);  
end