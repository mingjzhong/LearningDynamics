function range = get_range_from_rhos(rhoLTemp)
% function range = get_range_from_rhos(rhoLTemp)

% (c) M. Zhong (JHU)


total_num_trials = length(rhoLTemp);
max_rs           = zeros(1, total_num_trials);
min_rs           = zeros(1, total_num_trials);
for ind = 1 : total_num_trials
  min_rs(ind)    = rhoLTemp{ind}.supp(1);
  max_rs(ind)    = rhoLTemp{ind}.supp(2);
end
max_r            = max(max_rs);
min_r            = min(min_rs);
if max_r < min_r + 10 * eps, max_r = min_r + 1; min_r = min_r - 1; end
range            = [min_r, max_r];
end