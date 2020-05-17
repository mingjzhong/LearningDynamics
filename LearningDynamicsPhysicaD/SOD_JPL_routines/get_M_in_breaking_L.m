function M = get_M_in_breaking_L(L, time_type)
% function M = get_M_in_breaking_L(L, time_type)

% (C) M. Zhong

switch time_type
  case 'daily'                    % daily     data
    if mod(L, 7) == 0  
      M         = L/7;            % every 7-day/week
    else
      L_factors = factor(L);
      if length(L_factors) == 1
        error('');                % for daily data, has to avoid every day
      else
        M       = L/L_factors(1); % some multiple of days
      end
    end            
  case 'hourly'                   % hourly    data
    M           = L/24;           % every day
  case 'minutely'                 % miniutely data
    M           = L/(24 * 60);    % every day
  otherwise
    error('');
end
end