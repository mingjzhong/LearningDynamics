function f = PS_2nd_order_prey_on_prey(r)
%
%

% Ming Zhong
% Postdoc Research at JHU

f      = zeros(size(r));
ind    = r > 0;
f(ind) = 1 - r(ind).^(-2);
ind    = r == 0;
f(ind) = -Inf;