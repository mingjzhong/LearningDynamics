function f = PS_1st_order_prey_on_prey(r, prey_attract_prey)
%
%
%
% Ming Zhong
% Postdoc Research at JHU
% Truncation Parameters added by Sui Tang (UCSB)

% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = prey_attract_prey - r(ind).^(-2);
% ind    = r == 0;
% f(ind) = -Inf;

MAURO = false;
r_trunc=0.4;
f       = zeros(size(r));        

if ~MAURO
    ind = r>r_trunc;
    f(ind) = prey_attract_prey - r(ind).^(-2);
    ind = 0<=r & r<=r_trunc;
    a =2/(r_trunc.^3)/(prey_attract_prey - r_trunc.^(-2));
    b = log(abs(prey_attract_prey - r_trunc.^(-2)))-a*r_trunc;
    f(ind) = -exp(a*r(ind)+b);
    
else
    f = prey_attract_prey - r.^(-6);
end

return

