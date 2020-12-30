function f = MLJ_1st_order_B_on_B(r)
%
% (c) Sui Tang (UCSB)


%
sigma   =1;
p= 5;
q= 2;
epsilon = 5;

r_trunc = 0.8*sigma;

f       = zeros(size(r));        
%ind     = (r>0);
ind     = r>=r_trunc;
rinv    = sigma./r(ind);
f(ind)  = p*q* epsilon * (rinv.^(q+2) -rinv.^(p+2))./((p-q)*sigma^2);
ind  =  r<r_trunc;
% g(r)=-exp(ar.^2+br+c)
rinv_trunc=sigma./r_trunc;
f1=p*q* epsilon * (rinv_trunc.^(q+2) -rinv_trunc.^(p+2))./((p-q)*sigma^2);
f2=p*q*epsilon./((p-q)*sigma^3)*((rinv_trunc).^(p+3)*(p+2)-(rinv_trunc).^(q+3)*(q+2));
%f3=p*q*epsilon/((p-q)*sigma^4)*((rinv_trunc).^(q+4)*(q+2)*(q+3)-(rinv_trunc).^(p+2)*(p+2)*(p+3));
a=f2/(-12*f1*r_trunc.^11);
b=f1*exp(a*r_trunc.^12);
%c=log(abs(f1))-a*sigma^2-b*sigma;
f(ind)=b*exp(-a.*r(ind).^12);

return