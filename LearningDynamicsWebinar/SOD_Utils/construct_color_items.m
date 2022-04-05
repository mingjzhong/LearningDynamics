function output = construct_color_items(K, time_vec)
%

% (c) M. Zhong

% initialize storage
cmap_names               = {'winter', 'autumn', 'parula', 'jet', 'hsv', 'hot', 'cool', 'spring', ...
                            'summer', 'gray', 'bone', 'copper', 'pink', 'lines', 'colorcube', ...
                            'prism', 'flag'};
% due to the number of available (preset) color maps, we put in a check
if K > length(cmap_names)
  error('SOD_Utils:construct_colormap:exception', ...
  'The Coloring Scheme only works for upto %d types of agents!!', length(cmap_names));
end                          
% setup some default values
T_f                    = time_vec(end);
T_0                    = time_vec(1);
L                      = length(time_vec);
scaled_time            = (time_vec - T_0)/(T_f - T_0);
nRows                  = 256;
nCols                  = 3;
if K == 1
  nRows_max            = 246;
  nRows_min            = 6;
else
  nRows_max            = 236;
  nRows_min            = 20;
end
color_ind              = round((nRows_max - nRows_min) * scaled_time + nRows_min);
cmap                   = zeros(K * nRows, nCols);
% set up some color related terms
c_vecs                 = cell(1, K);
% run through each type
for k = 1 : K
  ind1                 = (k - 1) * nRows + 1;
  ind2                 = (k - 1) * nRows + nRows;
  cmap(ind1 : ind2, :) = colormap(cmap_names{k});
  c_vecs{k}            = zeros(1, L, 3);
  c_vecs{k}(1, :, :)   = cmap(color_ind + (k - 1) * nRows, :);
end
% package data
output.cmap            = cmap;
output.c_vecs          = c_vecs;
output.color_ind       = color_ind;
end