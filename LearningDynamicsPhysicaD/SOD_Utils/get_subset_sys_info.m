function [sys_info, trajs, dtrajs, time_vec, T] = get_subset_sys_info(sys_info, trajs, dtrajs, obs_data, kind)
% function [sys_info, trajs, dtrajs, time_vec, T] = get_subset_sys_info(sys_info, trajs, dtrajs, obs_data, kind)

% (C) M. Zhong

time_ind               = 1 : 10 * 365;
switch kind
  case 'EarthMoon'
    sys_info.N         = 3;
    sys_info.K         = 3;
    sys_info.type_info = 1 : 3;
    sys_info.AO_names  = sys_info.AO_names([1, 4, 5]);
    for idx = 1 : length(trajs)
      traj             = trajs{idx};
      ind              = [1 : 3, 10 : 15];
      trajs{idx}       = traj(ind, time_ind);
      dtraj            = dtrajs{idx};
      dtrajs{idx}      = dtraj(ind, time_ind);
    end    
    time_vec           = time_ind - 1;
    T                  = 365;
  case 'inner'
    sys_info.N         = 6;
    sys_info.K         = 6;
    sys_info.type_info = 1 : 6;
    sys_info.AO_names  = sys_info.AO_names(1 : 6);
    for idx = 1 : length(trajs)
      traj             = trajs{idx};
      trajs{idx}       = traj(1 : sys_info.N * sys_info.d, time_ind);
      dtraj            = dtrajs{idx};
      dtrajs{idx}      = dtraj(1 : sys_info.N * sys_info.d, time_ind);
    end
    time_vec           = time_ind - 1;
    T                  = 365;
  case 'outer'
    sys_info.N         = 5;
    sys_info.K         = 5;
    sys_info.type_info = 1 : 5;
    sys_info.AO_names  = sys_info.AO_names([1, 7, 8, 9, 10]);
    for idx = 1 : length(trajs)
      traj             = trajs{idx};
      ind              = [1 : 3, 19 : 30];
      trajs{idx}       = traj(ind, :);
      dtraj            = dtrajs{idx};
      dtrajs{idx}      = dtraj(ind, :);
    end     
    time_vec           = obs_data.day_vec_fut;
    T                  = 365;
  otherwise
    error('');
end
end