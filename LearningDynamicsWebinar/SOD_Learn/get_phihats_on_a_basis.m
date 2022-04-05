function [phiEhat, phiAhat, phiXihat] = get_phihats_on_a_basis(x, v, xi, dot_xv, dot_xi, basis, ...
                                        learn_info, sys_info)
% function [phiEhat, phiAhat, phiXihat] = get_phihats_on_a_basis(x, v, xi, dot_xv, dot_xi, basis, ...
%                                         learn_info, sys_info)

% (C) M. Zhong

[ALM, bLM, ALMXi, bLMXi] = assemble_Anb_on_each_core(x, v, xi, dot_xv, dot_xi, basis, [], ...
                           learn_info, sys_info, true, false);
Estimator                = [];
Estimator                = set_the_average_of_Anb(Estimator, ALM, bLM, ALMXi, bLMXi, M, L);
Estimator                = set_basis_in_Estimator(basis, sys_info, Estimator);
[alpha, alpha_xi]        = solve_the_learning_problem(Estimator, learn_info);
[phiEhat, E_idx]         = LinearCombinationBasis(Estimator.Ebasis,  alpha);
phiAhat                  = LinearCombinationBasis(Estimator.Abasis,  alpha(E_idx + 1: end));
phiXihat                 = LinearCombinationBasis(Estimator.Xibasis, alpha_xi);
end