function pairwise_data = SOD_feature_map(state_i, state_j)
% function pairwise_data = SOD_feature_map(state_i, state_j)

% (C) M. Zhong

pairwise_data = mod(get_xi_j_minus_xi_i(state_i{3}, state_j{3}) + pi, 2 * pi) - pi;
end