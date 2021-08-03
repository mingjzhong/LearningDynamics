function regulation = gravity_regulation(func, supp, type)
% function regulation = gravity_regulation(func, supp, type)

% (C) M. Zhong

pts            = linspace(supp(1), supp(2), 501);
h              = pts(2) - pts(1);
switch type
  case 'L1'
    regulation = (sum(abs(func(pts(1 : end - 1)))) * h);
  case 'L2'
    regulation = (sum(abs(func(pts(1 : end - 1))).^2) * h)^(0.5);
  case 'Linfty'
    regulation = max(abs(func(pts)));
  case 'TV'   % func is already the derivative of phi'_m(r)/phi_m(r)
    regulation = (sum(abs(func(pts(1 : end - 1)))) * h);
  otherwise
    error('');
end
end