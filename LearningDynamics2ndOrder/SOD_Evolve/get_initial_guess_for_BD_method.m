function y_guess = get_initial_guess_for_BD_method(y_prevs)
% function y_guess = get_initial_guess_for_BD_method(y_prevs)

% (C) M. Zhong

order     = size(y_prevs, 2);
y_guess   = zeros(size(y_prevs, 1), 1);
for idx = 1 : order
  y_guess = y_guess + sum(y_prevs(:, 1 : idx) * get_backward_difference_coeff(idx), 2);
end
end