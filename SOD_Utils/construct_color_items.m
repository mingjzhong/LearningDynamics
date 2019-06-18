function output = construct_color_items(K, T, time_vec)
%

% (c) M. Zhong

% initialize storage
cmap_names               = {'winter', 'autumn', 'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', ...
'summer', 'gray', 'bone', 'copper', 'pink', 'lines', 'colorcube', 'prism', 'flag'};
c_vecs                   = cell(1, K);
clabels                  = cell(1, 3 * K);
cticks                   = zeros(1, 3 * K);
% setup some default values
T_f                      = time_vec(end);
T_0                      = time_vec(1);
c                        = ceil(T_f/T);
if c > 8, t_ticks = [T_0, 4 * T, T_f]; else, t_ticks = [T_0, T, T_f]; end
if T_0 == 0, T0_label = '0'; else, T0_label = sprintf('%.0e', T_0); end
set_labels               = {T0_label, 'T', sprintf('%dT', c)};
color_shift              = T_f * 0.15;
% due to the number of available (preset) color maps, we put in a check
if K > length(cmap_names)
  error('SOD_Utils:construct_colormap:exception', ...
  'The Coloring Scheme only works for upto %d types of agents!!', length(cmap_names));
end
% run through each type
for k = 1 : K
  ind1                   = (k - 1) * 3 + 1;
  ind2                   = (k - 1) * 3 + 3;
  clabels(ind1 : ind2)   = set_labels;  
  if k == 1
    cticks(ind1 : ind2)  = t_ticks;
    c_vecs{1}            = time_vec;
    map1                 = colormap(cmap_names{1});
    [nRows, nCols]       = size(map1);
    cmap                 = zeros(K * nRows, nCols);
    cmap(1 : nRows, :)   = map1;
  else
    cticks(ind1 : ind2)  = t_ticks + (k - 1) * (T_f + color_shift);
    c_vecs{k}            = time_vec + (k - 1) * (T_f + color_shift);
    ind1                 = (k - 1) * nRows + 1;
    ind2                 = (k - 1) * nRows + nRows;
    cmap(ind1 : ind2, :) = colormap(cmap_names{k});
  end
end
% package data
output.cmap              = cmap;
output.c_vecs            = c_vecs;
output.clabels           = clabels;
output.cticks            = cticks;
end
