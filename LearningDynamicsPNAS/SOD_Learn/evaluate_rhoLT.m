function y = evaluate_rhoLT(hist, histedges, supp, r)
% function y = evaluate_rhoLT(hist, histedges, r)

% (c) M. Zhong (JHU)

edges             = histedges(1 : end - 1);
binwidth          = (edges(2) - edges(1))/length(edges);
edges_idxs        = find(hist > 0.01 * binwidth);
edges_idxs        = min(edges_idxs) : max(edges_idxs);
[histdata, edges] = downsampleHistCounts(hist(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2);
centers           = (edges(1 : end - 1) + edges(2 : end))/2;
densRhoLT         = griddedInterpolant(centers, histdata, 'linear', 'linear');
ind               = supp(1) <= r & r <= supp(2);
y                 = zeros(size(r));
y(ind)            = densRhoLT(r(ind));
end