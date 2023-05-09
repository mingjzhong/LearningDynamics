function Fv = MS_friction(v, type)
% function Fv = MS_friction(v)

% (c) M. Zhong

switch type
  case 1
    Fv = zeros(size(v));
    Fv = Fv(:);
  case 2
    Fv = -v;
    Fv = Fv(:);
  otherwise
end
end