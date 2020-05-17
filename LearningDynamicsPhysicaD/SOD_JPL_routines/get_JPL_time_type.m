function time_type = get_JPL_time_type(data_kind)
% function time_type = get_JPL_time_type(data_kind)

% (C) M. Zhong

switch data_kind
  case 1
    time_type                  = 'daily';
  case 2
    time_type                  = 'daily';
  case 3
    time_type                  = 'hourly';
  case 4
    time_type                  = 'minutely';
  otherwise
    error('');
end
end