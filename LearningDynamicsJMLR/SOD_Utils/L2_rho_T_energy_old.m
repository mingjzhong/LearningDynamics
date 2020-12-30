function L2rhoTnorm = L2_rho_T_energy( f, sys_info, obs_info, basis )
% function L2rhoTnorm = L2_rho_T_energy( f, sys_info, obs_info, basis_info )
%
% Computes L^2(obs_info.rhoLT) norm of the function(s) f.
% f should be a cell array of function pointers of size (sys_info.K x, sys_info.K); if not
% it is copied into such a cell array

% (c) M. Zhong, M. Maggioni (JHU)

if ~iscell(f)
  g                     = cell(sys_info.K);
  for k_1 = 1:sys_info.K
    for k_2 = 1:sys_info.K
      g{k_1,k_2}        = f;
    end
  end
  f                     = g;
  clear g;
end

L2rhoTnorm              = zeros(sys_info.K);

for k_1 = 1:sys_info.K
  for k_2 = 1:sys_info.K
    range               = [basis{k_1,k_2}.knots(1), basis{k_1,k_2}.knots(end)];                     % use the knot vectors as the range
    edges               = obs_info.rho_T_histedges;                                                 % the bins for Estimated \rho's
    edges_idxs          = find(edges<range(2));
    centers             = (edges(1:edges_idxs(end)-1) + edges(2:edges_idxs(end)))/2;
    histdata            = obs_info.rhoLT.hist{k_1,k_2}(edges_idxs(1:end-1))';

    f_vec               = f{k_1,k_2}( centers );
    f_integrand         = ((f_vec.*centers).^2).*histdata;

    L2rhoTnorm(k_1,k_2) = sqrt(sum(f_integrand))/(nchoosek(sys_info.N,2));                          % MM:TBD:Fix for multiple classes
  end
end
end