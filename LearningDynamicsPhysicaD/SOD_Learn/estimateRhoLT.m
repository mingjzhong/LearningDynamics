function [rhoLT, Timings] = estimateRhoLT(obs_data, sys_info, obs_info)
% function [rhoLT, Timings] = estimateRhoLT(obs_data, sys_info, obs_info)
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

% partition the trajectory data in to (x, v, xi) and then make distributed copies
[x_d, v_d, xi_d]                     = split_observation(obs_data, obs_info, sys_info);
x_d                                  = distributed(x_d); 
v_d                                  = distributed(v_d); 
xi_d                                 = distributed(xi_d);
% prepare a temporary learn_info variable
learn_info.SAVE_DIR                  = obs_info.SAVE_DIR; 
learn_info.time_stamp                = obs_info.time_stamp; 
learn_info.is_rhoLT                  = true;
learn_info.VERBOSE                   = obs_info.VERBOSE; 
learn_info.hist_num_bins             = obs_info.hist_num_bins;
learn_info.pd_file_form              = obs_info.pd_file_form;
% define the tags for data communication (shared by all workers)
rho_range_tags                       = 0 : 2;
idle_cpu_tag                         = 4;
% naming convention for the varaibles:
% 1) *_d, distributed data from client side (not individual worker)
% 2) *_l, local data (stored in each individual worker) needed for final assembly later on client side
% prepare the folder for temporary data file output
if ispc, learn_info.temp_dir = [learn_info.SAVE_DIR, '\tempOut\rhoLT\']; 
else, learn_info.temp_dir = [learn_info.SAVE_DIR, '/tempOut/rhoLT/']; end
if ~exist(learn_info.temp_dir, 'dir'), mkdir(learn_info.temp_dir); end
% start the parallelization using SPMD, variable de
spmd
  if labindex == 1, num_cores_l = numlabs; else, num_cores_l = [];    end                           % Lab(1) is in charge of communicating, so it has to know the number of workers in the system    
  x = getLocalPart(x_d); v = getLocalPart(v_d); xi = getLocalPart(xi_d);                            % get local copies of v, xi, dot_xv and dot_x
  if labindex ~= 1                                                                                  % create the list of working CPUs for CPU 1
    if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending the indicator of working CPU (tagID = %d) to Lab ( 1).', ...
      labindex, idle_cpu_tag); end    
    labSend(~isempty(x), 1, idle_cpu_tag);
  else
    work_cpu_tags                   = true(1, num_cores_l);
    for lab_ind = 2 : num_cores_l
      if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving the indicator of working CPU (tagID = %d) from Lab (%2d).', ...
        labindex, idle_cpu_tag, lab_ind); end
      work_cpu_tags(lab_ind)        = labReceive(lab_ind, idle_cpu_tag);
    end
    work_cpu_list                   = 1 : num_cores_l;
    work_cpu_list                   = work_cpu_list(work_cpu_tags);
  end
  if ~isempty(x)
% initialize some indicators                                    
    agents_info = getAgentInfo(sys_info);
    if learn_info.VERBOSE > 1
      fprintf('\nLab = %2d: My copy of x has size [%d, %d, %d].', labindex, size(x, 1), size(x, 2), size(x, 3));
    end
    findRange_l                      = tic;
    [~, rho_range_l]                 = partition_the_data(x, v, xi, agents_info, sys_info, learn_info, ...
                                       labindex);
    if labindex ~= 1                                                                                % other cpus send pdata_l to cpu 1
      for ind = 1 : length(rho_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending my copy of rho range data{%d} (tagID = %d) to Lab ( 1).', ...
          labindex, ind, rho_range_tags(ind)); end
        labSend(rho_range_l{ind}, 1, rho_range_tags(ind));
      end
    else                                                                                            % cpu 1 to receive the data when process pdata_l
      other_rho_range_l              = cell(size(rho_range_l));                
      for lab_ind = 2 : length(work_cpu_list)
        for ind =  1 : length(rho_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving rho range data{%d} (tagID = %d) from Lab(%2d).', ...
            labindex, ind, rho_range_tags(ind), lab_ind); end
          other_rho_range_l{ind}     = labReceive(work_cpu_list(lab_ind), rho_range_tags(ind));
        end
        rho_range_l                  = process_range_data(rho_range_l, other_rho_range_l);
      end
    end
    if labindex == 1                                                                                % cpu1 to send the processed pdata_l to other CPUs
      for lab_ind = 2 : length(work_cpu_list)
        for ind = 1 : length(rho_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending range data{%d} (tagID = %d) to Lab(%2d).', ...
              labindex, ind, rho_range_tags(ind), lab_ind); end
          labSend(rho_range_l{ind}, work_cpu_list(lab_ind), rho_range_tags(ind));
        end
      end
    else                                                                                            % other cpus to receive the processed pdata_l
      for ind = 1 : length(rho_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving pdata{%d} (tagID = %d) from Lab( 1).', ...
          labindex, ind, rho_range_tags(ind)); end
        rho_range_l{ind}             = labReceive(1, rho_range_tags(ind));
      end
    end
    findRange_l                      = toc(findRange_l);
% prepare the bins for hist count
    performHistcount_l               = tic;
    [hist_binwidths_l, hist_edges_l] = prepare_hist_items(learn_info.hist_num_bins, rho_range_l);    % prepare items for doing histcounts
    for m = 1 : size(x, 3)                                                                          % start the MC loop
      file_name                      = sprintf(obs_info.pd_file_form, learn_info.temp_dir, ...
                                       sys_info.name, learn_info.time_stamp, labindex, m);
      hist_counts_m                  = assemble_histcounts_at_m(hist_edges_l, file_name);
      if m == 1
        hist_counts_l                = hist_counts_m; % first time, we calculated hist_counts_m
      else
        hist_counts_l                = add_histcounts(hist_counts_m, hist_counts_l);    
      end
% delete the data file
      delete(file_name);
    end
    performHistcount_l               = toc(performHistcount_l);
  else
    hist_edges_l = []; hist_binwidths_l = []; hist_counts_l = []; findRange_l = []; performHistcount_l = [];
  end
end
Timings.findRange                    = mean([findRange_l{:}]);
Timings.performHistcount             = mean([performHistcount_l{:}]);
hist_counts                          = sum_histcounts_over_all_cpus(hist_counts_l);
rhoLT                                = package_rhoLT(hist_edges_l{1}, hist_binwidths_l{1}, hist_counts, sys_info, rho_range_l{1});   
end