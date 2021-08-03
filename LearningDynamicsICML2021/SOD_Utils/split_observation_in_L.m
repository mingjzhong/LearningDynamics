function [y, dy, time_vec] = split_observation_in_L(y, dy, time_vec, learn_info)
% function [y, dy, time_vec] = split_observation_in_L(y, dy, time_vec, learn_info)

% (C) M. Zhong

M                   = size(y, 3);
if isempty(dy)
  dy                = approximate_derivative(y, time_vec, 1);
end
if M == 1 && isfield(learn_info, 'break_L') && ~isempty(learn_info.break_L) && learn_info.break_L
  if isfield(learn_info, 'M') && ~isempty(learn_info.M)
    M               = learn_info.M;
  else
    M               = length(time_vec);
  end
  [y, dy, time_vec] = get_data_in_small_L(y, dy, time_vec, M); 
end
end