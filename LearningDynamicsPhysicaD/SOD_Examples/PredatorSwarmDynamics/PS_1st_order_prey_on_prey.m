function f = PS_1st_order_prey_on_prey(r, prey_attract_prey)
%
%

% Ming Zhong
% Postdoc Research at JHU

% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = prey_attract_prey - r(ind).^(-2);
% ind    = r == 0;
% f(ind) = -Inf;

MAURO = false;

if ~MAURO
    f = prey_attract_prey - r.^(-2);
else
    f = prey_attract_prey - r.^(-6);
end

return

