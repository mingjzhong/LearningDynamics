function basis_plan = get_basis_construction_plan(phi_range, rhoLTM, learn_info)
% function basis_plan = get_basis_construction_plan(phi_range, rhoLTM, learn_info)

% (C) M. Zhong

if isempty(rhoLTM) 
% use uniform grid for knots and Tensor-Grid for 2D/3D      
  basis_plan     = get_basis_construction_plan_uniform(phi_range, learn_info);
else
% adaptively refine the knots from rhoLTM   
  switch learn_info.basis_method
    case 'adaptive'
      basis_plan = get_basis_construction_plan_adaptive(phi_range, rhoLTM, learn_info);  
    case 'orthogonal'
      basis_plan = get_basis_construction_plan_orthogonal(phi_range, rhoLTM, learn_info);
    otherwise
      error('');
  end
end
end