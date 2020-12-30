function L2rhoTnorm = L2_rho_T_xi( f, sys_info, obs_info, basis )
% function L2rhoTnorm = L2_rho_T_xi( f, sys_info, obs_info, basis_info )
% Computes L^2(obs_info.rhoLT) norm of the function(s) f.
% f should be a cell array of function pointers of size (sys_info.K x, sys_info.K); if not
% it is copied into such a cell array
% IN:
%   f          - 
%   sys_info   -
%   obs_info   -
%   basis      -
% OUT:
%   L2rhoTnorm -

% (c) M. Zhong (JHU)

if ~iscell(f)
  g                      = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      g{k1, k2}          = f;
    end
  end
  f                      = g;
  clear g;
end

L2rhoTnorm               = zeros(sys_info.K);
rhoLTXi                  = obs_info.rhoLT.rhoLTXi;
for k1 = 1:sys_info.K
  N_k1                   = nnz(sys_info.type_info == k1);
  for k2 = 1:sys_info.K
    if k1 == k2 && N_k1 == 1
      L2rhoTnorm(k1, k2) = 0;
    else
%       N_k2                 = nnz(sys_info.type_info == k2);
      range                = [basis{k1,k2}.knots(1), basis{k1,k2}.knots(end)];                      % use the knot vectors as the range
      range                = intersectInterval(rhoLTXi.supp{k1, k2}(1, :), range);                   % the actual support of \rho^L_T(A)
      edges_R              = rhoLTXi.histedges{k1, k2}(1, :);                                        % the bins for Estimated \rho^L_T(A)
      ctr_idxs             = find(range(1) <= edges_R & edges_R < range(2));
      centers              = (edges_R(ctr_idxs(1 : end - 1)) + edges_R(ctr_idxs(2 : end )))/2;
      range                = rhoLTXi.supp{k1, k2}(2, :);
      edges_Xi             = rhoLTXi.histedges{k1, k2}(2, :);
      wgt_idxs             = find(range(1) <= edges_Xi & edges_Xi < range(2));
      weights              = (edges_Xi(wgt_idxs(1 : end - 1)) + edges_Xi(wgt_idxs(2 : end)))/2;
      histdata             = rhoLTXi.hist{k1,k2}(ctr_idxs(1 : end - 1), wgt_idxs(1 : end - 1));
      f_vec                = f{k1, k2}( centers );
      f_integrand          = ((f_vec' * weights).^2) .* histdata;
      L2rhoTnorm(k1, k2)   = sqrt(sum(sum(f_integrand)));
%       if k1 == k2
%         L2rhoTnorm(k1, k2) = sqrt(sum(sum(f_integrand)))/(nchoosek(N_k1,2));                        % MZ: do we need to rescale it again? it is already a probability distribution?
%       else
%         L2rhoTnorm(k1, k2) = sqrt(sum(sum(f_integrand)))/(N_k1 * N_k2);
%       end
    end
  end
end
end