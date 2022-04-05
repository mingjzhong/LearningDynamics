function [the_min, the_max] = get_component_range_from_manifold(sys_info)
% function [the_min, the_max] = get_component_range_from_manifold(sys_info)

% (C) M. Zhong

switch sys_info.manifold_type
  case 'S1'
    the_min = -[sys_info.R, sys_info.R];
    the_max =  [sys_info.R, sys_info.R];
  case 'S2'
    the_min = -[sys_info.R, sys_info.R, sys_info.R];
    the_max =  [sys_info.R, sys_info.R, sys_info.R]; 
  case 'H2'
    the_min = [];
    the_max = [];
  case 'PD'
    the_min = [-1, -1];
    the_max = [1,   1];
  otherwise
    error('');
end
end