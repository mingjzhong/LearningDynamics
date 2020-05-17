function PR_model = JPL_periodic_precession_model(beta, t, num_terms, num_peri_terms)
% function PR_model = JPL_periodic_precession_model(beta, t, num_terms, num_peri_terms)

% (C) M. Zhong

switch num_terms
  case 2
    PR_model = beta(1) + beta(2) * t;
  case 3
    PR_model = beta(1) + beta(2) * t + beta(3) * t^.2;
  case 4
    PR_model = beta(1) + beta(2) * t + beta(3) * t^.2 + beta(4) * t.^4;
  otherwise
    error('SOD_JPL_routines:JPL_periodic_precession_model:exception', ...
      'num_terms have to be between 2 and 4!!');
end
for idx = 1 : num_peri_terms
  num_pterms = num_terms + (idx - 1) * 3;
  PR_model   = PR_model + beta(num_pterms + 1) * sin(beta(num_pterms + 2) * t) ...
               + beta(num_pterms + 3) * cos(beta(num_pterms + 2) * t);
end
end