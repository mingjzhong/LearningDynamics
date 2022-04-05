function Escale = get_exponent_scale(max_scale)
% function Escale = get_exponent_scale(max_scale)

% (c) M. Zhong (JHU)

if max_scale < 0
  error('SOD_utils:get_exponent_scale:exception', 'Input: some_max has to be positive!!');
end
if max_scale > 1
  Escale = int32(ceil(log10(max_scale)));
elseif max_scale == 1
  Escale = 1;
else
  Escale = int32(floor(log10(max_scale)));
end
end