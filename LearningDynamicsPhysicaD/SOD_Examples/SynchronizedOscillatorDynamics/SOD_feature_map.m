function pairwise_data = SOD_feature_map(state_i, state_j)
% function pairwise_data = SOD_feature_map(state_i, state_j)

% (C) M. Zhong

pairwise_data    = cell(1, 2);
pairwise_data{1} = sqrt(abs(sqdist_mod(state_i{1}, state_j{1})));
pairwise_data{2} = mod(get_xi_j_minus_xi_i(state_i{3}, state_j{3}) + pi, 2 * pi) - pi;
end