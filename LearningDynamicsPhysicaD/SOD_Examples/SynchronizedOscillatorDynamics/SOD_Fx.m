function Fx = SOD_Fx(d, N, vi)
% function Fx = SOD_Fx(d, N, vi)

% (C) M. Zhong
validateattributes(vi, {'numeric'}, {'size', [d, 1]}, 'SD_Fx', 'vi', 3);
Fx = repmat(vi, [N, 1]);
end