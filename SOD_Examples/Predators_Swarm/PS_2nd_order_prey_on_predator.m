function f = PS_2nd_order_prey_on_predator(r)
%
%

%
%

f      = zeros(size(r));
ind    = r > 0;
% f(ind) = 1./(r(ind) .* (r(ind).^(5) + 1));
% the commented interaction produces non-interesting dynamics
f(ind) = 1.5 * r(ind).^(-2.5);
ind    = r == 0;
f(ind) = Inf;
end