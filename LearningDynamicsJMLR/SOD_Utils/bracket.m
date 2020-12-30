function left_indices = bracket(xdata, xval)
% left_indices = bracket(xdata, xval)
% 

% (c) M. Zhong (JHU) from 
ndata                                = length(xdata);
left_indices                         = zeros(size(xval));
% Case 1
left_indices(xval < xdata(2))        = 1;
% Case 2
left_indices(xdata(ndata-1) <= xval) = ndata - 1;
% Case 3
for k = 2 : ndata - 2
 left_indices((xdata(k) <= xval) & (xval < xdata(k+1))) = k;
end
% final error check
if any(left_indices==0)
  error('bracket: not all indices set!')
end
end