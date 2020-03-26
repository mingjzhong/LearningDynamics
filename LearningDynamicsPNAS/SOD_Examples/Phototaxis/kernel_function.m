function k = kernel_function(x, radius, type)
%
%

% Ming Zhong
% Postdoc Research JHU

%
k          = zeros(size(x));
%
switch type
  case 'global'
    k      = eye(size(x));
  case 'uniform'
    ind    = abs(x) <= radius;
    k(ind) = 1;
  case 'triangular'
    ind    = abs(x) <= radius;
    k(ind) = 1 - abs(x(ind))/radius;
  case 'parabolic'
    ind    = abs(x) <= radius;
    k(ind) = 1 - (x(ind)/radius).^2;
  case 'quartic'
    ind    = abs(x) <= radius;
    k(ind) = (1 - (x(ind)/radius).^2).^2;
  case 'triweight'
    ind    = abs(x) <= radius;
    k(ind) = (1 - (x(ind)/radius).^2).^3;
  case 'tricube'
    ind    = abs(x) <= radius;
    k(ind) = (1 - abs(x(ind)/radius).^3).^3;
  case 'gaussian'
    ind    = abs(x) <= radius;
    k(ind) = exp(-1/2 * (x(ind)/radius).^2);
  case 'cosine'
    ind    = abs(x) <= radius;
    k(ind) = cos(pi/2 * x(ind)/radius);
  case 'logistic'
    ind    = abs(x) <= radius;
    k(ind) = 1./(exp(x(ind)/raiuds) + 2 + exp(-x(ind)/raiuds));
  case 'sigmoid'
    ind    = abs(x) <= radius;
    k(ind) = 1/2 * exp(-abs(x(ind)/radius)/sqrt(2)) .* ...
    sin(abs(x(ind)/radius)/sqrt(2) + pi/4);
end