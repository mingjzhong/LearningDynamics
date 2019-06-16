function [f_ptr,lastIdx] = LinearCombinationBasis( basis, alpha )

if isempty(basis), f_ptr = []; lastIdx=0; return; end

num_classes     = size(basis,1);

f_ptr           = cell(num_classes,num_classes);

sum_prev_num_basis = 0;
for k_1 = 1 : num_classes                                                                       % go through each class-to-class interaction
    for k_2 = 1 : num_classes
        one_basis           = basis{k_1, k_2};                                                  % basis for C_{s_1} to C_{s_2} interaction
        num_basis           = length(one_basis.f);                                                % number of basis functions
        ind_1               = sum_prev_num_basis + 1;                                           % the starting index to cut alpha_vec
        ind_2               = sum_prev_num_basis + num_basis;                                   % the ending index to cut alpha_vec
        one_alphas          = alpha(ind_1 : ind_2);                                             % portion of the alpha_vec corresponding to this interaction
        f_ptr{k_1, k_2}   = @(r) eval_basis_functions(r, one_alphas, one_basis);              % the sum_{\ell = 1}^L \alpha_{\ell} \phi_{\ell} is the learned interaction
        sum_prev_num_basis  = sum_prev_num_basis + num_basis;                                   % update the sum of previous number of basis functions
    end
end

lastIdx = sum_prev_num_basis;

return