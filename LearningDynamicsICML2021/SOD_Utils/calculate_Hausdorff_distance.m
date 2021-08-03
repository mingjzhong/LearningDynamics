function Hausdorff_dist = calculate_Hausdorff_distance(X, Y)
% function Hausdorff_dist = calculate_Hausdorff_distance(X, Y)

% (C) M. Zhong

dx = size(X, 2); dy = size(Y, 2);
if dx ~= dy, error(''); end
XY_dist        = pdist2(X, Y);
Xsup_Yinf      = max(min(XY_dist, [], 1)); 
Ysup_Xinf      = max(min(XY_dist, [], 2));
Hausdorff_dist = max([Xsup_Yinf, Ysup_Xinf]);
end