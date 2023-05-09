function inp = get_inner_product_wrt_rho(f, g, supp, rho)
% function inp = get_inner_product_wrt_rho(f, g, supp, rho)

% (C) M. Zhong

r_range = intersectInterval(rho.supp, supp);
resol   = 2000;
r_ctrs  = linspace(r_range(1), r_range(2), resol + 1);
drhos   = rho.dense(r_ctrs);
if ~isrow(r_ctrs), r_ctrs = r_ctrs'; end
if ~iscolumn(drhos), drhos = drhos'; end
inp     = (f(r_ctrs) .* g(r_ctrs)) * drhos;
end