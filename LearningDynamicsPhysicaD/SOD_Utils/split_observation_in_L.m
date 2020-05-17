function [x, v, xi, dot_xv, dot_xi, time_vec] = split_observation_in_L(x, v, xi, dot_xv, dot_xi, ...
                                                time_vec, learn_info)
% function [x, v, xi, dot_xv, dot_xi, time_vec] = split_observation_in_L(x, v, xi, dot_xv, dot_xi, ...
%                                                 time_vec, learn_info)

% (C) M. Zhong

M                                      = size(x, 3);
if M == 1 && isfield(learn_info, 'break_L') && ~isempty(learn_info.break_L) && learn_info.break_L
  if isfield(learn_info, 'M') && ~isempty(learn_info.M)
    M                                  = learn_info.M;
  else
    M                                  = length(time_vec);
  end
  [x, v, xi, dot_xv, dot_xi, time_vec] = get_data_in_small_L(x, v, xi, dot_xv, dot_xi, time_vec, M); 
end
end