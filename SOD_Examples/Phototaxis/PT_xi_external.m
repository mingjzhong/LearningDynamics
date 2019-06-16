function external = PT_xi_external(x, xi, I_0, psi, xi_cp, neighbor_func)
% external = PT_xi_external(x, xi, I_0, psi, xi_cp, neighbor_func)

% Ming Zhong
% Postdoc Research at JHU

% find out the cutoffs based on the capacity
psi_of_xi = transpose(psi(xi, xi_cp));
% find the close neighbors around each agent
neighbors = neighbor_func(x);
% check the neighbors
if ~isempty(neighbors)
% if there are neighbors, use it to enhance the effect of light
  external = I_0 * neighbors .* psi_of_xi;
else
% if not, just global change to every agent
  external = I_0 * psi_of_xi;
end
end