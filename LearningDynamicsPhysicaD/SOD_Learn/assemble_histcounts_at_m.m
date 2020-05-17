function [hist_counts, assemble_the_rhoLTM] = assemble_histcounts_at_m(hist_edges, file_name)
% function [hist_counts, assemble_the_rhoLTM] = assemble_histcounts_at_m(hist_edges, file_name)

% (C) M. Zhong

% assemble the empirical rhoLTs
assemble_the_rhoLTM = tic;
load(file_name, 'rho_pdist');
hist_counts         = perform_histcount(rho_pdist, hist_edges);
assemble_the_rhoLTM = toc(assemble_the_rhoLTM);
end