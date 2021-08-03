function prob = get_probability_from_rhoLT1D(rhoLT1D, range)
% function prob = get_probability_from_rhoLT1D(rhoLT1D, range)

% (C) M. Zhong

r_range = intersectInterval(rhoLT1D.supp{1}, range);
f       = rhoLT1D.dense;
prob    = integral(f, r_range(1), r_range(2), 'RelTol', 0, 'AbsTol', 1e-12);
end