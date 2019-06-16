function L2rhoTnorm = L2_rho_T_energy( f, sys_info, obs_info, basis )
% function L2rhoTnorm = L2_rho_T_energy( f, sys_info, obs_info, basis_info )
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

% (c) M. Zhong, M. Maggioni (JHU)

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

L2rhoTnorm                 = zeros(sys_info.K);
rhoLTE                     = obs_info.rhoLT.rhoLTE;
for k1 = 1:sys_info.K
  N_k1                     = nnz(sys_info.type_info == k1);
  for k2 = 1:sys_info.K
    if k1 == k2 && N_k1 == 1
      L2rhoTnorm(k1, k2)   = 0;
    else
      range                = [basis{k1,k2}.knots(1), basis{k1,k2}.knots(end)];                      % use the knot vectors as the range
      range                = intersectInterval(rhoLTE.supp{k1, k2}, range);                         % the actual support of \rho^L_T(E)
      edges                = rhoLTE.histedges{k1, k2};                                              % the bins for Estimated \rho^L_T(E)
      e_idxs               = find(range(1) <= edges & edges < range(2));
      centers              = (edges(e_idxs(1 : end - 1)) + edges(e_idxs(2 : end)))/2;
      weights              = centers;
      histdata             = rhoLTE.hist{k1,k2}(e_idxs(1 : end - 1))';
      f_vec                = f{k1, k2}( centers );
      f_integrand          = ((f_vec .* weights).^2) .* histdata;
      L2rhoTnorm(k1, k2)   = sqrt(sum(f_integrand));
    end
  end
end
end