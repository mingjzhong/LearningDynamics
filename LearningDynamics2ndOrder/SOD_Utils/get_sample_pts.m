function centers = get_sample_pts(basis)
% function centers = get_sample_pts(basis)

% (C) M. Zhong

switch basis.degree
  case 0
    centers = (basis.knots(2 : end) + basis.knots(1 : end - 1))/2;
  case 1
    hs      = (basis.knots(2 : end) - basis.knots(1 : end - 1))/3;
    centers = union(basis.knots(1 : end - 1) + hs, basis.knots(1 : end - 1) + 2 * hs);
  case 2
    hs      = (basis.knots(2 : end) - basis.knots(1 : end - 1))/4;
    centers = union(basis.knots(1 : end - 1) + hs, basis.knots(1 : end - 1) + 2 * hs);
    centers = union(centers, basis.knots(1 : end - 1) + 3 * hs);
  case 3
    hs      = (basis.knots(2 : end) - basis.knots(1 : end - 1))/5;
    centers = union(basis.knots(1 : end - 1) + hs, basis.knots(1 : end - 1) + 2 * hs);
    centers = union(centers, basis.knots(1 : end - 1) + 3 * hs);
    centers = union(centers, basis.knots(1 : end - 1) + 4 * hs);
  otherwise
    error('');
end
centers     = union(centers, basis.knots);
end