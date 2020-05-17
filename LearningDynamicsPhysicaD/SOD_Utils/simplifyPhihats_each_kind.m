function [phi_reg, basis_reg] = simplifyPhihats_each_kind(phi, basis)
% function [phi_reg, basis_reg] = simplifyPhihats_each_kind(phi, basis)

% (C) M. Maggioni, M. Zhong (JHU)

phi_reg   = cell(size(phi));
basis_reg = basis;
for k1 = 1 : size(phi, 1)
  for k2 = 1 : size(phi, 2)
    if norm(basis_reg{k1, k2}.supp(:, 2) - basis_reg{k1, k2}.supp(:, 1), Inf) > 0        
      phi_reg{k1, k2} = simplifyfcn(phi{k1, k2}, basis_reg{k1, k2}.knots, basis_reg{k1, k2}.degree);
    else 
      phi_reg{k1, k2} = phi{k1, k2};
    end
  end
end
end