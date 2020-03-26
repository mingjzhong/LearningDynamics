function basis = uniform_basis_on_xi(Rs, sys_info, learn_info)
% function basis = uniform_basis_on_xi(Rs, sys_info, learn_info)

% (c) M. Zhong (JHU)

basis = uniform_basis_by_class(Rs, sys_info.K, learn_info.Xibasis_info);
end