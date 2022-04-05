function f = PS_1st_order_predator_on_prey(r, predator_repulse_prey)
% function f = PS_1st_order_predator_on_prey(r, predator_repulse_prey)

% (C) M. Zhong

% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = -predator_repulse_prey * r(ind).^(-2);
% ind    = r == 0;
% f(ind) = -Inf;

MAURO = false;

if ~MAURO
    f = -predator_repulse_prey * r.^(-2);
else
    f = -predator_repulse_prey * r.^(-6);
end

return