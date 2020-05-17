function print_JPL_PI_err(names, PI, PIhat, num_years)
% function print_JPL_PI_err(names, PI, PIhat, num_years)

% (C) M. Zhong

PIerr = abs(PI - PIhat)./abs(PI);
fprintf('\nError for estimating PIs for over %3d years:', num_years);
fprintf('\n        | Aphelion | Perihelion | Orb. Period | Preces. Rate |');
for idx = 1 : size(PI, 1)
  fprintf('\n%8s|%10.4e|%12.4e|%13.4e|%14.4e|', names{idx + 1}, PIerr(idx, 1), PIerr(idx, 2), ...
    PIerr(idx, 3), PIerr(idx, 4));
end
end