function time_vec_new = insert_time_vec(time_vec, T)
% function time_vec_new = insert_time_vec(time_vec, T)

% (c) M. Zhong (JHU)
% find out the first time, t_0, such that t_0 >= T
ind                             = find(time_vec >= T, 1);
% check to see if we need to insert T
if time_vec(ind) == T
% T is already saved in time_vec
  time_vec_new                  = time_vec;
else
% now we have to insert T into time_vec
  time_vec_new                  = zeros(1, length(time_vec) + 1);
  time_vec_new(1 : (ind - 1))   = time_vec(1 : (ind - 1));
  time_vec_new(ind)             = T;
  time_vec_new((ind + 1) : end) = time_vec(ind : end);
end
end