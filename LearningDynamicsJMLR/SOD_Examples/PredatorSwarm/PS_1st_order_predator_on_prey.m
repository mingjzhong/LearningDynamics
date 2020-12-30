function f = PS_1st_order_predator_on_prey(r, predator_repulse_prey)
%
%

%
% Ming Zhong
% Postdoc Research at JHU
% Truncation Parameters added by Sui Tang (UCSB)


% f      = zeros(size(r));
% ind    = r > 0;
% f(ind) = -predator_repulse_prey * r(ind).^(-2);
% ind    = r == 0;
% f(ind) = -Inf;
f       = zeros(size(r));        

r_trunc=0.4;
MAURO = false;

if ~MAURO
    ind = r> r_trunc;
    f(ind) = -predator_repulse_prey * r(ind).^(-2);
    ind = r<=r_trunc & 0<=r;
    a= -2 /r_trunc;
    b= log(abs(-predator_repulse_prey * r_trunc.^(-2))) -a*r_trunc;
    f(ind) = -exp(a*r(ind)+b);
else
    f = -predator_repulse_prey * r.^(-6);
end

return