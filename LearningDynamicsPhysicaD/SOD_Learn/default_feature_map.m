function rij = default_feature_map(state_i, state_j)
% function rij = default_feature_map(state_i, state_j)

% (C) M. Zhong

rij = {sqrt(abs(sqdist_mod(state_i{1}, state_j{1})))};
end