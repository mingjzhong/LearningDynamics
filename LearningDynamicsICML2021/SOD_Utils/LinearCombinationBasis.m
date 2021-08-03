function phihat = LinearCombinationBasis(basis, alpha, sys_info)
% function phihat = LinearCombinationBasis(basis, alpha, sys_info)

% (C) M. Maggioni, M. Zhong (JHU)

phihat                     = []; 
agent_info                 = getAgentInfo(sys_info);
if ~isempty(basis)
  K                        = size(basis, 1);
  if size(basis, 2) ~= K, error(''); end
  phihat                   = cell(K);
  sum_prev_num_basis       = 0;
  for k1 = 1 : K                                                                                    % go through each Ck1 on Ck2 interactions
    for k2 = 1 : K
      basisCk1Ck2          = basis{k1, k2};                                                         % basis for Ck1 on Ck2 interaction
      num_basis            = length(basisCk1Ck2.f);                                                 % number of basis functions
      ind_1                = sum_prev_num_basis + 1;                                                % the starting index to cut alpha_vec
      ind_2                = sum_prev_num_basis + num_basis;                                        % the ending index to cut alpha_vec
      alphaCk1Ck2          = alpha(ind_1 : ind_2);                                                  % portion of the alpha_vec corresponding to this interaction
      switch basisCk1Ck2.dim
        case 1
          if k1 == k2 && agent_info.num_agents(k1) == 1
            phihat{k1, k2} = @(r) zeros(size(r));
          else
            phihat{k1, k2} = @(r) eval_basis_functions_1D(r, alphaCk1Ck2, basisCk1Ck2);             % the sum_{\ell = 1}^L \alpha_{\ell} \phi_{\ell} is the learned interaction
          end
        case 2
          if k1 == k2 && agent_info.num_agents(k1) == 1
            phihat{k1, k2} = @(r, s) zeros(size(r));
          else           
            phihat{k1, k2} = @(r, s) eval_basis_functions_2D(r, s, alphaCk1Ck2, basisCk1Ck2);
          end
        case 3
          if k1 == k2 && agent_info.num_agents(k1) == 1
            phihat{k1, k2} = @(r, s, z) zeros(size(r));
          else           
            phihat{k1, k2} = @(r, s, z) eval_basis_functions_3D(r, s, z, alphaCk1Ck2, basisCk1Ck2);
          end
        otherwise
      end
      sum_prev_num_basis   = sum_prev_num_basis + num_basis;                                        % update the sum of previous number of basis functions
    end
  end
end
end