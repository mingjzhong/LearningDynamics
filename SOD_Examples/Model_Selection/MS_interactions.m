function phi = MS_interactions(r, type)
% function phi = MS_interactions(r, type)

% (c) M. Zhong

switch type
  case 1
    phi = 2 - r.^(-2);
  case 2
    phi = (1 + r.^2).^(-0.25);
  case 3
    phi = 1 - r.^(-2);
  case 4
    phi = -2 * r.^(-2);
  case 5
    phi = 3 * r.^(-3.5);
  case 6
    phi = zeros(size(r));
  case 7
    phi = -r.^(-2);
  case 8
    phi = 1.5 * r.^(-2.5);
  otherwise
end
end