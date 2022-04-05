function riip = get_distance_between_xi_and_xip(x, sys_info)
% function riip = get_distance_between_xi_and_xip(x, sys_info)

% (C) M. Zhong

if isfield(sys_info, 'on_manifold') && sys_info.on_manifold
  riip = sys_info.geodesic_dist(x, x);
else
  riip = get_Euclidean_pairwise_distance(x);
end
end