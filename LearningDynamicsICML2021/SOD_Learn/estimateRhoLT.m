function rhoLT = estimateRhoLT(obs_data, sys_info, obs_info)
% function rhoLT = estimateRhoLT(obs_data, sys_info, obs_info)
%
% finds the discretized rho_LT in three different categorizes
% IN: 
%   obs_data, sys_info, obs_info
% OUT:
%   rhoLT: a cell array with rhoLTE and rhoLTXi, or rhoLTE, rhoLTA and rhoLTXi.  Each cell (when it
%          is not empty) is a sys_info.K-by-sys_info.K cell array
%     rhoLTE: it is a struct with the following fields
%       name:       name of this rhoLT, e.g., for rhoLTE, its name is 'energy'
%       histcounts: histogram counts for each bin
%       supp:       support of the rhoLTE
%       hist:       normalized probability for each bin
%       histedges:  histogram edges
%       binwidths:  bin-widths for the histogram edges
%       has_weight: especially designed for rhoLTXi (if xi^2 as a weight is used), rhoLTE/rhoLTA will
%                   always have the weight (r^2/\dor{r}^2)
%       dense:      the griddedInterpolant approximation of hist over supp
%       mrhoLT:     it is a cell array of size 1-by-Number of 1D marginal rhoLTs, and each cell is
%                   a struct with: name, histcounts, supp, hist, histedges, binwidths, and dense
%    rhoLTA and rhoLTXi have the same structure of fields as rhoLTE

% (c) M. Zhong (JHU)

% prepare a learn_info
learn_info.is_rhoLT          = true;
learn_info.break_L           = false;
learn_info.sys_info          = sys_info;
learn_info.SAVE_DIR          = obs_info.SAVE_DIR;
learn_info.pd_file_form      = obs_info.pd_file_form;
learn_info.time_stamp        = obs_info.time_stamp;
learn_info.hist_num_bins     = obs_info.hist_num_bins;
if ~isempty(gcp('nocreate')), learn_info.is_parallel = true; else, learn_info.is_parallel = false; end
% Use only the (y, dy) pair from obs_data, and break them into smaller L's if needed
[y, dy]                      = split_observation_in_L(obs_data.y, obs_data.dy, obs_info.time_vec, ...
                               learn_info);
M                            = size(y, 3);
% prepare the folder for temporary data file output
if ispc, learn_info.temp_dir = [learn_info.SAVE_DIR, '\tempOut\rhoLT\']; 
else, learn_info.temp_dir = [learn_info.SAVE_DIR, '/tempOut/rhoLT/']; end
if ~exist(learn_info.temp_dir, 'dir'), mkdir(learn_info.temp_dir); end
agent_info                   = getAgentInfo(learn_info.sys_info);
[~, rho_range]               = process_the_data(y, dy, learn_info, agent_info);
% Compute rhoTLM
% prepare the bins for hist count
[hist_binwidths, hist_edges] = prepare_hist_items(learn_info.hist_num_bins, rho_range);
% assemble rhoLTM for local error estiamtes
hist_counts                  = assemble_histcounts(M, hist_edges, learn_info);
rhoLT                        = package_rhoLT(hist_edges, hist_binwidths, hist_counts, sys_info, ...
                               rho_range); 
% delete the files
parfor m = 1 : M
  delete_the_file(m, learn_info);
end                             
end