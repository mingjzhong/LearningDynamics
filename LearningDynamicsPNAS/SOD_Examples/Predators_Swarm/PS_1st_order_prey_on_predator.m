function f = PS_1st_order_prey_on_predator(r, prey_attract_predator, predator_sense_prey)
%
%

%
%

% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = prey_attract_predator * r(ind).^(-predator_sense_prey);
% ind    = r == 0;
% f(ind) = Inf;

f = prey_attract_predator * r.^(-predator_sense_prey);

end