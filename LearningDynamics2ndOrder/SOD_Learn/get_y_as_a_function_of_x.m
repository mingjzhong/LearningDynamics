function y_of_x = get_y_as_a_function_of_x(x, y, x_ctrs)
% function y_of_x = get_y_as_a_function_of_x(x, y, x_ctrs)

% (C) M. Zhong

[x, ind]      = sort(x);
y             = y(ind);
if ~iscolumn(x), x = x'; end
if ~iscolumn(y), y = y'; end
x_min         = min(x);
x_max         = max(x);
degree        = 3;
n             = 47 + degree;
basis         = set_up_B_spline_basis([x_min, x_max], degree, n);
x_len         = length(x);
Psi           = zeros(x_len, n);
for eta = 1 : n
  Psi(:, eta) = basis.f{eta}(x);
end
alpha         = lsqminnorm(Psi' * Psi, Psi' * y);
y_of_x        = @(x) eval_basis_functions_1D(x, alpha, basis);
y_of_x        = griddedInterpolant(x_ctrs, y_of_x(x_ctrs), 'linear', 'linear');
end