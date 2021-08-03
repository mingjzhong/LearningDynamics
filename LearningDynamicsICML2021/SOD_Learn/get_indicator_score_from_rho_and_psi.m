function indicator = get_indicator_score_from_rho_and_psi(alphas_j, basis_j, alphas_jp1, ...
                     basis_jp1, rhoLTM, knots, learn_info)
% function indicator = get_indicator_score_from_rho_and_psi(alphas_j, basis_j, alphas_jp1, ...
%                      basis_jp1, rhoLTM, knots, learn_info)  

% (C) M. Zhong

num_subs          = get_num_subs_from_knots(knots);
indicator         = zeros(1, num_subs);
switch basis_j.dim
  case 1
    switch learn_info.adaptive_err_type
      case 'f'
        phi_j     = @(r) eval_basis_functions_1D(r, alphas_j, basis_j);
        phi_diff  = @(r) eval_basis_functions_1D(r, alphas_jp1, basis_jp1) - phi_j(r);         
      case 'df'
        basis_j.f = basis_j.df;
        basis_j.f = basis_j.df;
        phi_j     = @(r) eval_basis_functions_1D(r, alphas_j, basis_j);
        phi_diff  = @(r) eval_basis_functions_1D(r, alphas_jp1, basis_jp1) - phi_j(r);          
      otherwise
        error('');
    end
  case 2
    switch learn_info.adaptive_err_type
      case 'f'
        phi_j     = @(r, s) eval_basis_functions_2D(r, s, alphas_j, basis_j);
        phi_diff  = @(r, s) eval_basis_functions_2D(r, s, alphas_jp1, basis_jp1) - phi_j(r);                  
      otherwise
        error('');
    end  
  case 3
    switch learn_info.adaptive_err_type
      case 'f'
        phi_j     = @(r, s, z) eval_basis_functions_3D(r, s, z, alphas_j, basis_j);
        phi_diff  = @(r, s, z) eval_basis_functions_3D(r, s, z, alphas_jp1, basis_jp1) - phi_j(r);                 
      otherwise
        error('');
    end 
  otherwise
    error('');
end
for idx = 1 : num_subs
  subInts         = get_sub_intervals_from_knots(idx, knots);
  subProbs        = get_probability_from_rhoLT(rhoLTM, subInts);
  L2errs          = get_L2err_from_supp(phi_diff, phi_j, rhoLTM, subInts);
  to_refine       = get_refinement_indicator(subProbs, learn_info.sample_tol, L2errs, ...
                    learn_info.adaptive_err_tol);
  if to_refine, indicator(idx)  = 1; end
end
end