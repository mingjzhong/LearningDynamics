function ind_vec = get_ind_vec_for_traj(L, time_type)
% function ind_vec = get_ind_vec_for_traj(total_num_days, time_type)

% (C) M. Zhong

switch time_type
  case 'daily'
    ind_vec = 1 : L;                                                                                
  case 'hourly'
    ind_vec = 1 : 24 : L;
  case 'minutely'
    ind_vec = 1 : 24 * 60 : L;
  otherwise
    error('');
end
end