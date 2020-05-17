function y_init = PT_init_condition(d, N, L_x, L_v, L_xi)
% y_init = PT_init_condition(d, N, L_x, L_v, L_xi)

% Ming Zhong
% Postdoc Research at JHU

% find out the initial configuration of x
x_init  = L_x * rand(N * d, 1);
% find out the initial configuration of v
v_init  = L_v * rand(N * d, 1);
% find out the initial configuration of xi
xi_init = L_xi * rand(N, 1);
% put all three of them together
y_init  = [x_init; v_init; xi_init];
end