function rhoLTemp = assembleRhoLTemp(histItems, sys_info)
%

% (c) M. Zhong (JHU)

M = length(histItems);

for m = 1 : M
  
end




Timings.total                    = tic;

% prepare some indicators
if sys_info.ode_order == 1
  has_align                      = false;
  has_xi                         = false;
elseif sys_info.ode_order == 2
  has_align                      = ~isempty(sys_info.phiA);
  has_xi                         = sys_info.has_xi;
end
% initialize storage
max_rs                           = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
min_rs                           = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
max_dotrs = []; min_dotrs = []; max_xis = []; min_xis = [];
if has_align
  max_dotrs                      = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
  min_dotrs                      = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
end
if has_xi
  max_xis                        = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
  min_xis                        = zeros(sys_info.K, sys_info.K, size(obs_data.x, 3));
end
% use the max_rs, max_dotrs and max_xis from user input if given
if isfield(obs_info, 'max_rs') || ~isempty(obs_info.max_rs)
% go through each Monte Carlo realization (parfor is not mandatory here)
  Mtrajs                         = obs_data.x;                                                       % not to broadcast the whole obs_data
  parfor m = 1 : size(obs_data.x, 3)
    traj                         = squeeze(Mtrajs(:, :, m));
    output                       = find_maximums(traj, sys_info);
    max_rs(:, :, m)              = output.max_rs;
    if has_align, max_dotrs(:, :, m) = output.max_dotrs; end
    if has_xi, max_xis(:, :, m)  = output.max_xis; end
  end
  % find out the maximum over all m realizations
  max_rs                         = max(max_rs, [], 3);
  if has_align, max_dotrs = max(max_dotrs, [], 3); end
  if has_xi, max_xis = max(max_xis, [], 3); end
else
  max_rs                         = obs_info.max_rs;
  if has_align, max_dotrs = obs_info.max_dotrs; end
  if has_xi, max_xis = obs_info.max_xis; end
end
% prepare the bins for hist count
[histedgesR, histbinwidthR, histedgesDR, histbinwidthDR, histcountR, histcountA, histcountDR, jhistcountXi, ...
histcountXi]                     = prepare_hist_items(sys_info.K, obs_info.hist_num_bins, size(Mtrajs, 3), max_rs, max_dotrs, max_xis);
% go through each MC realization
parfor m = 1 : size(Mtrajs, 3)
  traj                           = squeeze(Mtrajs(:, :, m));
  pdist_out                      = partition_traj(traj, sys_info);
  max_rs(:, :, m)                = pdist_out.max_r;
  min_rs(:, :, m)                = pdist_out.min_r;
  histcountR_m                   = cell(sys_info.K);
  if has_align, histcountA_m = cell(sys_info.K); histcountDR_m = cell(sys_info.K); max_dotrs(:, :, m) = pdist_out.max_rdot; min_dotrs(:, :, m) = pdist_out.min_rdot;end
  if has_xi, jhistcountXi_m = cell(sys_info.K); histcountXi_m = cell(sys_info.K); max_xis(:, :, m) = pdist_out.max_xi; min_xis(:, :, m) = pdist_out.min_xi;end
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      pdist_x_Ck1_Ck2            = pdist_out.pdist_x{k1, k2};
      if ~isempty(pdist_x_Ck1_Ck2)
        histcountR_m{k1, k2}     = histcounts(pdist_x_Ck1_Ck2(:), histedgesR{k1, k2}, 'Normalization', 'count');
      end
      if has_align
        pdist_v_Ck1_Ck2          = pdist_out.pdist_v{k1, k2};
        if ~isempty(pdist_v_Ck1_Ck2) && ~isempty(pdist_x_Ck1_Ck2)
          histcountA_m{k1, k2}   = histcounts2(pdist_x_Ck1_Ck2(:), pdist_v_Ck1_Ck2(:), histedgesR{k1, k2}, histedgesDR{k1, k2}, 'Normalization', 'count');
          histcountDR_m{k1, k2}  = histcounts(pdist_v_Ck1_Ck2(:), histedgesDR{k1, k2}, 'Normalization', 'count');
        end
      end
      if has_xi
        pdist_xi_Ck1_Ck2         = pdist_out.pdist_xi{k1, k2};
        if ~isempty(pdist_xi_Ck1_Ck2) && ~isempty(pdist_x_Ck1_Ck2)
          jhistcountXi_m{k1, k2} = histcounts2(pdist_x_Ck1_Ck2(:), pdist_xi_Ck1_Ck2(:), histedgesR{k1, k2}, histedgesXi{k1, k2}, 'Normalization', 'count');
          histcountXi_m{k1, k2}  = histcounts(pdist_xi_Ck1_Ck2(:), histedgesXi{k1, k2}, 'Normalization', 'count');
        end
      end
    end
  end
  histcountR{m}                  = histcountR_m;
  if has_align, histcountA{m} = histcountA_m; histcountDR{m} = histcountDR_m; end
  if has_xi, jhistcountXi{m} = jhistcountXi_m; histcountXi{m} = histcountXi_m; end
end
% package the data
rhoLT                            = package_rhoLT(histedgesR, histcountR, histbinwidthR, histedgesDR, histcountDR, histbinwidthDR, histedgesXi, histcountXi, histbinwidthXi, ...
histcountA, jhistcountXi, size(Mtrajs, 3), sys_info, obs_info, max_rs, min_rs, max_dotrs, min_dotrs, max_xis, min_xis);
rhoLT.Timings.total              = toc(Timings.total );
end

end