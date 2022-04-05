function rhoLT = package_rhoLT_each_kind(hist_edges, hist_binwidths, hist_counts, sys_info, ...
                 rho_range, kind)
% function rhoLT = package_rhoLT_each_kind(hist_edges, hist_binwidths, hist_counts, sys_info, ...
%                 rho_range, kind)

% (C) M. Zhong

rhoLT.name                 = kind;
rhoLT.dim                  = size(rho_range, 1);
switch kind
  case 'energy'
    marginal_names         = {'r', 'sE', 'z'};
    rhoLT.has_weight       = true;
    rhoLT.weight_pos       = 1;
  case 'alignment'
    switch size(rho_range, 1)
      case 2
        marginal_names     = {'r', 'dotr'};
        rhoLT.weight_pos   = 2;
      case 3
        marginal_names     = {'r', 'sA', 'dotr'};
        rhoLT.weight_pos   = 3;
      otherwise
    end
    rhoLT.has_weight       = true;
  case 'xi'
    switch size(rho_range, 1)
      case 2
        marginal_names     = {'r', 'xi'};
        rhoLT.weight_pos   = 2;
      case 3
        marginal_names     = {'r', 'sXi', 'xi'};
        rhoLT.weight_pos   = 3;
      otherwise
    end    
    if isfield(sys_info, 'phiXi_weight') && ~isempty(sys_info.phiXi_weight) && ~sys_info.phiXi_weight
      rhoLT.has_weight     = false;
    else
      rhoLT.has_weight     = true; 
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
rhoLT.supp                 = zeros(rhoLT.dim, 2);
for ind = 1 : rhoLT.dim
  rhoLT.supp(ind, :)       = [hist_edges{ind}(1), hist_edges{ind}(end)];
end
switch size(rho_range, 1)
  case 1
    if iscell(rhoLT.histedges)
      r_ctrs               = (rhoLT.histedges{1}(2 : end) + rhoLT.histedges{1}(1 : end - 1))/2;
    else
      r_ctrs               = (rhoLT.histedges(2 : end) + rhoLT.histedges(1 : end - 1))/2;
    end
    denseRhoLT1D           = griddedInterpolant(r_ctrs, rhoLT.hist, 'linear', 'linear');    
    rhoLT.dense            = @(x)       evaluate_rhoLT1D(x,       rhoLT, denseRhoLT1D);
  case 2
    r_ctrs                 = (rhoLT.histedges{1}(2 : end) + rhoLT.histedges{1}(1 : end - 1))/2;
    s_ctrs                 = (rhoLT.histedges{2}(2 : end) + rhoLT.histedges{2}(1 : end - 1))/2;
    [R, S]                 = ndgrid(r_ctrs, s_ctrs);
    densRhoLT2D            = griddedInterpolant(R, S, rhoLT.hist, 'linear', 'linear');    
    rhoLT.dense            = @(x, y)    evaluate_rhoLT2D(x, y,    rhoLT, densRhoLT2D);
  case 3
    r_ctrs                 = (rhoLT.histedges{1}(2 : end) + rhoLT.histedges{1}(1 : end - 1))/2;
    s_ctrs                 = (rhoLT.histedges{2}(2 : end) + rhoLT.histedges{2}(1 : end - 1))/2;
    z_ctrs                 = (rhoLT.histedges{3}(2 : end) + rhoLT.histedges{3}(1 : end - 1))/2;
    [R, S, Z]              = ndgrid(r_ctrs, s_ctrs, z_ctrs);                                        % different from meshgrid even in 2D
    densRhoLT3D            = griddedInterpolant(R, S, Z, rhoLT.hist, 'linear', 'linear');    
    rhoLT.dense            = @(x, y, z) evaluate_rhoLT3D(x, y, z, rhoLT, densRhoLT3D);
  otherwise
    error('');
end
% need to simplify mrhoLT to save memory, it is used for visualization and what else?
% left by MZ, 10/25/2020
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
    mrhoLT{ind}.dim        = 1;
    mrhoLT{ind}.supp       = [mrhoLT{ind}.histedges(1), mrhoLT{ind}.histedges(end)];
    r_ctrs                 = (mrhoLT{ind}.histedges(2 : end) + mrhoLT{ind}.histedges(1 : end - 1))/2;
    denseRhoLT1D           = griddedInterpolant(r_ctrs, mrhoLT{ind}.hist, 'linear', 'linear');
    mrhoLT{ind}.dense      = @(x) evaluate_rhoLT1D(x, mrhoLT{ind}, denseRhoLT1D);
  end
  rhoLT.mrhoLT             = mrhoLT;
else
  rhoLT.mrhoLT             = [];
end
end