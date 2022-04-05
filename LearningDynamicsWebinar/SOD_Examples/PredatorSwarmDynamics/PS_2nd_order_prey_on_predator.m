function f = PS_2nd_order_prey_on_predator(r)
% function f = PS_2nd_order_prey_on_predator(r)

% (C) M. Zhong

f = 1.5 * r.^(-2.5);
% f = 1./(r .* (r.^(5) + 1)); this interaction produces a not-so-interesting dynamics
end