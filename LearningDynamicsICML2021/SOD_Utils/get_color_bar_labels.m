function output = get_color_bar_labels(cbh, K, T, time_vec, color_ind)
% function output = get_color_bar_labels(cbh, K, T, time_vec, color_ind)

% (C) M. Zhong

block                  = (cbh.Limits(2) - cbh.Limits(1))/K;
% setup some default values
T_f                    = time_vec(end);
T_0                    = time_vec(1);
c                      = ceil(T_f/T);
nRows                  = 256;
if c == 1, multiple = 2; else, multiple = 3; end
if T_0 == 0, T0_label = '0'; else, T0_label = sprintf('%.1e', T_0); end
% set up some color related terms
clabels                = cell(1, multiple * K);
cticks                 = zeros(1, multiple * K);
if c > 1
  set_labels           = {T0_label, 'T', sprintf('%dT', c)};
  T_ind                = find(time_vec >= T, 1);
  set_ticks            = [color_ind(1), color_ind(T_ind), color_ind(end)]/nRows;
else
  set_labels           = {T0_label, 'T'};
  set_ticks            = [color_ind(1), color_ind(end)]/nRows;
end
set_ticks              = set_ticks * block + cbh.Limits(1);
for k = 1 : K
  ind1                 = (k - 1) * multiple + 1;
  ind2                 = (k - 1) * multiple + multiple;
  clabels(ind1 : ind2) = set_labels;
  cticks(ind1 : ind2)  = set_ticks + (k - 1) * block;
end
output.labels          = clabels;
output.ticks           = cticks;
end