function I = intersectInterval(I_1, I_2)
% function I = intersectInterval(I_1, I_2)

% (C) M. Zhong 

validateattributes(I_1, {'numeric'}, {'vector', 'increasing', 'row', 'size', [1, 2]}, ...
  'intersectInterval', 'I_1', 1);
validateattributes(I_2, {'numeric'}, {'vector', 'increasing', 'row', 'size', [1, 2]}, ...
  'intersectInterval', 'I_2', 2);
I(1) = max(I_1(1), I_2(1));
I(2) = min(I_1(2), I_2(2));
if I(1) > I(2), I = []; end
end