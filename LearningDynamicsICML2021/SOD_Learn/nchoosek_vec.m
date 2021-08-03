function vals = nchoosek_vec(ns, ks)
% function vals = nchoosek_vec(ns, ks)

% (C) M. Zhong

vals = factorial(ns)./(factorial(ks) .* factorial(ns - ks));
end