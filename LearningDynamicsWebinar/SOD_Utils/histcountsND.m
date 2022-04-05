function hist_count = histcountsND(data, edges)
% function hist_count = histcountsND(data, edges)

% (C) M. Zhong
% modified from the code ''histcn.m'' by Bruno Luong: <brunoluong@yahoo.com>

if length(data) < 3, error(''); end              % 1D and 2D histcounts are built-in by MATLAB
if length(data) ~= length(edges), error(''); end % they have to have the same length
% change data into a matrix
N                    = length(data);
for idx = 1 : N                                 
  data{idx}          = data{idx}(:);             % change it to a column vector
  if ~isrow(edges{idx})
    error('SOD_Utils:histcountsND:exception', 'Each cell in edges is a row vector'); 
  end          
end
data                 = [data{:}];                % should be a matrix
% Allocation of array loc: index location of X in the bins
loc                  = zeros(size(data));
sz                   = zeros(1, N);
% Loop in the dimension
for idx = 1 : N
  edge               = edges{idx};
  Xd                 = data(:,idx);
% Call histc on this dimension
  [~, ~, loc(:,idx)] = histcounts(Xd, edge);
% Use sz(d) = length(ed); to create consistent number of bins
  sz(idx)            = length(edge) - 1;
end % for-loop
% This is need for seldome points that hit the right border
sz                   = max([sz; max(loc, [], 1)]);
hasdata              = all(loc > 0, 2);
hist_count           = accumarray(loc(hasdata,:), 1, sz);
end