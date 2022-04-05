function y_init = hyperbolic_surface_init_config(d, N)
% function y_init = hyperbolic_surface_init_config(d, N)

% (C) M. Zhong

v           = randn(d - 1, N);
v           = [zeros(1, N); v];
v_L         = sum(v.^2).^(0.5);
mu_0        = zeros(d, N);
mu_0(1, :)  = 1;
ind         = v_L == 0;
v_Linv      = 1./v_L;
v_Linv(ind) = 1;
y_init      = repmat(cosh(v_L), [d, 1]) .* mu_0 + repmat(sinh(v_L) .* v_Linv, [d, 1]) .* v;
y_init      = y_init(:);
end