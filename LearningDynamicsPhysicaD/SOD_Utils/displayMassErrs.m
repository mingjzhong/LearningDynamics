function displayMassErrs(learningOutput, sys_info)
% function displayMassErrs(learningOutput, sys_info)

% (C) M. Zhong

fprintf('\n------------------- Estimating Masses of Each Astronomical Object (AO):');
for ind = 1 : sys_info.N
  fprintf('\nFor %7s:', sys_info.AO_names{ind});
  fprintf('\n\tTrue Mass = %10.4e.', sys_info.known_mass(ind));
  fprintf('\n\tEst. Mass = %10.4e%c%10.4e.', mean(cellfun(@(x) x.gravity.mass_hat(ind), learningOutput)), ...
    177, std(cellfun(@(x) x.gravity.mass_hat(ind), learningOutput)));  
  fprintf('\n\tRel. Err. = %10.4e%c%10.4e.', mean(cellfun(@(x) x.massErr(ind), learningOutput)), ...
    177, std(cellfun(@(x) x.massErr(ind), learningOutput)));
end