function Escale = get_exponent_scale(some_max)
% function Escale = get_exponent_scale(some_max)

% (c) M. Zhong (JHU)

if some_max < 0
  error('SOD_utils:get_exponent_scale:exception', 'Input: some_max has to be positive!!');
end
if some_max > 1
  Escale = int32(ceil(log10(some_max)));
elseif some_max == 1
  Escale = 1;
else
  Escale = int32(floor(log10(some_max)));
end
end