function rhoLT = package_rhoLTEA_each_kind(E_edges, A_edges, E_binwidths, A_binwidths, EA_counts)
% function rhoLT = package_rhoLTEA_each_kind(E_edges, A_edges, E_binwidths, A_binwidths, EA_counts)                 
                 
% (C) M. Zhong                 
                 
rhoLT.name           = 'energy_and_alignment';
rhoLT.histcounts     = EA_counts{1};
if ~isempty(E_edges) && ~isempty(A_edges)
  rhoLT.histedges    = [E_edges, A_edges(2 : end)];
  rhoLT.binwidths    = [E_binwidths, A_binwidths(2 : end)];
elseif ~isempty(E_edges) && isempty(A_edges)
  rhoLT.histedges    = E_edges;
  rhoLT.binwidths    = E_binwidths;  
elseif isempty(E_edges) && ~isempty(A_edges)
  rhoLT.histedges    = A_edges;
  rhoLT.binwidths    = A_binwidths;  
else
  error('');
end
total_histcounts     = sum(rhoLT.histcounts(:));
if total_histcounts == 0
  rhoLT.hist         = zeros(size(rhoLT.histcounts));
else
  rhoLT.hist         = rhoLT.histcounts/(total_histcounts * get_hist_binwidth_prod(rhoLT.binwidths));
end
rhoLT.has_weight     = true;
rhoLT.dim            = length(rhoLT.histedges);
rhoLT.supp           = zeros(rhoLT.dim, 2);
for ind = 1 : rhoLT.dim
  rhoLT.supp(ind, :) = [rhoLT.histedges{ind}(1), rhoLT.histedges{ind}(end)];
end
switch rhoLT.dim
  case 2
    rhoLT.dense      = @(x, y) evaluate_rhoLT2D(x, y, rhoLT);
  case 3
    rhoLT.dense      = @(x, y, z) evaluate_rhoLT3D(x, y, z, rhoLT);
  otherwise
    error('SOD_Learn:package_rhoLTEA_each_kind:exception', 'Only 2D-3D rhoLTEAs are supported!!');
end
end                 