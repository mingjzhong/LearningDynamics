function hist_count = get_histcounts_nd(data, edges)
% hist_count = get_histcounts_nd(data, edges)

% (C) M. Zhong

if ~iscell(data), error(''); end
if ~iscell(edges), error(''); end
if isempty(data) || isempty(edges), error(''); end
if length(data) ~= length(edges), error(''); end
switch length(data)
  case 1
    hist_count = histcounts(data{1}, edges{1});                     % built-in MATLAB 1D
  case 2
    hist_count = histcounts2(data{1}, data{2}, edges{1}, edges{2}); % built-in MATLAB 2D
  otherwise
    hist_count = histcountsND(data, edges);                         % improved Nd count
end
end