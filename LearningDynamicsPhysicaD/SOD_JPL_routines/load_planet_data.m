function obs_data = load_planet_data(selection_idx, num_years, total_num_years, use_v, data_kind)
% function obs_data = load_planet_data(selection_idx, num_years, total_num_years, use_v, data_kind)

% (C) M. Zhong

obs_data                = load_planet_traj(selection_idx, num_years, total_num_years, use_v, data_kind);
obs_data.ICs            = obs_data.y_fut(:, 1);
obs_data.use_derivative = true;
end