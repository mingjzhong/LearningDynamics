function theta = set_precession_fit(beta, t, num_perid_terms)
% function theta = set_precession_fit(beta, t, num_perid_terms)

% (C) M. Zhong

theta            = beta(1) + beta(2) * t + beta(3) * t.^2;
if num_perid_terms < 0
  num_perid_terms = 0;
elseif num_perid_terms > 1
  num_perid_terms = 1;
end
for idx = 1 : num_perid_terms
  theta           = theta + beta(3 * idx + 1) * sin(beta(3 * idx + 3) * t) + ...
                    beta(3 * idx + 2) * cos(beta(3 * idx + 3) * t);
end
end