function trajind = get_JPL_dot_xv_ind_in_traj(day_0, time_type)
% function trajind = get_JPL_dot_xv_ind_in_traj(day_0, time_type)

% (C) M. Zhong

switch time_type
  case 'daily'
    L   = day_0;
  case 'hourly'
    L   = day_0 * 24;
  case 'minutely'
    L   = day_0 * 24 * 60;
  otherwise
end
trajind = get_ind_vec_for_traj(L, time_type);
end