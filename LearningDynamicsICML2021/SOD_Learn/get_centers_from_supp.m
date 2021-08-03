function ctrs = get_centers_from_supp(supp, relsol)
% function ctrs = get_centers_from_supp(supp, relsol)

% (C) M. Zhong

ctrs = linspace(supp(1), supp(2), relsol + 1);
ctrs = (ctrs(2 : end) + ctrs(1 : end - 1))/2;
end