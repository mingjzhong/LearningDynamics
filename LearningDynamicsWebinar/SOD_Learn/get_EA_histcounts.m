function EA_counts = get_EA_histcounts(E_pdist, E_edges, A_pdist, A_edges)
% function EA_counts = get_EA_histcounts(E_pdist, E_edges, A_pdist, A_edges)

% (C) M. Zhong

if ~isempty(E_pdist) && ~isempty(A_pdist)
  EA_pdist = [E_pdist, A_pdist(2 : end)];
  EA_edges = [E_edges, A_edges(2 : end)];
elseif ~isempty(E_pdist) && isempty(A_pdist)
  EA_pdist = E_pdist;
  EA_edges = E_edges;  
elseif isempty(E_pdist) && ~isempty(A_pdist)
  EA_pdist = A_pdist;
  EA_edges = A_edges;  
else
  error('');
end
EA_counts  = get_histcounts_nd(EA_pdist, EA_edges);
end