function [L, indices] = get_index_in_data_file(years, idx)
% function [L, indices] = get_index_in_data_file(years, idx)

% (C) M. Zhong

days      = get_num_days_from_years(years);
time_vec  = get_time_vec_from_days(days, 'minutely');
L         = length(time_vec);
if idx == 1
  indices = 1 : L;
else
  L_old   = length(get_time_vec_from_days(get_num_days_from_years(1800 : 1899), 'minutely'));
  indices = (1 : L) + L_old;
end
end