function system_checks(sys_info, obs_info, learningOutput)
%function system_checks(sys_info, obs_info, learningOutput)

% (c) M. Zhong

if ~contains(sys_info.name, 'ModelSelection')
  the_diff = check_rhoLT_independence(sys_info, obs_info.rhoLT);
  fprintf('\nFor %s, the true jiont distribution of (r, \\dot{r}) has:', sys_info.name);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      fprintf('\n  at (%d, %d), the l1 difference is: %10.4e.', k1, k2, the_diff.rhoLTA_diff(k1, k2));
    end
  end
  if sys_info.has_xi
    fprintf('\nThe true joint distribution of (r, \\xi) has:');
    for k1 = 1 : sys_info.K
      for k2 = 1 : sys_info.K
        fprintf('\n  at (%d, %d), the l1 difference is: %10.4e.', k1, k2, the_diff.rhoLTXi_diff(k1, k2));
      end
    end
  end
end

fprintf('\nFor %s, the emprical jiont distribution of (r, \\dot{r}) has:', sys_info.name);
the_diff = cell(1, length(learningOutput));
for idx = 1 : length(learningOutput)
  the_diff{idx} = check_rhoLT_independence(sys_info, learningOutput{idx}.rhoLTemp);
end
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    fprintf('\n  at (%d, %d), the l1 difference is: %10.4e%c%10.4e', k1, k2, ...
    mean(cellfun(@(x) x.rhoLTA_diff(k1, k2), the_diff)), 177, std(cellfun(@(x) x.rhoLTA_diff(k1, k2), the_diff)));
  end
end
if sys_info.has_xi
  fprintf('\nThe empirical joint distribution of (r, \\xi) has:');
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      fprintf('\n  at (%d, %d), the l1 difference is: %10.4e%c%10.4e', k1, k2, ...
      mean(cellfun(@(x) x.rhoLTXi_diff(k1, k2), the_diff)), 177, std(cellfun(@(x) x.rhoLTXi_diff(k1, k2), the_diff)));
    end
  end
end
fprintf('\ndone\n');
end