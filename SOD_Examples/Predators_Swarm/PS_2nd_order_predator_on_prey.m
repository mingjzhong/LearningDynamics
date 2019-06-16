function f = PS_2nd_order_predator_on_prey(r)
%
%

%
%

f      = zeros(size(r));
ind    = r > 0;
f(ind) = -r(ind).^(-2);
ind    = r == 0;
f(ind) = -Inf;