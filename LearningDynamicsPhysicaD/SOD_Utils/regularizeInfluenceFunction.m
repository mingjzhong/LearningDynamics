function [phiReg1, phiReg2, opt_val]  = regularizeInfluenceFunction(A, b, basis1, rho1, basis2, rho2, learn_info)
% function [phiReg1, phiReg2, opt_val]  = regularizeInfluenceFunction(A, b, basis1, basis2, learn_info)

% (C) M. Zhong

regMat1            = get_regularization_matrix(basis1, rho1, learn_info);
regMat2            = get_regularization_matrix(basis2, rho2, learn_info);
regMat             = build_regularization_matrix(regMat1, regMat2);
[alpha, opt_val]   = solve_for_alphas(A, b, learn_info, regMat);
[phiReg1, lastIdx] = LinearCombinationBasis(basis1, alpha);
phiReg2            = LinearCombinationBasis(basis2, alpha(lastIdx + 1 : end));
end