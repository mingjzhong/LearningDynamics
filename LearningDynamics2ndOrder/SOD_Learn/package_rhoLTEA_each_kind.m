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
    r_ctrs           = (rhoLT.histedges{1}(2 : end) + rhoLT.histedges{1}(1 : end - 1))/2;
    s_ctrs           = (rhoLT.histedges{2}(2 : end) + rhoLT.histedges{2}(1 : end - 1))/2;
    [R, S]           = ndgrid(r_ctrs, s_ctrs);
    densRhoLT2D      = griddedInterpolant(R, S, rhoLT.hist, 'linear', 'linear');      
    rhoLT.dense      = @(x, y) evaluate_rhoLT2D(x, y, rhoLT, densRhoLT2D);
  case 3
    r_ctrs           = (rhoLT.histedges{1}(2 : end) + rhoLT.histedges{1}(1 : end - 1))/2;
    s_ctrs           = (rhoLT.histedges{2}(2 : end) + rhoLT.histedges{2}(1 : end - 1))/2;
    z_ctrs           = (rhoLT.histedges{3}(2 : end) + rhoLT.histedges{3}(1 : end - 1))/2;
    [R, S, Z]        = ndgrid(r_ctrs, s_ctrs, z_ctrs);                                              % different from meshgrid even in 2D
    densRhoLT3D      = griddedInterpolant(R, S, Z, rhoLT.hist, 'linear', 'linear');      
    rhoLT.dense      = @(x, y, z) evaluate_rhoLT3D(x, y, z, rhoLT, densRhoLT3D);
  otherwise
    error('SOD_Learn:package_rhoLTEA_each_kind:exception', 'Only 2D-3D rhoLTEAs are supported!!');
end
end                 