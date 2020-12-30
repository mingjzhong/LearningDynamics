function f = PS_1st_order_prey_on_predator(r, prey_attract_predator, predator_sense_prey)
%
%  Ming Zhong
% Postdoc Research at JHU
% Truncation Parameters added by Sui Tang (UCSB)


% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = prey_attract_predator * r(ind).^(-predator_sense_prey);
% ind    = r == 0;
% f(ind) = Inf;
f       = zeros(size(r));        

r_trunc=1;
ind =r >r_trunc;
f(ind) = prey_attract_predator * r(ind).^(-predator_sense_prey);
ind = 0<=r& r<=r_trunc;
a = (-predator_sense_prey)*r_trunc.^(-1);
b = log(abs(prey_attract_predator * r_trunc.^(-predator_sense_prey)))-a*r_trunc;
f(ind)= exp(a*r(ind)+b);



end