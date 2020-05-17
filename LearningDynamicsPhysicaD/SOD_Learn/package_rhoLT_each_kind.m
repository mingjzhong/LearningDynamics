function rhoLT = package_rhoLT_each_kind(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range, kind)
% function rhoLT = package_rhoLT_each_kind(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range, kind)

% (C) M. Zhong

rhoLT.name                 = kind;
switch kind
  case 'energy'
    marginal_names         = {'r', 'sE'};
    has_weight             = true;
  case 'alignment'
    marginal_names         = {'r', 'sA', 'dotr'};
    has_weight             = true;
  case 'xi'
    marginal_names         = {'r', 'sXi', 'xi'};
    if isfield(sys_info, 'LC_type') && ~isempty(sys_info.LC_type) && strcmp(sys_info.LC_type, 'Synchronization')
      has_weight           = false; 
    else
      has_weight           = true; 
    end
  otherwise
    error('');
end
rhoLT.histcounts           = hist_counts{end};
rhoLT.histedges            = hist_edges;
rhoLT.binwidths            = hist_binwidths;
total_histcounts           = sum(rhoLT.histcounts(:));
if total_histcounts == 0
  rhoLT.hist               = zeros(size(rhoLT.histcounts));
else
  rhoLT.hist               = rhoLT.histcounts/(total_histcounts * get_hist_binwidth_prod(rhoLT.binwidths));
end
rhoLT.has_weight           = has_weight;
rhoLT.supp                 = cell(size(hist_edges));
for ind = 1 : length(hist_edges)
  rhoLT.supp{ind}          = [hist_edges{ind}(1), hist_edges{ind}(end)];
end
switch size(rho_range, 1)
  case 1
    rhoLT.dense            = @(x)       evaluate_rhoLT1D(x, rhoLT);
  case 2
    rhoLT.dense            = @(x, y)    evaluate_rhoLT2D(x, y, rhoLT);
  case 3
    rhoLT.dense            = @(x, y, z) evaluate_rhoLT3D(x, y, z, rhoLT);
  otherwise
    error('');
end
if size(rho_range, 1) > 1
  mrhoLT                   = cell(1, size(rho_range, 1));
  for ind = 1 : size(rho_range, 1)
    mrhoLT{ind}.name       = marginal_names{ind};
    mrhoLT{ind}.histcounts = hist_counts{ind};
    mrhoLT{ind}.histedges  = hist_edges{ind};
    mrhoLT{ind}.binwidths  = hist_binwidths{ind};
    total_histcounts       = sum(mrhoLT{ind}.histcounts);
    if total_histcounts == 0
      mrhoLT{ind}.hist     = zeros(size(mrhoLT{ind}.histcounts));
    else
      mrhoLT{ind}.hist     = mrhoLT{ind}.histcounts/(total_histcounts * mrhoLT{ind}.binwidths);
    end
    mrhoLT{ind}.supp       = [mrhoLT{ind}.histedges(1), mrhoLT{ind}.histedges(end)];
    mrhoLT{ind}.dense      = @(x) evaluate_rhoLT1D(x, mrhoLT{ind});
  end
  rhoLT.mrhoLT             = mrhoLT;
else
  rhoLT.mrhoLT             = [];
end
end