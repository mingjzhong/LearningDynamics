function timing_struc =average_timings_over_cpus(timing_struc_cpus)
% function timing_struc =average_timings_over_cpus(timing_struc_cpus)

% (C) M. Zhong (JHU)

timing_struc     = timing_struc_cpus{1};
actual_cpus      = 1;
for cpu_idx = 2 : length(timing_struc_cpus)
  timing_struc_l = timing_struc_cpus{cpu_idx};
  if ~isempty(timing_struc_l)
    timing_struc = add_two_timings(timing_struc_l, timing_struc);
    actual_cpus  = actual_cpus + 1;
  end
end
timing_struc     = average_timings(timing_struc, actual_cpus);
end