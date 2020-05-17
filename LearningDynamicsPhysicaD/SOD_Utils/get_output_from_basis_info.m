function [type, degree, n, supp] = get_output_from_basis_info(basis)
% function [type, degree, n, supp] = get_output_from_basis_info(basis)

% (C) M. Zhong

type            = cell(1, basis.dim);
for idx = 1 : basis.dim
  switch basis.type{idx}
    case 'B-spline'
      main_type = 'B-spli.';
    case 'PW-polynomial'
      main_type = 'P.W.Po.';
    case 'Fourier'
      main_type = 'Fourier';
    otherwise
      error('');
  end
  switch basis.sub_type{idx}
    case 'Clamped'
      sub_type  = 'Clamped';
    case 'Standard'
      sub_type  = 'Stand.';
    case 'Full'
      sub_type  = 'Full';
    case 'Cosine'
      sub_type  = 'Cosine';
    case 'Sine'
      sub_type  = 'Sine';
    otherwise
  end 
  type{idx}     = [sub_type ' ' main_type];
end
if length(type) == 1
  type          = type{1};
elseif length(type) == 2
  type          = [type{1} ' + ' type{2}];
end
switch basis.dim
  case 1
    degree      = sprintf('%d', basis.degree);
    n           = sprintf('%d', basis.n);
    supp        = sprintf('[%10.4e, %10.4e]', basis.supp(1), basis.supp(2));
  case 2
    degree      = sprintf('(%d, %d)', basis.degree(1), basis.degree(2));
    n           = sprintf('(%d, %d)', basis.n(1), basis.n(2));
    supp        = sprintf('[%10.4e, %10.4e] x [%10.4e, %10.4e]', basis.supp(1, 1), basis.supp(1, 2), ...
                  basis.supp(2, 1), basis.supp(2, 2));
  otherwise
    error('');    
end
end