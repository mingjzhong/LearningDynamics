function hist_counts = assemble_histcounts_at_m(m, hist_edges, learn_info)
% function hist_counts = assemble_histcounts_at_m(m, hist_edges, learn_info)

% (C) M. Zhong

% assemble the empirical rhoLTs
file_name  = sprintf(learn_info.pd_file_form, learn_info.temp_dir, learn_info.sys_info.name, ...
             learn_info.time_stamp, m);
load(file_name, 'rho_pdist');
hist_counts = perform_histcount(rho_pdist, hist_edges, learn_info.sys_info);
if learn_info.is_parallel
  save(file_name, '-append', 'hist_counts');
end
end