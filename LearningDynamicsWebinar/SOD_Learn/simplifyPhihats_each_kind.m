function [phi_reg, basis_reg] = simplifyPhihats_each_kind(phi, basis, basis_plan)
% function [phi_reg, basis_reg] = simplifyPhihats_each_kind(phi, basis, basis_plan)

% (C) M. Maggioni, M. Zhong (JHU)

phi_reg   = cell(size(phi));
basis_reg = basis;
for k1 = 1 : size(phi, 1)
  for k2 = 1 : size(phi, 2)
    if norm(basis{k1, k2}.supp(:, 2) - basis{k1, k2}.supp(:, 1), Inf) > 0
      phi_reg{k1, k2}   = simplifyfcn(phi{k1, k2}, basis{k1, k2}.knots, basis{k1, k2}.degree, ...
                          basis_plan{k1, k2});   
    else
      phi_reg{k1, k2} = phi{k1, k2};
    end
  end
end
end
% global basis is not that useful    
%     if strcmp(basis{k1, k2}.supp_type, 'local') && ...
%          norm(basis{k1, k2}.supp(:, 2) - basis{k1, k2}.supp(:, 1), Inf) > 0        
%       phi_reg{k1, k2}   = simplifyfcn(phi{k1, k2}, basis{k1, k2}.knots, basis{k1, k2}.degree, ...
%                           basis_plan{k1, k2});
%     else 
%       if strcmp(basis{k1, k2}.supp_type, 'global') && length(basis{k1, k2}.degree) == 1
%         SI              = 100;
%         if (basis{k1, k2}.knots(2) - basis{k1, k2}.knots(1))/SI < 0.05
%           SI            = ceil((basis{k1, k2}.knots(2) - basis{k1, k2}.knots(1))/0.05);
%         end
%         phi_reg{k1, k2} = simplifyfcn(phi{k1, k2}, ...
%           linspace(basis{k1, k2}.knots(1), basis{k1, k2}.knots(2), SI + 1), 3, []);
%       else
%         phi_reg{k1, k2} = phi{k1, k2};
%       end
%     end