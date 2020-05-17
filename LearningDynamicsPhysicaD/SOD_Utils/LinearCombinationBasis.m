function [phihat, lastIdx] = LinearCombinationBasis(basis, alpha)
% function [phihat, lastIdx] = LinearCombinationBasis(basis, alpha)

% (C) M. Maggioni, M. Zhong (JHU)

phihat = []; lastIdx = 0;
if ~isempty(basis)
  K                      = size(basis, 1);
  if size(basis, 2) ~= K, error(''); end
  phihat                 = cell(K);
  sum_prev_num_basis     = 0;
  for k1 = 1 : K                                                                                    % go through each Ck1 on Ck2 interactions
    for k2 = 1 : K
      one_basis          = basis{k1, k2};                                                           % basis for Ck1 on Ck2 interaction
      num_basis          = length(one_basis.f);                                                     % number of basis functions
      ind_1              = sum_prev_num_basis + 1;                                                  % the starting index to cut alpha_vec
      ind_2              = sum_prev_num_basis + num_basis;                                          % the ending index to cut alpha_vec
      one_alphas         = alpha(ind_1 : ind_2);                                                    % portion of the alpha_vec corresponding to this interaction
      switch one_basis.dim
        case 1
          phihat{k1, k2} = @(r)       eval_basis_functions_1D(r,       one_alphas, one_basis);      % the sum_{\ell = 1}^L \alpha_{\ell} \phi_{\ell} is the learned interaction
        case 2
          phihat{k1, k2} = @(r, s)    eval_basis_functions_2D(r, s,    one_alphas, one_basis);
        case 3
          phihat{k1, k2} = @(r, s, z) eval_basis_functions_3D(r, s, z, one_alphas, one_basis);
        otherwise
      end
      sum_prev_num_basis = sum_prev_num_basis + num_basis;                                          % update the sum of previous number of basis functions
    end
  end
  lastIdx                = sum_prev_num_basis;
end
end