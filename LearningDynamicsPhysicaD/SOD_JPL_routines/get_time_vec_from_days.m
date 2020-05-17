function time_vec = get_time_vec_from_days(days, kind)
% function time_vec = get_time_vec_from_days(days, kind)

% (C) M. Zhong

switch kind
  case 'daily'
    num_days    = sum(days);
    time_vec    = 0 : (num_days - 1);    
  case 'hourly'
    num_hours   = sum(days) * 24;
    time_vec    = (0 : (num_hours - 1))/24;
  case 'minutely'
    num_minutes = sum(days) * 24 * 60;
    time_vec    = (0 : (num_minutes - 1))/(24 * 60);    
  otherwise
    error('');
end
end