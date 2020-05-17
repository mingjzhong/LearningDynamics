function PI = get_JPL_planet_information_over_time(traj, time_vec, sys_info)
% function PI = get_JPL_planet_information_over_time(traj, time_vec, sys_info)

% (C) M. Zhong
                                                     
PI                  = zeros(sys_info.N - 1, 4, 2);                                                            
for idx = 2 : sys_info.N                                                                            % Sun is indexed at 1
  ind1              = (idx - 1) * sys_info.d + 1;
  ind2              = idx       * sys_info.d;
  switch sys_info.AO_names{idx}
    case 'Moon'
      cent_pos      = traj((ind1 - sys_info.d) : (ind2 - sys_info.d), :);
    otherwise
      cent_pos      = traj(1 : sys_info.d, :);
  end
  CenttoP_pos       = traj(ind1 : ind2, :) - cent_pos;     
  PI_info.type      = sys_info.AO_names{idx};
  if isfield(sys_info, 'freq') && ~isempty(sys_info.freq)
    PI_info.freq    = sys_info.freq;
  else
    PI_info.freq    = 60;
  end
  PI(idx - 1, :, :) = get_JPL_planet_information_each_planet(CenttoP_pos, time_vec, PI_info);
end
end