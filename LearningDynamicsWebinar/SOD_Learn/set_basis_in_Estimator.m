function Estimator = set_basis_in_Estimator(basis, basis_plan, sys_info, Estimator)
% function Estimator = set_basis_in_Estimator(basis, basis_plan, sys_info, Estimator)

% (C) M. Zhong

[num_kinds, types]               = get_phi_or_rho_kinds(sys_info, 'phi');
Estimator.Ebasis                 = [];
Estimator.Ebasis_plan            = [];
Estimator.Abasis                 = [];
Estimator.Abasis_plan            = [];
Estimator.Xibasis                = [];
Estimator.Xibasis_plan           = [];
if sys_info.ode_order == 1
  Estimator.Ebasis               = basis{1};  
  Estimator.Ebasis_plan          = basis_plan{1};
  if num_kinds > 1
    Estimator.Xibasis            = basis{2};
    Estimator.Xibasis_plan       = basis_plan{2};
  end
elseif sys_info.ode_order == 2
  switch num_kinds
    case 1
      switch types{1}
        case 'energy'
          Estimator.Ebasis       = basis{1};  
          Estimator.Ebasis_plan  = basis_plan{1};
        case 'alignment'
          Estimator.Abasis       = basis{1};
          Estimator.Abasis_plan  = basis_plan{1};
        otherwise
          error('SOD_Learn:set_basis_in_Estimator:exception', ...
            'For second order, the first kind can only be energy/alignment!!');
      end
    case 2
      switch types{1}
        case 'energy'
          Estimator.Ebasis       = basis{1};
          Estimator.Ebasis_plan  = basis_plan{1};
        case 'alignment'
          Estimator.Abasis       = basis{1};
          Estimator.Abasis_plan  = basis_plan{1};
        otherwise
          error('SOD_Learn:set_basis_in_Estimator:exception', ...
            'For second order, the first kind can only be energy/alignment!!');          
      end
      switch types{2}
        case 'alignment'
          Estimator.Abasis       = basis{2};
          Estimator.Abasis_plan  = basis_plan{2};
        case 'xi'
          Estimator.Xibasis      = basis{2};
          Estimator.Xibasis_plan = basis_plan{2};
        otherwise
          error('SOD_Learn:set_basis_in_Estimator:exception', ...
            'For second order, the second kind can only be alignment/xi!!');            
      end
    case 3
      Estimator.Ebasis           = basis{1};
      Estimator.Ebasis_plan      = basis_plan{1};
      Estimator.Abasis           = basis{2};
      Estimator.Abasis_plan      = basis_plan{2};
      Estimator.Xibasis          = basis{3}; 
      Estimator.Xibasis_plan     = basis_plan{3};
    otherwise
      error('SOD_Learn:set_basis_in_Estimator:exception', ...
            'For second order, there are at most 3 phi kinds!!');       
  end
end
end