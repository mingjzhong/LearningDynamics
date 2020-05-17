function [phi_dim, rho_dim] = get_phi_and_rho_dim_each_kind(kind, sys_info, learn_info, is_rhoLT)
% function [phi_dim, rho_dim] = get_phi_and_rho_dim_each_kind(kind, sys_info, learn_info, is_rhoLT)

% (C) M. Zhong

% do it be kind of phi/rho data
phi_dim = []; rho_dim = [];
switch kind
  case 'energy'
    if is_rhoLT
      if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
        if isfield(sys_info, 'phiE_dim') && ~isempty(sys_info.phiE_dim)
          phi_dim        = sys_info.phiE_dim;
        else
          phi_dim        = ones(sys_info.K);
        end
      end
    else
      if isfield(learn_info, 'Ebasis_info') && ~isempty(learn_info.Ebasis_info)
        phi_dim          = get_dim_from_basis_info(learn_info.Ebasis_info);
      end  
    end
    if ~isempty(phi_dim), rho_dim = phi_dim; end
  case 'alignment'
    if is_rhoLT
      if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
        if isfield(sys_info, 'phiA_dim') && ~isempty(sys_info.phiA_dim)
          phi_dim        = sys_info.phiA_dim;
        else
          phi_dim        = ones(sys_info.K);
        end
      end
    else
      if isfield(learn_info, 'Abasis_info') && ~isempty(learn_info.Abasis_info)
        phi_dim          = get_dim_from_basis_info(learn_info.Abasis_info);
      end    
    end
    if ~isempty(phi_dim), rho_dim = phi_dim + 1; end
  case 'xi'
     if is_rhoLT
      if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
        if isfield(sys_info, 'phiXi_dim') && ~isempty(sys_info.phiXi_dim)
          phi_dim        = sys_info.phiXi_dim; 
        else
          phi_dim        = ones(sys_info.K);
        end
        if isfield(sys_info, 'phiXi_weight') && ~isempty(sys_info.phiXi_weight) && ~sys_info.phiXi_weight
          rho_dim        = phi_dim;
        else
          rho_dim        = phi_dim + 1;
        end        
      end
    else
      if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
        phi_dim          = get_dim_from_basis_info(learn_info.Xibasis_info);
        if isfield(sys_info, 'phiXi_weight') && ~isempty(sys_info.phiXi_weight) && ~sys_info.phiXi_weight
          rho_dim        = phi_dim;
        else
          rho_dim        = phi_dim + 1;
        end          
      end
    end
  otherwise
    error('SOD_Learn:get_phi_and_rho_dim_each_kind:exception', ...
      'Energy, alignment and xi are the only supported kinds!!');  
end
end