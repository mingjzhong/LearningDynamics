function [D, D_xi] = get_Nks_D_mat(L, sys_info)
% function Nks = get_Nks_D_mat(L, sys_info)

% (C) M. Zhong (JHU)

% find out the number of agents in each class for each row i = 1, \cdots, N, where i is the agent index
Nks        = zeros(sys_info.N, 1);
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi), Nks_xi = zeros(sys_info.N, 1); else, Nks_xi = []; end
% prepare the number of agents in each class vector
for k = 1 : sys_info.K
% use logical indexing  
  ind      = sys_info.type_info == k; 
  Nks(ind) = nnz(ind); 
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi), Nks_xi(ind) = Nks(ind); end
end  
% make it to have size [N * d, 1]
Nks        = kron(Nks, ones(sys_info.d, 1));
% repeat it to have size [L * N * d, 1];
Nks        = repmat(Nks,    [L, 1]);
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi), Nks_xi = repmat(Nks_xi, [L, 1]); end
% change it into a very large diagonal matrix, take sqrt due to 1/N_k * || \cdot ||^2 
D          = spdiags(Nks.^(-1/2), 0, L * sys_info.N * sys_info.d, L * sys_info.N * sys_info.d);
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  D_xi     = spdiags(Nks_xi.^(-1/2), 0, L * sys_info.N, L * sys_info.N); 
else
  D_xi     = []; 
end
end